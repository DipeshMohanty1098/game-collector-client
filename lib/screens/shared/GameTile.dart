import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class GameTile extends StatelessWidget {
  const GameTile(
      {Key key, this.platform, this.releaseDate, this.title, this.imageLink})
      : super(key: key);
  final String title;
  final String platform;
  final String releaseDate;
  final String imageLink;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(8, 10, 0, 10),
        leading: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: imageLink,
        ),
        title: Text(title),
        subtitle: Text(
          '$platform\nReleased: ${releaseDate.substring(0, 15)}',
          style:
              TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13.0),
        ),
        trailing: TextButton(
          child: const Text('Add'),
          onPressed: () {},
        ),
      ),
    );
  }
}
