import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as img;
import 'classifier.dart';
import 'classifier_quant.dart';
import 'birdsList.dart';
import 'birdsInfo.dart';



void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MyStatefulWidget(),
    );
  }
}

class ClassificationWidget extends StatelessWidget {
  const ClassificationWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: MyImagePicker()
          )
      )
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
    // Text(
    //   'Index 0: Hoddme',
    //   style: optionStyle,
    // ),
    // Text(
    //   'Index 1: Business',
    //   style: optionStyle,
    // ),
    BirdList(),
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
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Birds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}


class MyImagePicker extends StatefulWidget {
  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State {

  XFile? imageURI;
  String result = '';
  String path = 'assets/kingfisher.jpeg';

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  Future getImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageURI = image;
      path = image?.path ?? '';
    });
  }

  Future getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);


    setState(() {
      imageURI = image;
      path = image?.path ?? '';
    });
  }

  Future classify() async{
    img.Image? imageInput = img.decodeImage(File(imageURI!.path).readAsBytesSync());
    if (imageInput == null) return;
    var pred = _classifier.predict(imageInput);
    setState(() {
      result = pred.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  imageURI == null
                      ? Text('No image selected.')
                      : Image.file(File(imageURI!.path), width: 300, height: 200, fit: BoxFit.cover),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: RaisedButton(
                        onPressed: () => getImageFromCamera(),
                        child: Text('Search with Camera'),
                        textColor: Colors.white,
                        color: Colors.orange,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: RaisedButton(
                        onPressed: () => getImageFromGallery(),
                        child: Text('Search from Gallery'),
                        textColor: Colors.white,
                        color: Colors.orange,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: RaisedButton(
                        onPressed: () => classify(),
                        child: Text('Classify Image'),
                        textColor: Colors.white,
                        color: Colors.orange,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  result == null
                      ? Text('Result')
                      : Text(result)
                ]))
    );
  }
}