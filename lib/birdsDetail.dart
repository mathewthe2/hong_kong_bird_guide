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
      final int birdIndex = getBirdIndex(widget.bird_sci);
      final bool hasPreviousBird = birdIndex > 0;
      final bool hasNewBird = nextBirdExists(birdIndex);
      return Column(
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300.0),
              child: Hero(
                tag: widget.bird_sci,
                child: Image.asset(widget.image_path),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (hasPreviousBird) {
                          navigateToBird(context, birdIndex - 1);
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: hasPreviousBird
                              ? Colors.black87
                              : Colors.black12)),
                  IconButton(
                      onPressed: () {
                        if (hasNewBird) {
                          navigateToBird(context, birdIndex + 1);
                        }
                      },
                      icon: Icon(Icons.arrow_forward_ios,
                          color: hasNewBird ? Colors.black87 : Colors.black12))
                ],
              )),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 200.0,
                  ),
                  child: Container(
                      // width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Center(
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 250.0,
                              ),
                              child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    Text(widget.bird_en,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            height: 2)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Text(des,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic))),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Text(widget.bird_sci,
                                        style: const TextStyle(
                                            color: Colors.white, height: 1.5)),
                                  ])))),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black87,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          ),
                        ],
                      ))),
              Container(
                  height: 50,
                  // width: 100,
                  margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.5, color: Colors.grey[900]!),
                  ),
                  child: Center(
                      child: Text(widget.bird_zh,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 3),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          )))),
            ],
          ),
          // Padding(
          //     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          //     child: Text('\n' + des)),
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
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  onButtonPressed();
                },
                backgroundColor: Colors.grey[900],
                child: const Icon(Icons.language),
              )
            : null,
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
