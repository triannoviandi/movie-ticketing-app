import 'package:flutter/material.dart';

class VideoClipper extends CustomClipper<Path> {
  double curveValue;

  VideoClipper({this.curveValue});

  @override
  Path getClip(Size size) {
    var path = Path();
    print("clip = " + curveValue.toString());
    path.lineTo(0, size.height / 4 * curveValue);
    path.quadraticBezierTo(
        size.width / 2, 0, size.width, size.height / 4 * curveValue);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
