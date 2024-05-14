import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'imports.dart';

const kLightBluishBg = Color(0xFF8EACCD);
const kBgColor = Color(0xFFFFFBF5);
const kDimTextColor = Color(0xFFC2CFD6);

const kBluishBg = Color(0xFF547EEA);
const kLightishBluishBg = Color(0xFFD1E7FC);
const kDarkBlue = Color(0xFF235AB8);
const kPurple = Color(0xFF6477FC);
const kPinkishPurple = Color(0xFF8D6EBC);
const kPinkishRed = Color(0xFFBC6E6E);

String kStudent = "Student";
String kTeacher = "Teacher";
// String kServerUrl = 'http://10.0.2.2:5700/';
String kServerUrl = 'http://10.32.8.30:5700/';
// String kServerUrl = 'https://oelp2024.pythonanywhere.com/';
// String kServerUrl = 'https://souvik.solutions/';
// String kServerUrl = 'https://creds.iitpkd.ac.in/';
// String kServerUrl = 'http://10.32.8.30:5700/';

class kStyledButton extends StatelessWidget {
  const kStyledButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.btnColor = kDarkBlue,
      this.btnTextColor = Colors.white,
      this.btnIcon = CupertinoIcons.arrow_right,
      this.width = 320,
      this.height = 80});
  final void Function() onPressed;
  final String text;
  final Color btnColor;
  final Color btnTextColor;
  final IconData btnIcon;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: GoogleFonts.comicNeue(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: btnTextColor,
                    fontSize: 19.0,
                  ),
                ),
              ),
              Icon(
                btnIcon,
                color: btnTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void alert(context, String desc, [void Function()? onPress]) {
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
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      )
    ],
  ).show();
}
