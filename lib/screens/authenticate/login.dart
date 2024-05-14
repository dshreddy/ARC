import '../../imports.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var showSpinner = false;
  var email = "";
  var password = "";
  bool passVisible = true;

  @override
  Widget build(BuildContext context) {

    var role = Provider.of<UserProvider>(context).role;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("$role Login Screen"),
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
                      // Set the user name in the UserProvider
                      email = value;
                    },
                  ),
                ),

                SizedBox(
                  height: 80,
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kDarkBlue),
                      ),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          passVisible= !passVisible;
                        });
                      },
                        icon:Icon(
                          passVisible==true? Icons.visibility : Icons.visibility_off,

                          color: Colors.black,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: passVisible,
                  ),
                ),
                const SizedBox(height: 20),
                kStyledButton(
                  text: "Submit",
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .setUserName(email);
                    login(role, email, password);
                  },
                  btnIcon: Icons.login,
                ),
                const SizedBox(height: 8),
                kStyledButton(
                  text: "Register",
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  btnColor: Colors.white,
                  btnTextColor: kDarkBlue,
                  btnIcon: Icons.app_registration,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(String role, String email, String password) async {
    setState(() {
      showSpinner = true;
    });

    var url = role == kStudent
        ? Uri.parse("${kServerUrl}student/login")
        : Uri.parse("${kServerUrl}teacher/login");

    try {
      http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      setState(() {
        showSpinner = false;
      });

      if (response.statusCode != 200) {
        alert(context, jsonDecode(response.body)["message"]);
      } else {
        Navigator.pushNamed(context, AppFrame.id);
      }
    } catch (e) {
      alert(context, '$e');
    }

    setState(() {
      showSpinner = false;
    });
  }
}
