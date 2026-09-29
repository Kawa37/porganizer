import 'package:flutter/material.dart';
import 'package:porganizer/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:porganizer/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('porganizer');

  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  final List<Widget> pages = [Home(), Settings()];
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (idx) => setState(() => index = idx),
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          selectedIndex: index,
          onDestinationSelected: (value) {
            setState(() => index = value);
            pageController.jumpToPage(value);
          },
        ),
      ),
    );
  }
}
