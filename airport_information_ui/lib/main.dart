import 'dart:convert';
import 'package:airport_information_ui/parse_json.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airport Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Airport Information')),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController leftController = TextEditingController(text: '');
  TextEditingController rightController = TextEditingController(text: '');
  bool isRunning = false;
  String error = '';
  String warning = '';

  Future getReport() async {
    var url = Uri.base.toString();
    if (url.endsWith('/')) url = url.substring(0, url.length-1);
    if (url.endsWith('#')) url = url.substring(0, url.length-1);
    if (url.endsWith('/')) url = url.substring(0, url.length-1);
    var uri = Uri.parse(url);
    setState(()=>isRunning = true);
    http.Response response;
    var body = jsonEncode({'LeftId': leftController.text, 'RightId':rightController.text});
    try {
      response = await http.post(
        uri,
        headers: <String,String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );
    } catch (ex, trace) {
      print(trace);
      error = "Errors:\n${ex.toString()}";
      warning = '';
      setState(()=>isRunning = false);
      return;
    }

    if (response.statusCode != 200) {
      error = "Errors:\n${response.body}";
      warning = '';
      setState(()=>isRunning = false);
      return;
    }

    var responseData = parseJsonResponse(response.body);
    error = responseData.errors.join('\n');
    if (error != '') {
      error = "Errors:\n$error";
    }
    warning = responseData.warnings.join('\n');
    if (warning != '') {
      warning = "Warnings:\n$warning";
    }
    if (responseData.outputFiles.length > 0) {
      var outputFile = responseData.outputFiles[0];
      var outputUrl = '$url$outputFile';
      html.window.open(outputUrl, '_blank');
    }
    setState(()=>isRunning = false);
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: leftController,
                      decoration: InputDecoration(
                        labelText: "Left Airport ID",
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      controller: rightController,
                      decoration: InputDecoration(
                        labelText: "Right Airport ID",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: isRunning ? null : getReport,
                child: Center(
                  child: Row(
                    children: [
                      Text("Get report"),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: isRunning ? CircularProgressIndicator() : null,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(error, softWrap: true, maxLines: 100, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              Text(warning, softWrap: true, maxLines: 100, style: TextStyle(color: Colors.yellow)),
            ],
          ),
        ),
      ),
    );
  }
}
