import 'package:flutter/material.dart';
// import 'birdsList.dart';
// import 'birdsInfo.dart';

class birdsDetails extends StatefulWidget {
  const birdsDetails(
      {Key? key,
      required this.bird_zh,
      required this.bird_en,
      required this.bird_sci,
      required this.path,
      required this.des_zh,
      required this.des_en})
      //required this.des})
      : super(key: key);
  final String bird_zh, bird_en, bird_sci, path, des_zh, des_en;
  @override
  State<birdsDetails> createState() => _birdsDetailsState();
}

String des = '';
bool language = true; //true: Zh, false: En

class _birdsDetailsState extends State<birdsDetails> {
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

  @override
  Widget build(BuildContext context) {
    if (language) {
      des = widget.des_zh;
      language = true;
    } else {
      des = widget.des_en;
      language = false;
    }

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
      body: Column(
        children: [
          Text(widget.bird_zh,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(widget.bird_en,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(widget.bird_sci + '\n', style: TextStyle(fontSize: 15)),
          Image.asset(widget.path),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text('\n' + des)),
        ],
      ),
    );
  }
}
