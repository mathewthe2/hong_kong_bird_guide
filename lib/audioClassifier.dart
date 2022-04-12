import 'dart:typed_data';

// import 'package:audio_classification/main.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class AudioClassifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;

  late List<int> _inputShape;
  late List<int> _input2Shape;
  late List<int> _outputShape;

  late TensorBuffer _outputBuffer;

  TfLiteType _outputType = TfLiteType.uint8;

  final String _modelFileName = 'BirdNET_6K_GLOBAL_MODEL.tflite';
  final String _labelsFileName = 'assets/BirdNET_labels.txt';
  final String _mp3FileName = 'assets/birdsounds.wav';

  final int sampleRate = 48000;
  final int sampleSize = 48000 * 3;

  final int _labelsLength = 6362;

  // late Map<int, String> labels;
  late List<String> labels;

  late Uint8List fileList;

  AudioClassifier({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

    loadModel();
    loadLabels();
    loadFile();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(_modelFileName,
          options: _interpreterOptions);
      print('Interpreter Created Successfully');
      print(interpreter.getInputTensors());
      print(interpreter.getOutputTensors());
      _inputShape = interpreter.getInputTensor(0).shape;
      _input2Shape = interpreter.getInputTensor(1).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      _outputType = interpreter.getOutputTensor(0).type;

      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  Future<void> loadLabels() async {
    labels = await FileUtil.loadLabels(_labelsFileName);
    if (labels.length == _labelsLength) {
      print('Labels loaded successfully');
    } else {
      print('Unable to load labels');
    }
  }

  Future<void> loadFile() async {
    fileList = (await rootBundle.load(_mp3FileName)).buffer.asUint8List();
    // .sublist(sampleSize * 2, sampleSize * 3)
  }

  List<Category> predict(List<int> audioSample) {
    final pres = DateTime.now().millisecondsSinceEpoch;
    // Uint8List bytes = Uint8List.fromList(audioSample);

    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    final runs = DateTime.now().millisecondsSinceEpoch;
    // metadata tensor shape [1,6] and type float32
    // var metadata = [
    //   [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    // ];

    var metadata = [
      [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    ];

    TensorBuffer outputBuffer =
        TensorBuffer.createFixedSize(<int>[1, 6362], TfLiteType.float32);
    var outputs = {0: outputBuffer.getBuffer()};

    TensorAudio tensorAudio = TensorAudio.create(
        TensorAudioFormat.create(1, sampleRate), _inputShape[1]);
    tensorAudio.loadShortBytes(fileList);

    interpreter.runForMultipleInputs(
        [tensorAudio.tensorBuffer.getBuffer(), metadata], outputs);

    final run = DateTime.now().millisecondsSinceEpoch - runs;

    Map<String, double> labeledProb = {};
    for (int i = 0; i < _outputBuffer.getDoubleList().length; i++) {
      labeledProb[labels[i]!] = _outputBuffer.getDoubleValue(i);
    }
    final top = getTopProbability(labeledProb);
    return top;
  }

  void close() {
    interpreter.close();
  }
}

List<Category> getTopProbability(Map<String, double> labeledProb) {
  var pq = PriorityQueue<MapEntry<String, double>>(compare);
  pq.addAll(labeledProb.entries);
  var result = <Category>[];
  while (pq.isNotEmpty &&
      result.length < 5 &&
      (pq.first.value > 0.1 || result.length < 3)) {
    result.add(Category(pq.first.key, pq.first.value));
    pq.removeFirst();
  }
  print('result');
  print(result);
  return result;
}

int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
  if (e1.value > e2.value) {
    return -1;
  } else if (e1.value == e2.value) {
    return 0;
  } else {
    return 1;
  }
}

// Future<Map<int, String>> loadLabelsFile(String fileAssetLocation) async {
//   final fileString = await rootBundle.loadString('$fileAssetLocation');
//   return labelListFromString(fileString);
// }

// Map<int, String> labelListFromString(String fileString) {
//   var classMap = <int, String>{};
//   final newLineList = fileString.split('\n');
//   for (var i = 1; i < newLineList.length; i++) {
//     final entry = newLineList[i].trim();
//     if (entry.length > 0) {
//       final data = entry.split(',');
//       classMap[int.parse(data[0])] = data[2];
//     }
//   }
//   return classMap;
// }
