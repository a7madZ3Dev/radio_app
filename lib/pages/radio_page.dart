import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/hex_colors.dart';
import '../services/player_provider.dart';
import '../widgets/radio_row_template.dart';
import '../widgets/now_playing_template.dart';

class RadioPage extends StatefulWidget {
  final bool? isFavoriteOnly;
  const RadioPage({Key? key, this.isFavoriteOnly}) : super(key: key);

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final _searchQuery = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    _onSearchChanged() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
         playerProvider.fetchAllRadios(
          isFavoriteOnly: widget.isFavoriteOnly!,
          searchQuery: _searchQuery.text,
        );
      });
    }

    _searchQuery.addListener(_onSearchChanged);
    playerProvider.initAudioPlugin();
    playerProvider.resetStreams();
    playerProvider.fetchAllRadios(isFavoriteOnly: widget.isFavoriteOnly!);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _appLogo(),
        _searchBar(),
        _radiosList(),
        _nowPlaying(),
      ],
    );
  }

  Widget _appLogo() {
    return Container(
      width: double.infinity,
      color: HexColor("#182545"),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/radio.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.search),
          Flexible(
            child: TextField(
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                hintText: 'Search Radio',
              ),
              controller: _searchQuery,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _noData() {
    String noDataTxt = "";
    bool showTextMessage = false;

    if (widget.isFavoriteOnly! ||
        (widget.isFavoriteOnly! && _searchQuery.text.isNotEmpty)) {
      noDataTxt = "No Favorites";
      showTextMessage = true;
    } else if (_searchQuery.text.isNotEmpty) {
      noDataTxt = "No Radio Found";
      showTextMessage = true;
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: showTextMessage
                ? Text(
                    noDataTxt,
                    textScaleFactor: 1,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _radiosList() {
    return Consumer<PlayerProvider>(
      builder: (context, radioModel, child) {
        if (radioModel.totalRecords > 0) {
          return Expanded(
            child: Padding(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                      itemCount: radioModel.totalRecords,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RadioRowTemplate(
                          radioModel: radioModel.allRadio[index],
                          isFavoriteOnlyRadios: widget.isFavoriteOnly,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      })
                ],
              ),
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
          );
        }

        if (radioModel.totalRecords == 0) {
          return Expanded(
            child: _noData(),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Widget _nowPlaying() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return Visibility(
      visible: playerProvider.getPlayerState == RadioPlayerState.playing,
      child: NowPlayingTemplate(
        radioTitle: playerProvider.currentRadio.radioName,
        radioImageURL: playerProvider.currentRadio.radioPic,
      ),
    );
  }
}
