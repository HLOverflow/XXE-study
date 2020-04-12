package com.hloverflow.jaxb_xxe_app;

//object to xml
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import java.io.FileOutputStream;  

//xml to object
import javax.xml.bind.Unmarshaller;  
import javax.xml.bind.JAXBException;  
import java.io.File;  

// https://www.javatpoint.com/jaxb-tutorial
public class App 
{
    public static void main( String[] args )
    {

    	//ConvertObjectToXML();
    	ConvertXMLtoObject();

    }

    public static void ConvertObjectToXML(){

    	try{

			JAXBContext contextObj = JAXBContext.newInstance(Employee.class);  
			System.out.println("created contextObj");

			Marshaller marshallerObj = contextObj.createMarshaller();  
			marshallerObj.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);  
			System.out.println("created marshallerObj");

			Employee a = new Employee(1,"Amy",3000);  
			System.out.println("created employee object: id=1, name=Amy, salary=3000");

			marshallerObj.marshal(a, new FileOutputStream("employee.xml"));  
			System.out.println("Wrote into employee.xml");

		}catch(Exception e){
    		e.printStackTrace();
		}

    }

    public static void ConvertXMLtoObject(){

    	try{


    		JAXBContext contextObj = JAXBContext.newInstance(Employee.class);        		
    		Unmarshaller jaxbUnmarshaller = contextObj.createUnmarshaller();

			File file = new File("employee.xml");
    		Employee employee =(Employee) jaxbUnmarshaller.unmarshal(file);

    		System.out.println( "Employee object:" + 
    			"  id=" + employee.getId() + 
    			", name=" + employee.getName() + 
    			", salary=" + employee.getSalary());

    	}catch(JAXBException e) {
    		e.printStackTrace();
    	}

    }
}
