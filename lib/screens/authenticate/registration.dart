import 'dart:io';

import 'package:http/http.dart' as http;
import '../../imports.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const id = "registration_screen";

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String mail = "Null";
  String name = "Null";
  String password = "Null";
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

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
                  child: Text("Take a Picture"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openCamera();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Choose from Gallery"),
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

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var role = userProvider.role;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('$role Registration'),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 80,
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kDarkBlue),
                      ),
                    ),
                    onChanged: (value) {
                      mail = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kDarkBlue),
                      ),
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kDarkBlue),
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                if (role == kStudent) ...[
                  const SizedBox(height: 5),
                  if (_imageFile == null)
                    // show image not found
                    const Image(
                        image: AssetImage("assets/images/notfound.jpeg"))
                  else
                    // Show the image uploaded
                    Image.file(File(_imageFile!.path), height: 150),
                  const SizedBox(height: 5),
                  kStyledButton(
                    text: "Upload Photo",
                    onPressed: () async {
                      await _uploadPhoto(context);
                    },
                  ),
                ],
                const SizedBox(height: 10),
                kStyledButton(
                  text: "Submit",
                  onPressed: () {
                    if (role == kStudent) {
                      if (_imageFile != null) {
                        registerStudent();
                      } else {
                        alert(context, "Image can not be empty");
                      }
                    } else {
                      registerTeacher();
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

  Future<void> registerStudent() async {
    setState(() {
      showSpinner = true;
    });

    var url = Uri.parse("${kServerUrl}student/register");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mail': mail,
          'name': name,
          'password': password,
          'photo': base64Encode(File(_imageFile!.path).readAsBytesSync()),
        }),
      );

      setState(() {
        showSpinner = false;
      });

      if (response.statusCode == 200) {
        alert(
          context,
          "Registration Successful",
          () => Navigator.pushNamed(context, LoginScreen.id),
        );
      } else {
        alert(context, jsonDecode(response.body)["message"]);
      }
    } catch (e) {
      alert(context, '$e');
    }

    setState(() {
      showSpinner = false;
    });
  }

  Future<void> registerTeacher() async {
    setState(() {
      showSpinner = true;
    });

    var url = Uri.parse("${kServerUrl}teacher/register");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mail': mail,
          'name': name,
          'password': password,
        }),
      );

      setState(() {
        showSpinner = false;
      });

      if (response.statusCode == 201) {
        alert(
          context,
          "Registration successful",
          () => Navigator.pushNamed(context, LoginScreen.id),
        );
      } else {
        alert(context, jsonDecode(response.body)["message"]);
      }
    } catch (e) {
      alert(context, '$e');
    }

    setState(() {
      showSpinner = false;
    });
  }
}
