import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_collector/services/mongoDBservice.dart';
import 'package:game_collector/screens/shared/GameTile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String token;
  MongodbService dbService;
  List<dynamic> games = [];
  @override
  void initState() {
    super.initState();
    getPrerequisites();
  }

  Future<void> getPrerequisites() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString('token');
      dbService = MongodbService(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Search Games")),
      body: Center(
        child: Column(children: [
          ElevatedButton(
              onPressed: () async {
                List<dynamic> games =
                    await dbService.getgameResults("assassin", "ps3", 0);
                setState(() {
                  this.games = games;
                });
              },
              child: const Text("Search Games")),
          Expanded(
            child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (_, index) {
                return GameTile(
                    title: games[index].title,
                    platform: games[index].platform,
                    releaseDate: games[index].releaseDate,
                    imageLink: games[index].imageLink);
              },
            ),
          ),
          Container(
              padding: const EdgeInsetsDirectional.only(bottom: 100),
              child: TextButton(
                  onPressed: () {}, child: const Text('Load more results..')))
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
