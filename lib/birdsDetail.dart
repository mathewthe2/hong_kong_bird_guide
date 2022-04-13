import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'birdsData.dart';
// import 'birdsList.dart';
// import 'birdsInfo.dart';

class birdsDetails extends StatefulWidget {
  const birdsDetails(
      {Key? key,
      required this.bird_zh,
      required this.bird_en,
      required this.bird_sci,
      required this.image_path,
      required this.des_zh,
      required this.des_en})
      //required this.des})
      : super(key: key);
  final String bird_zh, bird_en, bird_sci, image_path, des_zh, des_en;
  @override
  State<birdsDetails> createState() => _birdsDetailsState();
}

String des = '';
bool language = true; //true: Zh, false: En

class _birdsDetailsState extends State<birdsDetails> {
  int _selectedIndex = 0;

  onButtonPressed() {
    setState(() {
      if (language) {
        des = widget.des_zh;
        language = false;
      } else {
        des = widget.des_en;
        language = true;
      }
    });
  }

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
    if (language) {
      des = widget.des_zh;
      language = true;
    } else {
      des = widget.des_en;
      language = false;
    }

    Widget birdInfo() {
      return Column(
        children: [
          Text(widget.bird_zh,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(widget.bird_en,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(widget.bird_sci + '\n', style: TextStyle(fontSize: 15)),
          Image.asset(widget.image_path),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text('\n' + des)),
        ],
      );
    }

    List<Widget> _widgetOptions = <Widget>[
      birdInfo(),
      WebView(
          initialUrl: getBirdSoundURL(widget.bird_sci),
          javascriptMode: JavascriptMode.unrestricted,
          key: const Key('birdSoundWebView')),
      WebView(
          initialUrl: getBirdRecentSightingURL(widget.bird_sci),
          javascriptMode: JavascriptMode.unrestricted,
          key: const Key('birdRecentSightingWebView')),
      WebView(
          initialUrl: getBirdVideoURL(widget.bird_sci),
          javascriptMode: JavascriptMode.unrestricted,
          key: const Key('birdVideoWebView'))
    ];

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onButtonPressed();
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.language),
        ),
        appBar: AppBar(
          title: Text(widget.bird_zh),
          backgroundColor: Colors.deepPurple,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.deepPurple,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Info',
              backgroundColor: Colors.deepPurple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.audiotrack_sharp),
              label: 'Sounds',
              backgroundColor: Colors.deepPurple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_see),
              label: 'Sightings',
              backgroundColor: Colors.deepPurple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_rounded),
              label: 'Video',
              backgroundColor: Colors.deepPurple,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white38,
          onTap: _onItemTapped,
        ));
  }
}
