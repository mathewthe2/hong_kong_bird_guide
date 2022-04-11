import 'package:flutter/material.dart';
import 'birdsInfo.dart';
import 'birdsDetail.dart';

String getBirdImagePath(String bird_sci) {
  return 'assets/birds/full_images/' + bird_sci + '.jpg';
}

dynamic findBirdData(String bird_sci) => birdList
    .firstWhere((bird) => bird['bird_sci'] == bird_sci, orElse: () => null);

void showBirdDetails(dynamic context, dynamic birdData) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => birdsDetails(
          bird_zh: birdData['bird_zh'],
          bird_en: birdData['bird_en'],
          bird_sci: birdData['bird_sci'],
          path: getBirdImagePath(birdData['bird_sci']),
          des_zh: birdData['des_zh'],
          des_en: birdData['des_en']),
    ),
  );
}
