import 'package:flutter/material.dart';
import 'birdsData.dart';

class RandomBird extends StatefulWidget {
  const RandomBird({Key? key, required this.parentContext}) : super(key: key);

  final BuildContext parentContext;

  @override
  State<RandomBird> createState() => _RandomBirdState();
}

class _RandomBirdState extends State<RandomBird> {
  dynamic _bird;

  @override
  void initState() {
    super.initState();
    _bird = getRandomBird();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: Image.asset(getBirdImagePath(_bird['bird_sci']))),
      // Text(_bird['bird_en']),
      // Text(_bird['bird_zh']),
      InkWell(
          onTap: () => showBirdDetails(widget.parentContext, _bird),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left:
                    BorderSide(width: 15.0, color: Colors.deepPurple.shade100),
              ),
              // borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(_bird['bird_en']),
              subtitle: Text('Tap to learn more'),
            ),
          )),
    ]);
  }
}
