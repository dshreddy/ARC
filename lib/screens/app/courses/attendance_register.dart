import '../../../imports.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AttendanceRegister extends StatefulWidget {
  final String courseID;
  const AttendanceRegister({Key? key, required this.courseID})
      : super(key: key);

  @override
  _AttendanceRegisterState createState() => _AttendanceRegisterState();
}

class _AttendanceRegisterState extends State<AttendanceRegister> {
  bool showSpinner = false;
  DateTime? selectedDate = DateTime.now();
  List<List<String>> rows = [];

  @override
  void initState() {
    super.initState();

    getRecord(DateFormat('yyyy-MM-dd').format(DateTime.now()), widget.courseID);
  }

  Future getRecord(selectedDate, courseID) async {
    setState(() {
      showSpinner = true;
    });

    try {
      var url = '${kServerUrl}fetch/attendance/$courseID/$selectedDate';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String data = response.body;
        Map<String, dynamic> jsonData = jsonDecode(data);
        List<List<String>> temp = [];
        for (var i = 0; i < jsonData["attendance"].length; i++) {
          temp.insert(
              0, [jsonData["name"][i], jsonData["attendance"][i].toString()]);
        }
        setState(() {
          rows = temp;
        });
      } else {
        alert(context, response.statusCode as String);
      }
    } catch (e) {
      alert(context, 'server error');
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
          title: const Text('Attendance Register'),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: ThemeData(
                    primaryColor: kDarkBlue,
                    splashColor: kDarkBlue,
                    colorScheme: const ColorScheme.light(
                        primary: kDarkBlue,
                        onSecondary: Colors.black,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                        secondary: Colors.white),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    initialValue: selectedDate,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Select Date',
                      labelStyle: TextStyle(color: kDarkBlue),
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        top: 15.0,
                        bottom: 15.0,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kDarkBlue),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kDarkBlue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kDarkBlue),
                      ),
                    ),
                    onChanged: (DateTime? value) {
                      setState(() {
                        selectedDate =
                            value; // Assign the DateTime value directly
                        // Example of formatting the date as a string
                        String formattedDate = value != null
                            ? DateFormat('yyyy-MM-dd').format(value)
                            : ''; // Handle the case where value is null

                        rows = [];
                        getRecord(formattedDate, widget.courseID);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(rows[index][0])),
                            if (rows[index][1] == '1')
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            else
                              const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            // const SizedBox(width: 18),
                            Flexible(
                              child: kStyledButton(
                                height: 50,
                                text: "Update",
                                btnIcon: Icons.update,
                                btnColor: kLightishBluishBg,
                                btnTextColor: Colors.black,
                                onPressed: () async {
                                  // Call updateAttendance function when button is pressed
                                  await _updateAttendance(
                                    rows[index][0], // Student email
                                    rows[index][1] == '1'
                                        ? 0
                                        : 1, // Current attendance status
                                    selectedDate!, // Selected date
                                  );
                                  // Refresh the UI after updating attendance
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateAttendance(
      String userName, int status, DateTime date) async {
    setState(() {
      showSpinner = true;
    });

    try {
      var url =
          '${kServerUrl}updateAttendance/$userName/${widget.courseID}/${date.toString()}/$status';
      var response = await http.post(Uri.parse(url));

      if (response.statusCode != 200) {
        alert(context, "request error");
      }
    } catch (e) {
      alert(context, "server error");
    }

    getRecord(DateFormat('yyyy-MM-dd').format(date), widget.courseID);

    setState(() {
      showSpinner = false;
    });
  }
}
