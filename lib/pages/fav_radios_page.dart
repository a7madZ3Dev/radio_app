import 'package:flutter/material.dart';

import './radio_page.dart';

class FavRadiosPage extends StatelessWidget {
  const FavRadiosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RadioPage(isFavoriteOnly: true);
  }
}
