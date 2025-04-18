import 'package:flutter/material.dart';
import 'package:mydriver/extensions/Color.dart';


TextStyle HeaderStyle() {
  return TextStyle(
    color: jcbDarkColor,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 20.0,
    height: 0.5,
  );
}

TextStyle bodyStyle() {
  return TextStyle(color: jcbDarkColor, fontSize: 14.0);
}
