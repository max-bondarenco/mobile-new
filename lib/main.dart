import 'package:flutter/material.dart';
import 'screens/screen1_1.dart';
import 'screens/screen1_2.dart';
import 'screens/screen2_1.dart';
import 'screens/screen3_1.dart';
import 'screens/screen4_1.dart';
import 'screens/screen4_2.dart';
import 'screens/screen4_3.dart';
import 'screens/screen5_1.dart';
import 'screens/screen6_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

enum Screen {
  screen11,
  screen12,
  screen21,
  screen31,
  screen41,
  screen42,
  screen43,
  screen51,
  screen61,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Screen11(),
    const Screen12(),
    const Screen21(),
    const Screen31(),
    const Screen41(),
    const Screen42(),
    const Screen43(),
    const Screen51(),
    const Screen61(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 1.1',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 1.2',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 2.1',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 3.1',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 4.1',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 4.2',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 4.3',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 5.1',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Task 6.1',
          ),
        ],
      ),
    );
  }
}
