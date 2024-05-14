import 'package:automatic_classroom_attendance_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentRegisterRow extends StatelessWidget {
  const StudentRegisterRow({
    super.key,
    required this.name,
    required this.rollNumber,
    required this.attendance,
  });

  final String name;
  final String rollNumber;
  final String attendance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: const BoxDecoration(color: kDarkBlue),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 5),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                name,
                style: GoogleFonts.abel(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              rollNumber,
              style: GoogleFonts.abel(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "$attendance %",
              style: GoogleFonts.abel(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
