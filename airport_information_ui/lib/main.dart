import 'dart:convert';
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
          title: Text('Airport Information'),
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

  Future getReport() async {
    var url = Uri.base.toString();
    //var url = 'http://ayxrunner.tlarsendataguy.com/AirportInfo';
    if (url.endsWith('/')) url = url.substring(0, url.length-1);
    if (url.endsWith('#')) url = url.substring(0, url.length-1);
    if (url.endsWith('/')) url = url.substring(0, url.length-1);
    var uri = Uri.parse(url);
    setState(()=>isRunning = true);
    http.Response response;
    try {
      response = await http.post(
        uri,
        headers: <String,String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: '{"LeftId":"${leftController.text}","RightId":"${rightController.text}"}',
      );
    } catch (ex, trace) {
      print(trace);
      error = ex.toString();
      setState(()=>isRunning = false);
      return;
    }

    if (response.statusCode != 200) {
      error = response.body;
      setState(()=>isRunning = false);
      return;
    }
    error = '';
    var jsonResponse = jsonDecode(response.body);
    var outputFile = jsonResponse['OutputFiles'][0];
    var outputUrl = '$url$outputFile';
    html.window.open(outputUrl, '_blank');
    setState(()=>isRunning = false);
  }

  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: Column(
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
            TextButton(
              onPressed: isRunning ? null : getReport,
              child: Center(
                child: Row(
                  children: [
                    Text("Get report"),
                    SizedBox(
                      height: 30,
                      child: isRunning ? CircularProgressIndicator() : null,
                    )
                  ],
                ),
              ),
            ),
            Text(error),
          ],
        ),
      ),
    );
  }
}
