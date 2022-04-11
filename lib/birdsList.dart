import 'package:flutter/material.dart';
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
  return Container(
    child: Column(
      children: <Widget>[
        ListTile(
            title: Text(birdList[index]["bird_zh"]), //the title of this page
            leading: Image.asset(getBirdImagePath(birdList[index]
                ["bird_sci"])), //show the image at the beginning of the list
            subtitle: Text(birdList[index]["bird_en"]), //subtitle
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => birdsDetails(
                      bird_zh: birdList[index]['bird_zh'],
                      bird_en: birdList[index]['bird_en'],
                      bird_sci: birdList[index]['bird_sci'],
                      path: getBirdImagePath(birdList[index]['bird_sci']),
                      des_zh: birdList[index]['des_zh'],
                      des_en: birdList[index]['des_en']),
                  //settings: RouteSettings(
                  //arguments: birdList[index],
                  //),
                ),
              );
            }),
        //divider line
        Divider(
          color: Colors.blueGrey,
          height: 1,
          indent: 15,
          endIndent: 15,
        )
      ],
    ),
  );
}
