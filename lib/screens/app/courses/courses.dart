import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../imports.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  static const id = "dash_board";
  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  bool showSpinner = false;
  late String role;
  late String userName;
  var courseList = [];

  @override
  void initState() {
    super.initState();

    userName = Provider.of<UserProvider>(context, listen: false).userName;
    role = Provider.of<UserProvider>(context, listen: false).role;
    getCourses();
  }

  Future getCourses() async {
    setState(() {
      showSpinner = true;
    });

    var url = role == kStudent
        ? '${kServerUrl}student/$userName'
        : '${kServerUrl}teacher/$userName';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      Map<String, dynamic> jsonData = jsonDecode(data);
      List<String> temp = [];
      for (var i = 0; i < jsonData["course_id"].length; i++) {
        String course = jsonData["course_id"][i];
        if (!temp.contains(course)) {
          temp.add(course);
        }
      }

      setState(() {
        courseList = temp;
      });
    } else {
      alert(context, 'status code: $response.statusCode');
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                      itemCount: courseList.length,
                      itemBuilder: (context, index) {
                        var course = courseList[index];
                        return Container(
                          height: 80,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: kDarkBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Course(course: course.split(" ")[0]);
                                  },
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  course,
                                  style: GoogleFonts.robotoSlab(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  color: Colors.white38,
                                  onPressed: () {
                                    _deleteCourse(course.split(" ")[0]);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteCourse(String courseID) async {
    setState(() {
      showSpinner = true;
    });

    var url = '${kServerUrl}deleteCourse/$role/$userName/$courseID';

    try {
      var response = await http.delete(Uri.parse(url));

      if (response.statusCode != 200) {
        alert(context, 'status code : ${response.statusCode}');
      }
    } catch (e) {
      alert(context, '$e');
    }

    getCourses();

    setState(() {
      showSpinner = false;
    });
  }
}
