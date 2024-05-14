import 'package:http/http.dart' as http;
import '../../imports.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({Key? key}) : super(key: key);
  static const id = "add_course_screen";

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  bool showSpinner = false;
  List<DropdownMenuItem<String>> existingCourses = [];
  String selectedCourse = "None";
  late String rollNumber;
  late String role;

  @override
  void initState() {
    super.initState();

    rollNumber = Provider.of<UserProvider>(context, listen: false).userName;
    role = Provider.of<UserProvider>(context, listen: false).role;
    getExistingCourses();
  }

  Future<void> getExistingCourses() async {
    setState(() {
      showSpinner = true;
    });

    try {
      var url = '${kServerUrl}student/allcourses';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String data = response.body;
        Map<String, dynamic> jsonData = jsonDecode(data);
        List<String> courses = [];
        for (var i = 0; i < jsonData["id"].length; i++) {
          String newCourse =
              jsonData['id'][i] + " " + jsonData['name'][i].toString();
          courses.add(newCourse);
        }
        setState(() {
          existingCourses.clear(); // Clear existing items
          existingCourses.add(const DropdownMenuItem<String>(
            value: "None",
            child: Text("None"),
          ));
          existingCourses
              .addAll(courses.map((course) => DropdownMenuItem<String>(
                    value: course,
                    child: Text(course),
                  )));
          selectedCourse = existingCourses.first.value!;
        });
        selectedCourse = existingCourses.first.value!;
      } else {
        alert(context, 'Error 404');
      }
    } catch (e) {
      alert(context, 'Error 404');
    }

    setState(() {
      showSpinner = false;
    });
  }

  Future<void> addToTakes() async {
    setState(() {
      showSpinner = true;
    });

    try {
      String updatedSelectedCourse = selectedCourse.split(" ")[0];
      var url = role == kStudent
          ? '$kServerUrl$rollNumber/add/$updatedSelectedCourse'
          : '${kServerUrl}teacher/$rollNumber/add/$updatedSelectedCourse';
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mail': rollNumber,
          'id': updatedSelectedCourse,
        }),
      );

      if (response.statusCode == 200) {
        alert(context, "Successfully added");
      } else {
        alert(context, 'Course Already exists');
      }
    } catch (e) {
      alert(context, '$e');
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select an Existing Course',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  value: selectedCourse,
                  items: existingCourses,
                  onChanged: (value) {
                    if (value != null && value != selectedCourse) {
                      setState(() {
                        selectedCourse = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              kStyledButton(
                text: "Submit",
                btnIcon: Icons.save_alt_outlined,
                onPressed: () {
                  if (selectedCourse != "None") {
                    addToTakes();
                  } else {
                    alert(context, "No course selected");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
