import 'package:game_collector/models/games.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer';

class MongodbService {
  final String token;
  MongodbService({this.token});

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

  // ignore: missing_return
  Future<List<dynamic>> getgameResults(
      String searchQuery, String tags, int pageNumber) async {
    var url = Uri.parse(
        'http://192.168.1.104:3000/data/gameSearch?p=$pageNumber&title=$searchQuery&tags=$tags');
    var response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response('Error', 408);
    });
    log(response.body);
    if (response.body == 'Error') {
      return [
        {"error": "There was some error in returning the data"}
      ];
    } else {
      try {
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          List<dynamic> result = jsonResponse.map((game) {
            return Games(
              id: game['_id'],
              title: game['title'],
              releaseDate: game['release_date'],
              metacriticScore: game['metacritic_score'],
              imageLink: game['image_link'],
              description: game['description'],
              platform: game['platform'],
              tags: game['tags'],
            );
          }).toList();
          log(result.toString());
          return result;
        } else {
          log(response.body);
          return [
            {"error": "There was some error in returning the data"}
          ];
        }
      } catch (error) {
        return [
          {"error": "There was some error in returning the data"}
        ];
      }
    }
  }

  Future<dynamic> getGame(String gameId) async {
    var url = Uri.parse('http://192.168.0.107:3000/data/games/$gameId');
    var response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response('Error', 408);
    });
    log(response.body);
    if (response.body == 'Error') {
      return [
        {"error": "There was some error in returning the data"}
      ];
    } else {
      try {
        if (response.statusCode == 200) {
          var game = convert.jsonDecode(response.body);
          dynamic result = Games(
            id: game['_id'],
            title: game['title'],
            releaseDate: game['release_date'],
            metacriticScore: game['metacritic_score'],
            imageLink: game['image_link'],
            description: game['description'],
            platform: game['platform'],
            tags: game['tags'],
          );
          log(result.toString());
          return result;
        } else {
          log(response.body);
          return {"error": "There was some error in returning the data"};
        }
      } catch (error) {
        return {"error": "There was some error in returning the data"};
      }
    }
  }
}
