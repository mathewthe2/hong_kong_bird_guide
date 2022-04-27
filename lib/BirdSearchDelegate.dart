import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'birdsData.dart';

class BirdSearchDelegate extends SearchDelegate<String> {
  final cities = ["Hong Kong", "Tokyo", "Osaka", "Kyoto", "Nagoya"];

  final recentCities = ["Hong Kong", "Tokyo", "Osaka"];
  List<String> birdSciNameList = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isNotEmpty) {
              query = '';
            } else {
              close(context, "closeSearch");
            }
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () => close(context, "closeSearch"));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("bird searched!");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? [] : queryBirdList(query);
    final suggestionBirds = query.isEmpty ? [] : queryBirds("bird_en", query);

    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () => showBirdDetails(context, suggestionBirds[index]),
              // leading: const Icon(LineIcons.crow),
              leading: Image.asset(
                  getBirdImagePath(suggestionBirds[index]["bird_sci"]),
                  width: 80,
                  fit: BoxFit.cover),
              title: Text(suggestionBirds[index]["bird_zh"]),
              subtitle: Text(suggestionBirds[index]["bird_en"]),
            ),
        itemCount: suggestionList.length);
  }
}
