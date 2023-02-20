// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/radio.dart';
import '../utils/db_service.dart';
import '../services/db_download_service.dart';

enum RadioPlayerState {
  loading,
  stopped,
  playing,
  paused,
  completed,
}

class PlayerProvider with ChangeNotifier {
  AudioPlayer? _audioPlayer;
  AudioPlayer? get getAudioPlayer => _audioPlayer;

  RadioModel? _radioDetails;
  RadioModel get currentRadio => _radioDetails!;

  List<RadioModel>? _radiosFetcher;
  List<RadioModel> get allRadio => _radiosFetcher!;
  int get totalRecords => _radiosFetcher?.length ?? 0;

  RadioPlayerState _playerState = RadioPlayerState.stopped;
  RadioPlayerState get getPlayerState => _playerState;

  StreamSubscription? _positionSubscription;

  PlayerProvider() {
    _initStreams();
  }

  void _initStreams() {
    _radiosFetcher = [];
    _radioDetails ??= RadioModel(id: 0);
  }

  void resetStreams() {
    _initStreams();
  }

  void initAudioPlugin() {
    if (_playerState == RadioPlayerState.stopped) {
      _audioPlayer = AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer;
    }
  }

  Future<void> setAudioPlayer(RadioModel radio) async {
    _radioDetails = radio;

    await initAudioPlayer();
    notifyListeners();
  }

  Future<void> initAudioPlayer() async {
    updatePlayerState(RadioPlayerState.loading);

    _positionSubscription =
        _audioPlayer!.onPositionChanged.listen((Duration p) {
      if (_playerState == RadioPlayerState.loading && p.inMilliseconds > 0) {
        updatePlayerState(RadioPlayerState.playing);
      }
      notifyListeners();
    });

    _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) async {
      print("Flutter : state : " + state.toString());
      if (state == PlayerState.playing) {
        //updatePlayerState(RadioPlayerState.PLAYING);
        //notifyListeners();
      } else if (state == PlayerState.stopped ||
          state == PlayerState.completed) {
        updatePlayerState(RadioPlayerState.stopped);
        notifyListeners();
      }
    });
  }

  Future<void> playRadio() async {
    await _audioPlayer!.play(
      UrlSource(currentRadio.radioURL!),
    );
  }

  Future<void> stopRadio() async {
    if (_audioPlayer != null) {
      _positionSubscription?.cancel();
      updatePlayerState(RadioPlayerState.stopped);
      await _audioPlayer!.stop();
    }
  }

  bool isPlaying() {
    return getPlayerState == RadioPlayerState.playing;
  }

  bool isLoading() {
    return getPlayerState == RadioPlayerState.loading;
  }

  bool isStopped() {
    return getPlayerState == RadioPlayerState.stopped;
  }

  Future<void> fetchAllRadios({
    String searchQuery = "",
    bool isFavoriteOnly = false,
  }) async {
    _radiosFetcher = await DBDownloadService.fetchLocalDB(
      searchQuery: searchQuery,
      isFavoriteOnly: isFavoriteOnly,
    );
    notifyListeners();
  }

  void updatePlayerState(RadioPlayerState state) {
    _playerState = state;
    notifyListeners();
  }

  Future<void> radioBookmarked(int radioID, bool isFavorite,
      {bool isFavoriteOnly = false}) async {
    int isFavoriteVal = isFavorite ? 1 : 0;
    await DB.init();
    await DB.rawInsert(
      "INSERT OR REPLACE INTO radios_bookmarks (id, isFavorite) VALUES ($radioID, $isFavoriteVal)",
    );

    await fetchAllRadios(isFavoriteOnly: isFavoriteOnly);
  }
}
