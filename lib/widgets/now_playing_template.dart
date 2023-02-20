import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/hex_colors.dart';
import '../widgets/radio_image.dart';
import '../services/player_provider.dart';

class NowPlayingTemplate extends StatelessWidget {
  final String? radioTitle;
  final String? radioImageURL;

  const NowPlayingTemplate(
      {Key? key, required this.radioTitle, required this.radioImageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: HexColor("#182560")),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _nowPlayingText(context, radioTitle!, radioImageURL!),
          ],
        ),
      ),
    );
  }

  Widget _nowPlayingText(BuildContext context, String title, String imageURL) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: HexColor("#ffffff"),
          ),
        ),
        subtitle: Text(
          "Now Playing",
          textScaleFactor: 0.8,
          style: TextStyle(
            color: HexColor("#ffffff"),
          ),
        ),
        leading: image(imageURL, size: 50.0),
        trailing: Wrap(
          spacing: -10.0,
          children: <Widget>[
            _buildStopIcon(context),
            _buildShareIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildStopIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.stop),
      color: HexColor("#9097A6"),
      onPressed: () {
        Provider.of<PlayerProvider>(context, listen: false).stopRadio();
      },
    );
  }

  Widget _buildShareIcon() {
    return IconButton(
      icon: const Icon(Icons.share),
      color: HexColor("#9097A6"),
      onPressed: () {},
    );
  }
}
