import 'package:flutter/material.dart';
import 'birdsList.dart';
import 'package:line_icons/line_icons.dart';
import 'BirdSearchDelegate.dart';
import 'dart:io';
import 'ClassificationWidget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    BirdList(),
    WebView(
        initialUrl: 'https://digital.lib.hkbu.edu.hk/hkwildtracks/',
        javascriptMode: JavascriptMode.unrestricted),
    ClassificationWidget(),
    Text(
      'Favorites',
      style: optionStyle,
    ),
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
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Bird Guide HK'),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search bird',
              onPressed: () =>
                  showSearch(context: context, delegate: BirdSearchDelegate()),
            ),
          ]),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(
            icon: LineIcons.crow,
            title: 'Birds',
          ),
          TabItem(
            icon: Icons.map_rounded,
            title: 'Map',
          ),
          TabItem(
            icon: Icons.search,
            title: 'Search',
          ),
          TabItem(
            icon: Icons.star,
            title: 'Favorites',
          ),
          TabItem(
            icon: Icons.settings,
            title: 'Settings',
          ),
        ],
        initialActiveIndex: _selectedIndex,
        // selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.white38,
        backgroundColor: Colors.deepPurple,
        color: Colors.white38,
        activeColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
