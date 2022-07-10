import 'package:flutter/material.dart';
import 'package:mytutor1/models/user.dart';
import 'package:mytutor1/views/favourite.dart';
import 'package:mytutor1/views/profile.dart';
import 'package:mytutor1/views/subjectlist.dart';
import 'package:mytutor1/views/subscribe.dart';
import 'package:mytutor1/views/tutorlist.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _children;
  late double screenHeight, screenWidth, resWidth;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    const TextStyle optionStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    _children = <Widget>[
      SubjectList(user: widget.user),
      const TutorPage(),
      const Profile(),
      const Subscribe(),
      const Favourite(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _children.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subjects',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tutors',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscribe',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
            backgroundColor: Colors.purple,
          ),
        ],
        selectedItemColor: Colors.yellow[800],
      ),
    );
  }
}
