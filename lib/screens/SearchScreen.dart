import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_collector/models/games.dart';
import 'package:game_collector/screens/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_collector/services/mongoDBservice.dart';
import 'package:game_collector/screens/shared/GameTile.dart';
import 'dart:developer';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  MongodbService dbService;
  bool loading = false;
  List<dynamic> games = [];

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Search Games")),
      body: Center(
        child: Column(children: [
          ElevatedButton(
              onPressed: () async {
                await firebaseUser.getIdToken().then((token) async {
                  dbService = MongodbService(token: token);
                  setState(() {
                    loading = true;
                  });
                  List<dynamic> games =
                      await dbService.getgameResults("assassin", "ps3", 0);
                  log(games.toString());
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
                    ? const Center(child: Text("Nothing to show"))
                    : games[0] is Games
                        ? ListView.builder(
                            itemCount: games.length,
                            itemBuilder: (_, index) {
                              return GameTile(
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
          Container(
              padding: const EdgeInsetsDirectional.only(bottom: 100),
              child: games.isEmpty || games[0] is! Games
                  ? Container()
                  : TextButton(
                      onPressed: () {},
                      child: const Text('Load more results..')))
        ]),
      ),
    );
  }
}

/*
gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
                  */
