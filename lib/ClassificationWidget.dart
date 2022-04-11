import 'package:flutter/material.dart';
import 'classifier.dart';
import 'classifier_quant.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as img;
import 'birdsData.dart';

class ClassificationWidget extends StatelessWidget {
  const ClassificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(child: MyImagePicker(parentContext: context))));
  }
}

class MyImagePicker extends StatefulWidget {
  final BuildContext parentContext;
  const MyImagePicker({Key? key, required this.parentContext})
      : super(key: key);

  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State<MyImagePicker> {
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

  @override
  Widget build(BuildContext context) {
    Future showClassificationResult() async {
      final birdSciName = result.contains('Category "')
          ? result.split('Category "')[1].split('"')[0]
          : '';
      final confidence = result.contains('score=')
          ? result.split('score=')[1].split(')')[0]
          : '';
      final birdData = birdSciName == '' ? null : findBirdData(birdSciName);
      final birdImagePath =
          birdData == null ? '' : getBirdImagePath(birdData['bird_sci']);
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          builder: (context) {
            return Wrap(children: [
              Container(
                  // height: MediaQuery.of(context).size.height * 0.5,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // imageURI == null
                          //     ? const Text('No image selected.')
                          //     : Image.file(File(imageURI!.path),
                          //         width: 50, height: 50, fit: BoxFit.cover),
                          // Text(birdSciName),
                          birdData == null
                              ? const Text('No details found.')
                              : Column(children: <Widget>[
                                  Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image.file(
                                            File(imageURI!.path),
                                            width: 185,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image.asset(birdImagePath,
                                              width: 185,
                                              height: 120,
                                              fit: BoxFit.cover)),
                                    ],
                                  ),
                                  Text(birdData['bird_en']),
                                  Text(birdData['bird_zh']),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                                      child: RaisedButton(
                                        onPressed: () => showBirdDetails(
                                            widget.parentContext, birdData),
                                        child: Text('More'),
                                        textColor: Colors.white,
                                        color: Colors.deepPurpleAccent,
                                        padding:
                                            EdgeInsets.fromLTRB(12, 12, 12, 12),
                                      )),
                                ])
                        ]),
                  ))
            ]);
          });
    }

    Future classify() async {
      img.Image? imageInput =
          img.decodeImage(File(imageURI!.path).readAsBytesSync());
      if (imageInput == null) return;
      var pred = _classifier.predict(imageInput);
      setState(() {
        result = pred.toString();
      });
      showClassificationResult();
    }

    Future getImageFromGallery() async {
      final ImagePicker _picker = ImagePicker();
      var image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        imageURI = image;
        path = image?.path ?? '';
      });
      if (image != null) {
        classify();
      }
    }

    Future showSheet() async {
      return showModalBottomSheet(
          context: context,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          builder: (context) {
            return Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take photo'),
                  onTap: () {
                    // pass
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.perm_media_outlined),
                  title: const Text('Choose photo'),
                  onTap: () {
                    getImageFromGallery();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          // imageURI == null
          //     ? Text('No image selected.')
          //     : Image.file(File(imageURI!.path),
          //         width: 300, height: 200, fit: BoxFit.cover),
          Container(
              margin: EdgeInsets.fromLTRB(0, 60, 0, 40),
              child: RaisedButton(
                onPressed: () => showSheet(),
                child: Text('Identify Bird'),
                textColor: Colors.white,
                color: Colors.deepPurpleAccent,
                padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
              )),
          // Container(
          //     margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
          //     child: RaisedButton(
          //       onPressed: () => showClassificationResult(widget.parentContext),
          //       child: const Text('Show Result'),
          //       textColor: Colors.white,
          //       color: Colors.orange,
          //       padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          //     )),
          // result == null ? Text('Result') : Text(result)
        ])));
  }
}
