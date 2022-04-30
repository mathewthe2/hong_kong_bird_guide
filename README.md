# hk_bird_guide

A new Flutter project.

## Setup for TensorFlow Binaries

Note: flex binaries not ready for x86. Use either real devices or emulation on ARM / Apple Silicon. 
More: https://www.tensorflow.org/lite/guide/ops_select

### Android

Mac (already included):

```
brew install wget
sh install.sh
```

Linux (already included):

`sh install.sh -d`

Windows: 

Download [install.bat](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.bat) and run `install.bat -d`.

### iOS

Download [TensorflowLiteC.Framework](https://github.com/am15h/tflite_flutter_plugin/releases/download/v0.5.0/TensorFlowLiteC.framework.zip), build, and place in pub-cache folder of the tflite_flutter package.

## Getting Started

```bash
flutter pub add
flutter run
```

More on setting up with flutter: https://docs.flutter.dev/get-started/install
