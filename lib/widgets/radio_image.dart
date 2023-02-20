import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import '../utils/hex_colors.dart';

Widget image(String url, {double? size}) {
  return Container(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        url,
        errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
          'assets/images/radio.svg',
          fit: BoxFit.contain,
        ),
      ),
    ),
    height: size ?? 55,
    width: size ?? 55,
    decoration: BoxDecoration(
      color: HexColor("#FFE5EC"),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
  );
}
