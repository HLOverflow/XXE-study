<!DOCTYPE html>
<html lang="en">
<head>
    <title>XXE App</title>
    <%@ page import="com.google.common.html.HtmlEscapers, com.hloverflow.jaxb_xxe_app.XXEApp" %>
</head>

<body>

    <p>Update Employee status</p>
   
    <p>Import Employee status via XML format</p>
    <form method="POST" action="">
    	<%! String xmlvalue; %>
	<%! String escapedxml; %>
	<% 
		xmlvalue = XXEApp.retrieve();
		escapedxml = HtmlEscapers.htmlEscaper().escape( xmlvalue );

	%>
    	<input type="text" size=64 name="xmlinput" value="<%= escapedxml %>"/>
	<input type="submit" value="Update" />
    </form>


    <div>
    <p>Received</p>
    <% 
    	String xmlinput = request.getParameter("xmlinput");
	if( xmlinput != null ){

		XXEApp.update(xmlinput);
		xmlvalue = XXEApp.ConvertXMLtoObject();
		escapedxml = HtmlEscapers.htmlEscaper().escape( xmlvalue );

	}else{
		escapedxml = "Empty";
	}
    %>
    <p><%= escapedxml %></p>
    </div>

</body>
</html>
