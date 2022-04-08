import 'package:flutter/material.dart';
import 'birdsDetail.dart';
import 'birdsInfo.dart';

class BirdList extends StatelessWidget {
  const BirdList({ Key? key }) : super(key: key);

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
  return new Container(
    child: Column(
      children: <Widget>[
        ListTile(
            title: Text(birdList[index]["bird_zh"]), //the title of this page
            leading: Image.asset(birdList[index]
                ["path"]), //show the image at the beginning of the list
            subtitle: Text(birdList[index]["bird_en"]), //subtitle
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => birdsDetails(
                      bird_zh: birdList[index]['bird_zh'],
                      bird_en: birdList[index]['bird_en'],
                      bird_sci: birdList[index]['bird_sci'],
                      path: birdList[index]['path'],
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
          color: Colors.grey,
          height: 1,
        )
      ],
    ),
  );
}
