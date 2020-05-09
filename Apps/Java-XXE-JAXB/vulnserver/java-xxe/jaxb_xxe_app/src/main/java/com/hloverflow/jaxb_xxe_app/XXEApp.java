package com.hloverflow.jaxb_xxe_app;

//File IO
import java.io.FileOutputStream;  
import java.io.File;  
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.nio.charset.StandardCharsets;

//object to xml
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

//xml to object
import javax.xml.bind.Unmarshaller;  
import javax.xml.bind.JAXBException;  


// https://www.javatpoint.com/jaxb-tutorial
public class XXEApp 
{
    public static void main( String[] args )
    {

    	//ConvertObjectToXML();
	update("<!DOCTYPE root [ <!ENTITY lastname \"TEST\" > ]>\n<employee id=\"1\">\n<name>Amy &lastname;</name>\n<salary>6000.0</salary>\n</employee>");
    	
	System.out.println(ConvertXMLtoObject());

    }

    public static void update(String employeeinput){

	try {
		FileWriter myWriter = new FileWriter("temp/employee.xml");
		myWriter.write(employeeinput);
		myWriter.close();
		System.out.println("Successfully wrote to the file.");

	} catch (IOException e) {
		e.printStackTrace();
	}
    }

    public static String retrieve() throws IOException{
    	String output = "";
    	String fileName = "temp/employee.xml";
	File file = new File(fileName);
	FileInputStream fis = new FileInputStream(file);
	InputStreamReader isr = new InputStreamReader(fis, StandardCharsets.UTF_8);
	BufferedReader br = new BufferedReader(isr);

	String line;
	while((line = br.readLine()) != null){
	     //process the line
	     output += line;
	}
	br.close();
	return output;
    }

    // Write to file
    public static String ConvertObjectToXML(){

	String output = "";
    	try{

		JAXBContext contextObj = JAXBContext.newInstance(Employee.class);  
		System.out.println("created contextObj");

		Marshaller marshallerObj = contextObj.createMarshaller();  
		marshallerObj.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);  
		System.out.println("created marshallerObj");

		Employee a = new Employee(1,"Amy",3000);  
		System.out.println("created employee object: id=1, name=Amy, salary=3000");

		marshallerObj.marshal(a, new FileOutputStream("temp/employee.xml"));  
		System.out.println("Wrote into employee.xml");

		output = retrieve();


	}catch(Exception e){
		e.printStackTrace();
		output = e.toString();
	}finally{
		return output;
	}

    }

    // load from file
    public static String ConvertXMLtoObject(){

	String output = "";

    	try{

		//Explicitly turn on External DTD access
		System.setProperty("javax.xml.accessExternalDTD", "all");


    		JAXBContext contextObj = JAXBContext.newInstance(Employee.class);        		
    		Unmarshaller jaxbUnmarshaller = contextObj.createUnmarshaller();

		File file = new File("temp/employee.xml");
    		Employee employee =(Employee) jaxbUnmarshaller.unmarshal(file);

    		output = "Employee object:" + 
    			"  id=" + employee.getId() + 
    			", name=" + employee.getName() + 
    			", salary=" + employee.getSalary();


    	}catch(JAXBException e) {
    		e.printStackTrace();
		output = e.toString();
    	}finally{
		return output;
	}

    }
}
