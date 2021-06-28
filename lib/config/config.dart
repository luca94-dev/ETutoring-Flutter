import 'dart:convert';

// SERVER IP
const String authority = 'www.e-tutoring-app.it';
// SERVER LOGIN API URL
const String unencodedPath = 'ws/';

const String username = '10667775@aruba.it';
const String password = 'ab12pozt12Q!!';
String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
