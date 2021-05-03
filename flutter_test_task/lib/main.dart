import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomNumber(),
    );
  }
}

class RandomNumber extends StatefulWidget {
  @override
  _RandomNumberState createState() => _RandomNumberState();
}

class _RandomNumberState extends State<RandomNumber> {
  final String apiUrl = "https://csrng.net/csrng/csrng.php?min=1&max=100";
  String randomNumberText = '';
  List<int> numbers = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<int> fetchNumber() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)[0]['random'];
  }

  void onClick() async {
    int randomNumber = await fetchNumber();
    setState(() {
      numbers.add(randomNumber);
      randomNumberText = randomNumber.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.blueGrey,
              height: 50,
              child: TextButton(
                onPressed: onClick,
                child: Text("Generate random number",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                randomNumberText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text('Previous numbers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (var item in numbers)
                  Text(
                    item.toString(),
                    textAlign: TextAlign.center,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
