import 'package:acem/screen/login.dart';
import 'package:flutter/material.dart';



void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home:LoginPage(),
    );
  }
}
