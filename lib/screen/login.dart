import 'package:acem/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "Error! Please try again";
  String _userId = "";
  String _cid = "";
  String _profile = "";
  String _batch = "";
  String _section = "";

  @override
  void initState() {
    super.initState();
    _errorMessage = '';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await http.post(
      Uri.parse('https://acem-mis.cyclic.app/Login'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "email": emailController.text,
        "cid": passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      _userId = jsonResponse['_id'];
      _cid = jsonResponse['cid'];
      _profile = jsonResponse['profile'];
      _batch = jsonResponse['batch'];
      _section = jsonResponse['section'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', _userId);
      prefs.setString('profile', _profile);
      prefs.setString('batch', _batch);
      prefs.setString('section', _section);
      prefs.setString('cid', _cid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://res.cloudinary.com/dccfwpjon/image/upload/v1678897087/advancedcollege_xlibc3.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            height: 450,
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white54.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: NetworkImage(
                      'https://acem.edu.np/uploads/news/image/Advanced%20Logo-01%20%20small_20220319100019.jpg',
                    ),
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'WELCOME',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        letterSpacing: -2,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(15.0),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(15.0),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                      'Login',
                      style: TextStyle(),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
