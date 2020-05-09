package com.hloverflow.jaxb_xxe_app;

import javax.xml.bind.annotation.XmlAttribute;  
import javax.xml.bind.annotation.XmlElement;  
import javax.xml.bind.annotation.XmlRootElement;  
  
@XmlRootElement  
public class Employee {  
    private int id;  
    private String name;  
    private float salary;  
  
    public Employee() {}  
    public Employee(int id, String name, float salary) {  
        super();  
        this.id = id;  
        this.name = name;  
        this.salary = salary;  
    }

    @XmlAttribute  
    public int getId() {  
        return id;  
    }  

    public void setId(int id) {  
        this.id = id;  
    }

    @XmlElement  
    public String getName() {  
        return name;  
    }  

    public void setName(String name) {  
        this.name = name;  
    }  

    @XmlElement  
    public float getSalary() {  
        return salary;  
    }  

    public void setSalary(float salary) {  
        this.salary = salary;  
    }  
}