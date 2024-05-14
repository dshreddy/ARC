import '../../../imports.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final String name;
  final Map<String, dynamic> statistics;
  final List<List<dynamic>> data;
  final String course_id;

  const StudentAttendanceScreen({
    super.key,
    required this.name,
    required this.statistics,
    required this.data,
    required this.course_id,
  });

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Attendance Statistics',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Total Classes Taken')),
                    DataCell(Text('${widget.statistics['total_classes']}')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Total Classes Present')),
                    DataCell(Text('${widget.statistics['total_present']}')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Attendance Percentage')),
                    DataCell(Text('${widget.statistics['percentage']}%')),
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Daily Attendance',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      // horizontalTitleGap: 1,
                      // minLeadingWidth: 1,
                      // title: Text('${data[index][0]}'), //Date
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.data[index][0]}'),
                          if (widget.data[index][1] == '1')
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
                          // kStyledButton(
                          //     width: 130,
                          //     height: 50,
                          //     text: "Report",
                          //     btnIcon: Icons.report,
                          //     btnColor: kLightishBluishBg,
                          //     btnTextColor: Colors.black,
                          //     onPressed: () async {
                          //       var url = '${kServerUrl}report';
                          //       String jsonBody = json.encode({
                          //         "roll_num": widget.name,
                          //         "course_id": widget.course_id,
                          //       });
                          //       var response = await http.post(Uri.parse(url),
                          //           headers: <String, String>{
                          //             'Content-Type':
                          //                 'application/json; charset=UTF-8',
                          //           },
                          //           body: jsonBody);
                          //
                          //       if (!(response.statusCode == 200)) {
                          //         alert(context, '${response.statusCode}');
                          //       }
                          //     }),
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
    );
  }
}
