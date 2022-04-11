import 'package:flutter/material.dart';
import 'birdsList.dart';
import 'ClassificationWidget.dart';
// import 'SoundClassificationWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'birdsInfo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ClassificationWidget(),
    BirdList(),
    WebView(
        initialUrl: 'https://digital.lib.hkbu.edu.hk/hkwildtracks/',
        javascriptMode: JavascriptMode.unrestricted),
    Text(
      'Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bird Guide HK'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Birds',
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Map',
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.deepPurple,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        onTap: _onItemTapped,
      ),
    );
  }
}
