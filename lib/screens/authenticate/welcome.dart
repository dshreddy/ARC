import '../../imports.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const id = "welcome_screen";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  widthFactor: 0.5,
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(120.0),
                        child: Text(
                          'Welcome to ARC: Automatic Roll Call\n Say farewell to old-school attendance!',
                          style: GoogleFonts.playfair(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      width: 400,
                      height: 500,
                      decoration: const BoxDecoration(
                        color: kBluishBg,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(180),
                          bottomRight: Radius.circular(300),
                          // bottomLeft: Radius.circular(200),
                        ),
                      ),
                    ),
                  ),
                ),Align(
                  widthFactor: 0.5,
                  child: Opacity(
                    opacity: 0.4,
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: const BoxDecoration(
                        color: kLightishBluishBg,
                        borderRadius: BorderRadius.all(Radius.circular(350)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // welcome message container
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Separation box
                const SizedBox(height: 10),

                // Student button
                kStyledButton(
                    text: kStudent,
                    onPressed: () {
                      // Set the role in the provider
                      Provider.of<UserProvider>(context, listen: false)
                          .setRole(kStudent);

                      Navigator.pushNamed(context, LoginScreen.id);
                    }),

                // Separation box
                const SizedBox(height: 10),

                // Teacher button
                kStyledButton(
                    text: kTeacher,
                    onPressed: () {
                      // Set the role in the provider
                      Provider.of<UserProvider>(context, listen: false)
                          .setRole(kTeacher);

                      Navigator.pushNamed(context, LoginScreen.id);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
