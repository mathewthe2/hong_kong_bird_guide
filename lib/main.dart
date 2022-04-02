import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as img;
import 'classifier.dart';
import 'classifier_quant.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('HK Bird Guide'),
                backgroundColor: Colors.transparent
            ),
            body: Center(
                child: MyImagePicker()
            )
        )
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
                        child: Text('Click Here To Select Image From Camera'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: RaisedButton(
                        onPressed: () => getImageFromGallery(),
                        child: Text('Click Here To Select Image From Gallery'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: RaisedButton(
                        onPressed: () => classify(),
                        child: Text('Classify Image'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  result == null
                      ? Text('Result')
                      : Text(result)
                ]))
    );
  }
}