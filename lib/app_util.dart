import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppColor {
  static const Color primary = Color(0xffF9B015);
}

class AppIcon {
  static Widget greyChair() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[800]),
        child: SvgPicture.asset("assets/image/chair-light.svg"),
      ),
    );
  }

  static Widget redChair() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[900],
        ),
        child: SvgPicture.asset("assets/image/chair-light.svg"),
      ),
    );
  }

  static Widget whiteChair() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SvgPicture.asset("assets/image/chair-dark.svg"),
      ),
    );
  }

  static Widget yellowChair() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(color: AppColor.primary),
        child: SvgPicture.asset("assets/image/chair-dark.svg"),
      ),
    );
  }
}
