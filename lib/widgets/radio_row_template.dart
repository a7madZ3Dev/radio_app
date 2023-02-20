import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/radio.dart';
import '../utils/hex_colors.dart';
import '../widgets/radio_image.dart';
import '../services/player_provider.dart';

class RadioRowTemplate extends StatelessWidget {
  final RadioModel radioModel;
  final bool? isFavoriteOnlyRadios;

  const RadioRowTemplate({
    Key? key,
    required this.radioModel,
    this.isFavoriteOnlyRadios,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSongRow(context);
  }

  Widget _buildSongRow(BuildContext context) {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    final bool _isSelectedRadio =
        radioModel.id == playerProvider.currentRadio.id;

    return ListTile(
      title: Text(
        radioModel.radioName!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: HexColor("#182545"),
        ),
      ),
      leading: image(radioModel.radioPic!),
      subtitle: Text(radioModel.radioDesc!, maxLines: 2),
      trailing: Wrap(
        spacing: -10.0, // gap between adjacent chips
        runSpacing: 0.0, // gap between lines
        children: <Widget>[
          _buildPlayStopIcon(
            playerProvider,
            _isSelectedRadio,
          ),
          _buildAddFavoriteIcon(context),
        ],
      ),
    );
  }

  Widget _buildPlayStopIcon(
      PlayerProvider playerProvider, bool _isSelectedSong) {
    return IconButton(
      icon: _buildAudioButton(playerProvider, _isSelectedSong),
      onPressed: () async {
        if (!playerProvider.isStopped() && _isSelectedSong) {
          playerProvider.stopRadio();
        } else {
          if (!playerProvider.isLoading()) {
            playerProvider.initAudioPlugin();
            await playerProvider.setAudioPlayer(radioModel);
            await playerProvider.playRadio();
          }
        }
      },
    );
  }

  Widget _buildAudioButton(PlayerProvider model, _isSelectedSong) {
    if (_isSelectedSong) {
      if (model.isLoading()) {
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2.0),
        );
      }

      if (!model.isStopped()) {
        return const Icon(Icons.stop);
      }

      if (model.isStopped()) {
        return const Icon(Icons.play_circle_filled);
      }
    } else {
      return const Icon(Icons.play_circle_filled);
    }

    return Container();
  }

  Widget _buildAddFavoriteIcon(BuildContext context) {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return IconButton(
      icon: radioModel.isBookmarked!
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
      color: HexColor("#9097A6"),
      onPressed: () {
        playerProvider.radioBookmarked(
          radioModel.id!,
          !radioModel.isBookmarked!,
          isFavoriteOnly: isFavoriteOnlyRadios!,
        );
      },
    );
  }
}
