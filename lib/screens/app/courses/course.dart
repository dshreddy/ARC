import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import '../../../imports.dart';

class Course extends StatefulWidget {
  const Course({super.key, required this.course});

  static const id = "course_screen";
  final String course;

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late String course_id;
  late int total_classes = 0;
  late int total_presents = 0;
  late int total_percent = 0;
  late var userName;
  List<List<dynamic>> studentList = [];
  List<List<dynamic>> dates_status = [];
  bool showSpinner = false;
  var course_name = "None";
  late String role;

  @override
  void initState() {
    super.initState();
    course_name = widget.course;
    course_id = widget.course;
    role = Provider.of<UserProvider>(context, listen: false).role;
    userName = Provider.of<UserProvider>(context, listen: false).userName;
    getStudents();
    getAttendanceStatus();
  }

  Future<void> getStudents() async {
    setState(() {
      showSpinner = true;
    });

    var url = '${kServerUrl}fetch/students/$course_id';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String data = response.body;
        Map<String, dynamic> jsonData = jsonDecode(data);
        setState(() {
          for (var i = 0; i < jsonData["name"].length; i++) {
            studentList.add([
              jsonData["name"][i],
              jsonData["rollno"][i].toString(),
              jsonData["attendance"][i].toString(),
            ]);
          }
        });
      } else {
        alert(context, "Error: ${response.statusCode}");
      }
    } catch (e) {
      alert(context, "Exception during HTTP request: $e");
    }

    setState(() {
      showSpinner = false;
    });
  }

  Future<void> getAttendanceStatus() async {
    setState(() {
      showSpinner = true;
    });

    dates_status = [];
    var url = '${kServerUrl}check/$userName/$course_id';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String data = response.body;
        Map<String, dynamic> jsonData = jsonDecode(data);
        setState(() {
          total_classes = jsonData["total_classes_taken"];
          total_presents = jsonData["total_classes_present"];
          total_percent = jsonData["percentage_attendance"];

          for (var i = 0; i < jsonData["date"].length; i++) {
            dates_status.add([
              jsonData["date"][i].toString(),
              jsonData["status"][i].toString()
            ]);
          }
        });
      } else {
        alert(context, "Error: ${response.statusCode}");
      }
    } catch (e) {
      alert(context, "Exception during HTTP request: $e");
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.course),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (role == kTeacher) ...[
                  kStyledButton(
                      text: "Student Register",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentRegister(
                              name: widget.course,
                              data: studentList,
                            ),
                          ),
                        );
                      }),
                  kStyledButton(
                      text: "Attendance Register",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceRegister(
                              courseID: widget.course,
                            ),
                          ),
                        );
                      }),
                  kStyledButton(
                      text: "Take Attendance",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakeAttendance(
                              courseName: course_name,
                            ),
                          ),
                        );
                      }),
                ] else ...[
                  kStyledButton(
                    text: "My Attendance",
                    btnIcon:
                        CupertinoIcons.person_crop_circle_fill_badge_checkmark,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentAttendanceScreen(
                            name: "Sai Hemanth Reddy",
                            statistics: {
                              'total_classes': total_classes,
                              'total_present': total_presents,
                              'percentage': total_percent,
                            },
                            data: dates_status,
                            course_id: course_id,
                          ),
                        ),
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
