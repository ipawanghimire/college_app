import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _id = '';

  String _name = '';
  String _cid = '';
  String _email = '';
  String _profile = '';
  String _batch = '';
  String _faculty = '';
  String _section = '';
  String _location = '';
  String _gender = '';
  String _dob = '';
  String _height = '';
  String _weight = '';
  String _bloodgroup = '';
  String _hometown = '';
  String _contact = '';
  String _fathername = '';
  String _mothername = '';
  String _fathercontact = '';

  @override
  void initState() {
    super.initState();
    _loadIdFromPrefs();
  }

  _loadIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = (prefs.getString('userId') ?? '');
    });
    _fetchStudentDetails();
  }

  _fetchStudentDetails() async {
    final response =
    await http.get(Uri.parse('https://acem-mis.cyclic.app/api/students/$_id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _name = data['name'];
        _cid = data['cid'];
        _email = data['email'];
        _profile = data['profile'];
        _batch = data['batch'];
        _faculty = data['faculty'];
        _section = data['section'];
        _location = data['location'];
        _gender = data['gender'];
        _dob = data['Dob'];
        _height = data['height'];
        _weight = data['weight'];
        _bloodgroup = data['bloodgroup'];
        _hometown = data['hometown'];
        _contact = data['contact'];
        _fathername = data['fathername'];
        _mothername = data['mothername'];
        _fathercontact = data['fathercontact'];
      });
    } else {
      throw Exception('Failed to fetch student details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(_profile),
              ),
              SizedBox(height: 20),
              Text(
                _name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'CID: $_cid',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Email: $_email',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.grey[400],
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: 20),
              _buildProfileInfo('Batch', _batch),
              SizedBox(height: 10),
              _buildProfileInfo('Faculty', _faculty),
              SizedBox(height: 10),
              _buildProfileInfo('Section', _section),
              SizedBox(height: 10),
              _buildProfileInfo('Location', _location),
              SizedBox(height: 10),
              _buildProfileInfo('Gender', _gender),
              SizedBox(height: 10),
              _buildProfileInfo('Date of Birth', _dob),
              SizedBox(height: 10),
              _buildProfileInfo('Height', _height),
              SizedBox(height: 10),
              _buildProfileInfo('Weight', _weight),
              SizedBox(height: 10),
              _buildProfileInfo('Blood Group', _bloodgroup),
              SizedBox(height: 10),
              _buildProfileInfo('Hometown', _hometown),
              SizedBox(height: 10),
              _buildProfileInfo('Contact', _contact),
              SizedBox(height: 10),
              _buildProfileInfo("Father's Name", _fathername),
              SizedBox(height: 10),
              _buildProfileInfo("Mother's Name", _mothername),
              SizedBox(height: 10),
              _buildProfileInfo("Father's Contact", _fathercontact),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await clearPrefs();
                },
                child: Text('Logout'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
  clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }
}
