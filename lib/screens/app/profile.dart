import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../../imports.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const id = "profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String role;
  late String email;
  bool _isloading = false;
  final ImagePicker _picker = ImagePicker();
  String name = "Not Found";
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    role = Provider.of<UserProvider>(context, listen: false).role;
    email = Provider.of<UserProvider>(context, listen: false).userName;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      _isloading = true;
    });

    if (role == kStudent) {
      try {
        final url = Uri.parse('${kServerUrl}student/profile/$email');
        final response = await http.get(url);
        print(response);
        print(response.statusCode);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            name = jsonData['name'];
            _imageData = base64Decode(jsonData['photo']);
          });
        } else {
          alert('request error: ${response.statusCode}');
        }
      } catch (e) {
        alert('server error: $e');
        // await Future.delayed(Duration(seconds: 5));
        // await fetchUserData();
      }

    } else {
      try {
        final url = Uri.parse('${kServerUrl}teacher/profile/$email');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            name = jsonData['name'];
          });
        } else {
          alert('request error: ${response.statusCode}');
        }
      } catch (e) {
        alert('server error: $e');
      }
    }

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isloading,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Text('Username: $email', style: GoogleFonts.actor(fontSize: 20),),
              SizedBox(height: 10,),
              Text('Name: $name', style: GoogleFonts.actor(fontSize: 20),),
              SizedBox(height: 10,),

              if (role == kStudent) ...[
                Text('Registered Image:', style: GoogleFonts.actor(fontSize: 20),),
                const SizedBox(height: 5),
                if (_imageData == null)
                  // Show image not found placeholder
                  const Image(image: AssetImage("assets/images/notfound.jpeg"))
                else
                  // Display the fetched image
                  Image.memory(_imageData!, height: 250),
                const SizedBox(height: 5),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final XFile? media = await _picker.pickImage(
      source: ImageSource.gallery, // You can also use ImageSource.camera
      maxWidth: null,
      maxHeight: null,
      imageQuality: null,
    );

    if (media != null) {
      final imageData = await media.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    }
  }

  void _submitChanges() {
    // Handle form submission, update backend with edited data
    // You can use the TextEditingController values to send updated data to your backend
  }

  void alert(String desc, [void Function()? onPress]) {
    onPress ??= () => Navigator.pop(context); // Set default onPress function

    Alert(
      style: const AlertStyle(
        backgroundColor: kDarkBlue,
        descStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Overpass',
          fontWeight: FontWeight.w700,
        ),
      ),
      context: context,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.white,
          onPressed: onPress,
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        )
      ],
    ).show();
  }
}
