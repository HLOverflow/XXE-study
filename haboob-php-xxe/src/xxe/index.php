
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<head>
<title>Login Now</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="styles/layout.css" type="text/css" media="all">
<link rel="stylesheet" href="styles/mediaqueries.css" type="text/css" media="all">
<style type="text/css">
div.full_width{margin-top:20px;}
div.full_width:first-child{margin-top:0;}
div.full_width div{color:#666666; background-color:#DEDEDE;}
</style>
<script type="text/javascript" src="scripts/jquery.min.js"></script>
<script type="text/javascript">
function XMLFunction(){
    var xml = '' +
        '<?xml version="1.0" encoding="UTF-8"?>' +
        '<root>' +
        '<name>' + $('#name').val() + '</name>' +
        '<password>' + $('#password').val() + '</password>' +
        '</root>';
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if(xmlhttp.readyState == 4){
            console.log(xmlhttp.readyState);
            console.log(xmlhttp.responseText);
            document.getElementById('errorMessage').innerHTML = xmlhttp.responseText;
        }
    }
    xmlhttp.open("POST","xxe.php",true);
    xmlhttp.send(xml);
};
</script>

<style type="text/css">
h1, form, fieldset, input {
    margin: 0;
    padding: 0;
    border: none;
}
#registration {
    color: #fff;
    background: #2d2d2d;
    background: -webkit-gradient(
    color-stop(0, rgb(60,60,60)),
    color-stop(0.74, rgb(43,43,43)),
    color-stop(1, rgb(60,60,60))
    );
    background: -moz-linear-gradient(
    rgb(60,60,60) 0%,
    rgb(43,43,43) 74%,
    rgb(60,60,60) 100%
    );
    -moz-border-radius: 10px;
    -webkit-border-radius: 10px;
    position: absolute;
    left: 30%;
}
#registration a {
    color: #8c910b;
    text-shadow: 0px -1px 0px #000;
}

#registration fieldset {
    padding: 20px;
}

input.text {
    -webkit-border-radius: 15px;
    -moz-border-radius: 15px;
    border-radius: 15px;
    border:solid 1px #444;
    font-size: 14px;
    width: 90%;
    padding: 7px 8px 7px 30px;
    -moz-box-shadow: 0px 1px 0px #777;
    -webkit-box-shadow: 0px 1px 0px #777;
    background: #ddd url('img/inputSprite.png') no-repeat 4px 5px;
    background: url('img/inputSprite.png') no-repeat 4px 5px,
    -moz-linear-gradient(
    center bottom,
    rgb(225,225,225) 0%,
    rgb(215,215,215) 54%,
    rgb(173,173,173) 100%
    );
    background: url('img/inputSprite.png') no-repeat 4px 5px,
    -webkit-gradient(
    linear,
    left bottom,
    left top,
    color-stop(0, rgb(225,225,225)),
    color-stop(0.54, rgb(215,215,215)),
    color-stop(1, rgb(173,173,173))
    );
    color:#333;
    text-shadow:0px 1px 0px #FFF;
}
input#email {
    background-position: 4px 5px;
    background-position: 4px 5px, 0px 0px;
}

input#name {
    background-position: 4px -46px;
    background-position: 4px -46px, 0px 0px;
}

input#password {
    background-position: 4px -20px;
    background-position: 4px -20px, 0px 0px;
}

input#conpassword {
    background-position: 4px -20px;
    background-position: 4px -20px, 0px 0px;
}

#registration h2 {
    color: #fff;
    text-shadow: 0px -1px 0px #000;
    border-bottom: solid #181818 1px;
    -moz-box-shadow: 0px 1px 0px #3a3a3a;
    text-align: center;
    padding: 18px;
    margin: 0px;
    font-weight: normal;
    font-size: 24px;
    font-family: Lucida Grande, Helvetica, Arial, sans-serif;
}

#errorMessage {
    color: red;
    font-style: italic;
    font-size: 1.5 em;
}
#registerNew {
    width: 203px;
    height: 40px;
    border: none;
    text-indent: -9999px;
    background: url('img/createAccountButton.png') no-repeat;
    cursor: pointer;
    float: right;
}

#registerNew:hover { background-position: 0px -41px; }
#registerNew:active { background-position: 0px -82px; }

#registration p {
    position: relative;
}

fieldset label.infield /* .infield label added by JS */ {
    color: #333;
    text-shadow: 0px 1px 0px #fff;
    position: absolute;
    text-align: centre;
    top: 3px !important;
    left: 35px !important;
    line-height: 29px;
}
</style>
</head>
<body>
<div class="wrapper row1">
  <header id="header" class="clear">
    <div id="hgroup">
      <h1><a href="#">Login If You Can</a></h1>
      <h2></h2>
    </div>
  </header>
</div>
<!-- ################################################################################################ -->
<div class="wrapper row2">
  <nav id="topnav">
    <ul class="clear">
      </li>
    </ul>
  </nav>
</div>
<center>
    <h2><div id="errorMessage" color="red"></div></h2>
    <div id="registration">
        <h2>Login</h2>
        <div id="RegisterUserForm">
            <fieldset>
                <p>
                <label for="name">Name</label>
                <input id="name" name="name" type="text" class="text"
                value="" />
                </p>
                <p>
                <label for="password">Password</label>
                <input id="password" name="password" class="text"
                type="password" />
                </p>

                <p>
                <button id="Login"
                    onclick="XMLFunction()">Login</button>
                </p>
            </fieldset>
        </div>
    </div>
</center>
