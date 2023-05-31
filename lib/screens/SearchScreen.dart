import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_collector/models/games.dart';
import 'package:game_collector/models/tags.dart';
import 'package:game_collector/screens/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:game_collector/services/mongoDBservice.dart';
import 'package:game_collector/screens/shared/GameTile.dart';
import 'dart:developer';

import '../services/firebaseService.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  MongodbService dbService;
  bool loading = false;
  List<dynamic> games = [];
  String searchQuery = "";
  int pageNumber = 0;
  bool noMoreResults = false;
  String consoleValue = "PlayStation";
  List<String> consoles = [
    "PlayStation",
    "PlayStation 2",
    "PlayStation 3",
    "PlayStation 4",
    "PlayStation 5",
    "PlayStation Vita",
    "PlayStation Portable"
  ];
  final controller = TextEditingController();

  void changeText(String searchQuery) {
    setState(() {
      this.searchQuery = searchQuery;
    });
  }

  void loadMoreResults(MongodbService dbservice) async {
    setState(() {
      pageNumber += 1;
    });
    List<dynamic> results = await dbService.getgameResults(
        searchQuery, tags[consoleValue], pageNumber);
    if (results.isEmpty) {
      setState(() {
        noMoreResults = true;
      });
    } else {
      List<dynamic> newResults = [...games, ...results];
      setState(() {
        games = newResults;
      });
      //log("AFTER ADDING: ${games.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Search Games")),
      body: Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: changeText,
              decoration: const InputDecoration(
                  labelText: 'Search for a game using phrases or keywords'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Console: "),
              DropdownButton(
                  value: consoleValue,
                  hint: const Text('Choose the console'),
                  items: consoles.map((String console) {
                    return DropdownMenuItem(
                      value: console,
                      child: Text(console),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      consoleValue = newValue;
                    });
                  })
            ],
          ),
          ElevatedButton(
              onPressed: searchQuery == ""
                  ? null
                  : () async {
                      await firebaseUser.getIdToken().then((token) async {
                        dbService = MongodbService(token: token);
                        setState(() {
                          loading = true;
                          noMoreResults = false;
                          pageNumber = 0;
                        });
                        List<dynamic> games = await dbService.getgameResults(
                            searchQuery, tags[consoleValue], 0);
                        //log(games.toString());
                        setState(() {
                          this.games = games;
                          loading = false;
                        });
                      });
                    },
              child: const Text("Search Games")),
          const SizedBox(height: 10),
          Expanded(
            child: loading
                ? const Loading(text: "")
                : games.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                            child: Text(
                          "Nothing to show, search for a game using the search bar above",
                          textAlign: TextAlign.center,
                        )))
                    : games[0] is Games
                        ? ListView.builder(
                            itemCount: games.length,
                            itemBuilder: (_, index) {
                              return GameTile(
                                  user: firebaseUser,
                                  id: games[index].id,
                                  title: games[index].title,
                                  platform: games[index].platform,
                                  releaseDate: games[index].releaseDate,
                                  imageLink: games[index].imageLink);
                            },
                          )
                        : Center(
                            child: Text(
                            games[0]['error'],
                            style: const TextStyle(color: Colors.red),
                          )),
          ),
          const SizedBox(height: 10),
          Container(
              padding: const EdgeInsetsDirectional.only(bottom: 35),
              child: noMoreResults == false
                  ? games.isEmpty || games[0] is! Games
                      ? Container()
                      : TextButton(
                          onPressed: () {
                            loadMoreResults(dbService);
                          },
                          child: const Text('Load more results..'))
                  : const Text("No more results to show"))
        ]),
      ),
    );
  }
}
