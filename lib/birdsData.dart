import 'package:flutter/material.dart';
import 'birdsInfo.dart';
import 'birdsDetail.dart';

int getBirdIndex(String birdSci) {
  dynamic birdData = findBirdData(birdSci);
  return birdData == null ? -1 : birdList.indexOf(birdData);
}

bool nextBirdExists(int birdIndex) {
  return birdIndex >= 0 && birdIndex < birdList.length - 1;
}

void navigateToBird(dynamic context, int birdIndex) {
  showBirdDetails(context, birdList[birdIndex], withReplacement: true);
}

String getBirdImagePath(String birdSci) {
  return 'assets/birds/full_images/' + birdSci + '.jpg';
}

String getBirdSoundPath(String birdSci) {
  return 'assets/birds/audio/' + birdSci + '.wav';
}

String getBirdTaxon(String birdSci) {
  final bird = findBirdData(birdSci);
  if (bird != null) {
    if (bird['taxon'] != null) {
      return bird['taxon'];
    }
  }
  return '';
}

String getBirdRecentSightingURL(String birdSci) {
  String taxon = getBirdTaxon(birdSci);
  if (taxon != '') {
    return 'https://search.macaulaylibrary.org/catalog?taxonCode=${taxon}&region=Hong%20Kong%20(HK)&regionCode=HK';
  }
  return '';
}

String getBirdSoundURL(String birdSci) {
  String taxon = getBirdTaxon(birdSci);
  if (taxon != '') {
    return 'https://search.macaulaylibrary.org/catalog?taxonCode=${taxon}&mediaType=a';
  }
  return '';
}

String getBirdVideoURL(String birdSci) {
  String taxon = getBirdTaxon(birdSci);
  if (taxon != '') {
    return 'https://search.macaulaylibrary.org/catalog?taxonCode=${taxon}&mediaType=v';
  }
  return '';
}

dynamic findBirdData(String birdSci) => birdList
    .firstWhere((bird) => bird['bird_sci'] == birdSci, orElse: () => null);

dynamic findBirdByName(String name) => birdList.firstWhere(
    (bird) => bird['bird_en'] == name || bird['bird_zh'] == name,
    orElse: () => null);

void showBirdDetails(dynamic context, dynamic birdData,
    {bool withReplacement = false}) {
  dynamic pageRoute = MaterialPageRoute(
    builder: (context) => birdsDetails(
        bird_zh: birdData['bird_zh'],
        bird_en: birdData['bird_en'],
        bird_sci: birdData['bird_sci'],
        image_path: getBirdImagePath(birdData['bird_sci']),
        des_zh: birdData['des_zh'],
        des_en: birdData['des_en']),
  );
  if (withReplacement) {
    Navigator.pushReplacement(context, pageRoute);
  } else {
    Navigator.push(context, pageRoute);
  }
}

List findBird(String key, String query) => birdList
    .where((bird) => bird[key].toLowerCase().contains(query.toLowerCase()))
    .map((bird) => bird[key])
    .toList();

List queryBirds(String key, String query) => birdList
    .where((bird) => bird[key].toLowerCase().contains(query.toLowerCase()))
    .toList();

List queryBirdList(String query) {
  final birdListEnglish = findBird('bird_en', query);
  // TODO: check query language
  return birdListEnglish.isNotEmpty
      ? birdListEnglish
      : findBird('bird_zh', query);
}
