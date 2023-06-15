import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutineCard extends StatefulWidget {
  final String apiUrl;

  const RoutineCard({Key? key, required this.apiUrl}) : super(key: key);

  @override
  _RoutineCardState createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard> {
  String _dayOfWeek = DateFormat('EEEE').format(DateTime.now());
  List<dynamic>? _routineList;
  late SharedPreferences _preferences;
  String? _batch;
  String? _section;

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _batch = _preferences.getString('batch');
      _section = _preferences.getString('section');

    });
    _fetchRoutine();
  }

  _fetchRoutine() async {
    if (_dayOfWeek == 'Saturday') {
      setState(() {
        _routineList = null;
      });
      return;
    }

    String apiUrl ='https://acem-mis.cyclic.app/api/routine/$_batch/$_section/$_dayOfWeek';
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _routineList = data['timetable'][0]['routine'];
      });
    } else {
      print('Error fetching routine');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _routineList == null
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 35),
      child: Text(
        'It\'s Saturday, Happy Holiday!',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
    )
        : Container(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _routineList!.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(_routineList![index]['subject']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teacher: ${_routineList![index]['teacherName']}'),
                      Text('Time: ${_routineList![index]['starttime']} - ${_routineList![index]['endtime']}'),
                      Text('Room: ${_routineList![index]['roomNo']}'),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }
}
