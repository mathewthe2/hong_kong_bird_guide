import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'birdsDetail.dart';
import 'birdsInfo.dart';
import 'birdsData.dart';

class BirdList extends StatelessWidget {
  const BirdList({Key? key}) : super(key: key);

  // Read the list
  Widget _getListData(context, index) {
    return readList(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        //return the length of the list
        itemCount: birdList.length,
        itemBuilder: this._getListData);
  }
}

Widget readList(context, index) {
  return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => birdsDetails(
                    bird_zh: birdList[index]['bird_zh'],
                    bird_en: birdList[index]['bird_en'],
                    bird_sci: birdList[index]['bird_sci'],
                    image_path: getBirdImagePath(birdList[index]['bird_sci']),
                    des_zh: birdList[index]['des_zh'],
                    des_en: birdList[index]['des_en'])));
      },
      child: StickyHeaderBuilder(
        overlapHeaders: true,
        builder: (BuildContext context, double stuckAmount) {
          stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
          return Container(
            height: 50.0,
            // color: Colors.grey[900],
            color: Colors.grey.shade900.withOpacity(0.6 + stuckAmount * 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                birdList[index]['bird_en'],
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                birdList[index]['bird_zh'],
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                    fontSize: 12),
              )
            ]),
          );
        },
        content: Hero(
            tag: birdList[index]['bird_sci'],
            child: Image.asset(getBirdImagePath(birdList[index]['bird_sci']),
                fit: BoxFit.cover, width: double.infinity, height: 220.0)),
      ));
  // return Container(
  //   child: Column(
  //     children: <Widget>[
  //       ListTile(
  //           title: Text(birdList[index]["bird_zh"]), //the title of this page
  //           leading: Image.asset(getBirdImagePath(birdList[index]['bird_sci']),
  //               width: 80,
  //               fit:
  //                   BoxFit.cover), //show the image at the beginning of the list
  //           subtitle: Text(birdList[index]["bird_en"]), //subtitle
  //           trailing: Icon(Icons.keyboard_arrow_right),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => birdsDetails(
  //                     bird_zh: birdList[index]['bird_zh'],
  //                     bird_en: birdList[index]['bird_en'],
  //                     bird_sci: birdList[index]['bird_sci'],
  //                     image_path: getBirdImagePath(birdList[index]['bird_sci']),
  //                     des_zh: birdList[index]['des_zh'],
  //                     des_en: birdList[index]['des_en']),
  //               ),
  //             );
  //           }),
  //       //divider line
  //       Divider(
  //         color: Colors.blueGrey,
  //         height: 1,
  //         indent: 15,
  //         endIndent: 15,
  //       )
  //     ],
  //   ),
  // );
}
