import 'dart:async';
// import 'dart:ui';
import 'audioClassifier.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class SoundClassificationWidget extends StatelessWidget {
  const SoundClassificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Center(child: MyApp())));
  }
}

const int sampleRate = 48000;
const int sampleSize = sampleRate * 3;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RecorderStream _recorder = RecorderStream();

  bool inputState = true;

  List<int> _micChunks = [];
  List<int> _micChunksCompleted = [];
  bool _isRecording = false;
  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;

  late StreamController<List<Category>> streamController;
  late Timer _timer;

  late AudioClassifier _classifier;

  List<Category> preds = [];

  // RandomColor randomColorGen = RandomColor();

  Category? prediction;

  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    initPlugin();
    _classifier = AudioClassifier();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (_micChunksCompleted.length == sampleSize) {
        streamController.add(_classifier.predict(_micChunksCompleted));
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _audioStream.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    _audioStream = _recorder.audioStream.listen((data) {
      if (_micChunks.length > sampleSize) {
        _micChunks.clear();
      }

      _micChunks.addAll(data);

      if (_micChunks.length == sampleSize) {
        // print(_micChunks.length);
        _micChunksCompleted = List<int>.from(_micChunks);
      }
    });

    streamController.stream.listen((event) {
      setState(() {
        preds = event;
      });
    });

    await Future.wait(
        [_recorder.initialize(sampleRate: sampleRate), _recorder.start()]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.orange, accentColor: Colors.orange),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TFL Audio Classification',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Input",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Switch(
                    value: inputState,
                    onChanged: (value) {
                      if (value) {
                        _audioStream.resume();
                      } else {
                        _audioStream.pause();
                      }
                      setState(() {
                        inputState = value;
                      });
                    },
                  ),
                ],
              ),
              Divider(),
              if (inputState)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: preds.length,
                  itemBuilder: (context, i) {
                    final color = Colors.purple;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              preds.elementAt(i).label,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent),
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              PredictionScoreBar(
                                ratio: 1,
                                color: color.withOpacity(0.1),
                              ),
                              PredictionScoreBar(
                                ratio: preds.elementAt(i).score,
                                color: color,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionScoreBar extends StatelessWidget {
  final double ratio;
  final Color color;
  const PredictionScoreBar({Key? key, required this.ratio, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: (MediaQuery.of(context).size.width * 0.6) * ratio,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(4.0),
          right: Radius.circular(ratio == 1 ? 4.0 : 0.0),
        ),
      ),
    );
  }
}
