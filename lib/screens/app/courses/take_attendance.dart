import 'package:automatic_classroom_attendance_system/imports.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:intl/intl.dart';

class TakeAttendance extends StatefulWidget {
  final String courseName;
  const TakeAttendance({super.key, required this.courseName});

  @override
  State<TakeAttendance> createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  bool showSpinner = false;
  var selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Take Attendance',
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DateTimeFormField(
                  mode: DateTimeFieldPickerMode.date,
                  initialValue: selectedDate,
                  decoration: const InputDecoration(
                    labelText: 'Enter Date',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  onChanged: (DateTime? value) {
                    selectedDate = value!;
                  },
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 5),
                if (_imageFile == null)
                  // show image not found
                  const Flexible(
                      child: Image(
                          image: AssetImage("assets/images/notfound.jpeg")))
                else
                  // Show the image uploaded
                  Flexible(
                      child: Image.file(File(_imageFile!.path), height: 150)),
                const SizedBox(height: 5),
                kStyledButton(
                  text: "Take Photo",
                  onPressed: () async {
                    await _uploadPhoto(context);
                  },
                ),
                kStyledButton(
                  text: "Upload To Drive",
                  onPressed: () async {
                    if (_imageFile != null) {
                      _uploadToDrive();
                    } else {
                      alert(context, "Image can't be null");
                    }
                  },
                ),
                kStyledButton(
                  text: "Send To Backend",
                  onPressed: () async {
                    if (_imageFile != null) {
                      _sendToBackend();
                    } else {
                      alert(context, "Image can't be null");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<void> _openGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<void> _uploadPhoto(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload Photo"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: const Text("Take a Picture"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openCamera();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text("Choose from Gallery"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendToBackend() async {
    setState(() {
      showSpinner = true;
    });

    try {
      final bytes = await io.File(_imageFile!.path).readAsBytes();
      String img64 = base64Encode(bytes);
      http.Response response =
          await http.post(Uri.parse("$kServerUrl/classImage"),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "ImageId": widget.courseName,
                "ImagePath": img64,
                "date": selectedDate.toString(),
              }));

      if (response.statusCode == 200) {
        alert(context, "Success");
      } else {
        alert(context, "Failure");
      }
    } catch (e) {
      alert(context, "Error reaching server");
    }

    setState(() {
      showSpinner = false;
    });
  }

  Future<void> _uploadToDrive() async {
    setState(() {
      showSpinner = true;
    });

    try {
      await uploadImageToDrive(File(_imageFile!.path), widget.courseName);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }

    setState(() {
      showSpinner = false;
    });
  }

  Future<void> uploadImageToDrive(File imageFile, String courseNum) async {
    final serviceAccountCredentials = await getServiceAccountCredentials();

    final client = await clientViaServiceAccount(serviceAccountCredentials, [
      drive.DriveApi.driveScope,
    ]);

    final driveApi = drive.DriveApi(client);
    final now = selectedDate;
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss')
        .format(now); // Format the timestamp as desired
    final imageFileName = '{$courseNum}_$timestamp.jpg';
    final imageBytes = await imageFile.readAsBytes();

    // Search for the folder named "camera_photos"
    var folderId = await getFolderId(driveApi, "Camera_photos");

    if (folderId == null) {
      print("Folder not found!");
      return;
    }

    final media = drive.Media(imageFile.openRead(), imageBytes.length);

    await driveApi.files.create(
      drive.File()
        ..name = imageFileName
        ..parents = [folderId],
      uploadMedia: media,
    );

    client.close();
  }

  Future<ServiceAccountCredentials> getServiceAccountCredentials() async {
    final jsonString =
        await rootBundle.loadString('assets/oelp-414905-f8a2167cc383.json');

    print(jsonString);
    final jsonData = json.decode(jsonString);
    return ServiceAccountCredentials.fromJson(jsonData);
  }

  Future<String?> getFolderId(
      drive.DriveApi driveApi, String folderName) async {
    try {
      final response = await driveApi.files.list(
          q: "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder'");
      if (response.files != null && response.files!.isNotEmpty) {
        return response.files!.first.id;
      }
    } catch (e) {
      print("Error fetching folder ID: $e");
    }
    return null;
  }
}
