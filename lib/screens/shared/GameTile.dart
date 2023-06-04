import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../services/firebaseService.dart';
import 'callSnackBar.dart';

class GameTile extends StatefulWidget {
  const GameTile(
      {Key key,
      this.user,
      this.id,
      this.platform,
      this.releaseDate,
      this.title,
      this.imageLink})
      : super(key: key);
  final User user;
  final String title;
  final String platform;
  final String releaseDate;
  final String imageLink;
  final String id;

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  FirebaseService fbService;
  bool loading = true;
  bool inCollection = false;
  @override
  void initState() {
    super.initState();
    checkGameInCollection(widget.id);
  }

  void addGameToCollection(FirebaseService fbService, String id, String title,
      String platform) async {
    fbService.addGameToCollection(id, title, platform).then((value) =>
        {ScaffoldMessenger.of(context).showSnackBar(returnSnackBar(value))});
  }

  void checkGameInCollection(String gameId) {
    setState(() {
      fbService = FirebaseService(firebaseUser: widget.user);
      fbService.gameInCollection(gameId).then((value) => {
            setState(() {
              inCollection = value;
              loading = false;
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(8, 10, 0, 10),
        leading: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: widget.imageLink,
        ),
        title: Text(widget.title),
        subtitle: Text(
          '${widget.platform}\nReleased: ${widget.releaseDate.substring(0, 15)}',
          style:
              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13.0),
        ),
        trailing: loading
            ? const CircularProgressIndicator()
            : inCollection
                ? Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: const Text("Collected"))
                : TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      addGameToCollection(
                          fbService, widget.id, widget.title, widget.platform);
                      setState(() {
                        inCollection = true;
                      });
                    },
                  ),
      ),
    );
  }
}
