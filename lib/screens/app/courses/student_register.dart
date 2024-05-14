import 'package:automatic_classroom_attendance_system/widgets/student_register_row.dart';
import 'package:flutter/material.dart';

class StudentRegister extends StatelessWidget {
  // Assuming data is a list of lists containing student information
  final String name;
  final List<List<dynamic>> data;

  const StudentRegister({super.key, required this.name, required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Register'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              for (int i = 0; i < data.length; i++)
                StudentRegisterRow(
                  name: data[i][0],
                  rollNumber: data[i][1],
                  attendance: data[i][2],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
