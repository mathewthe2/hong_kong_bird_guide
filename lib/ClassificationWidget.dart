import 'package:flutter/material.dart';
import 'classifier.dart';
import 'classifier_quant.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'BirdSearchDelegate.dart';
import 'package:image/image.dart' as img;
import 'birdsData.dart';
import 'randomBird.dart';

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

  @override
  Widget build(BuildContext context) {
    Future showClassificationResult() async {
      final birdSciName = result.contains('Category "')
          ? result.split('Category "')[1].split('"')[0]
          : '';
      final confidence = result.contains('score=')
          ? result.split('score=')[1].split(')')[0]
          : '';
      final matchPercentage = confidence.length > 0
          ? (double.parse(confidence) * 100).toStringAsFixed(1) + '%'
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
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
                              ? Column(children: <Widget>[
                                  imageURI == null
                                      ? const Text('No image selected.')
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.file(
                                              File(imageURI!.path),
                                              width: 180,
                                              height: 180,
                                              fit: BoxFit.cover)),
                                  Text(birdSciName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                  const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Text('No details found.')),
                                ])
                              : Column(children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Text('Match: ' + matchPercentage,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Image.file(
                                                File(imageURI!.path),
                                                height: 120,
                                                fit: BoxFit.cover,
                                              )),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              flex: 1,
                                              child: Image.asset(birdImagePath,
                                                  height: 120,
                                                  fit: BoxFit.cover)),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Text(birdData['bird_en'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ))),
                                  Text(birdData['bird_zh']),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                                      child: RaisedButton(
                                        onPressed: () {
                                          showBirdDetails(
                                              widget.parentContext, birdData);
                                          Navigator.pop(context);
                                        },
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

    Future getImageFromCamera() async {
      final ImagePicker _picker = ImagePicker();
      var image = await _picker.pickImage(source: ImageSource.camera);
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
                    getImageFromCamera();
                    Navigator.pop(context);
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
        body: Column(children: <Widget>[
      RandomBird(parentContext: widget.parentContext),
      Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: () => showSheet(),
            child: const Text('Identify Bird'),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurpleAccent,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            )),
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ElevatedButton(
                onPressed: () => showSearch(
                    context: widget.parentContext,
                    delegate: BirdSearchDelegate()),
                child: const Text('Search Bird'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                )))
      ]))
    ]));
  }
}
