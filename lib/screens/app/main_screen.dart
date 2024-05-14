import 'package:automatic_classroom_attendance_system/imports.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});
  static const id = "app_frame";

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  // Initial screen
  int _selectedIndex = 0;

  // App Bar Font Style
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // App Bar options for different nav bar options
  static const List<Widget> _appBarOptions = <Widget>[
    Text(
      'My Courses',
      style: optionStyle,
    ),
    Text(
      'Add Course',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  // Body options for different nav bar options
  static const List<Widget> _bodyOptions = <Widget>[
    Courses(),
    AddCourse(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: _appBarOptions[_selectedIndex],
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            )
          ],
        ),
        body: Center(
          child: _bodyOptions[_selectedIndex],
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: kBgColor,
          indicatorColor: kLightishBluishBg,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.school,),
              label: 'My Courses',
            ),
            NavigationDestination(
              icon: Icon(Icons.add),
              label: 'Add Course',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          // selectedItemColor: kDarkBlue,
          // selectedItemColor: Colors.blue,
        ),
      ),
    );
  }
}
