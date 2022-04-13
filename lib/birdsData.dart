import 'package:flutter/material.dart';
import 'birdsInfo.dart';
import 'birdsDetail.dart';

String getBirdImagePath(String bird_sci) {
  return 'assets/birds/full_images/' + bird_sci + '.jpg';
}

String getBirdSoundPath(String bird_sci) {
  return 'assets/birds/audio/' + bird_sci + '.wav';
}

String getBirdTaxon(String bird_sci) {
  final bird = findBirdData(bird_sci);
  if (bird != null) {
    if (bird['taxon'] != null) {
      return bird['taxon'];
    }
  }
  return '';
}

String getBirdRecentSightingURL(String bird_sci) {
  String taxon = getBirdTaxon(bird_sci);
  if (taxon != '') {
    return 'https://search.macaulaylibrary.org/catalog?taxonCode=${taxon}&region=Hong%20Kong%20(HK)&regionCode=HK';
  }
  return '';
}

String getBirdSoundURL(String bird_sci) {
  String taxon = getBirdTaxon(bird_sci);
  if (taxon != '') {
    return 'https://search.macaulaylibrary.org/catalog?taxonCode=${taxon}&mediaType=a';
  }
  return '';
}

String getBirdVideoURL(String bird_sci) {
  String taxon = getBirdTaxon(bird_sci);
  if (taxon != '') {
    return 'https://search.macaulaylibrary.org/catalog?taxonCode=${taxon}&mediaType=v';
  }
  return '';
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
          image_path: getBirdImagePath(birdData['bird_sci']),
          sound_path: getBirdSoundPath(birdData['bird_sci']),
          des_zh: birdData['des_zh'],
          des_en: birdData['des_en']),
    ),
  );
}
