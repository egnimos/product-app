import 'package:flutter/material.dart';

class SizeConfig {
  static double? _screenWidth;
  static double? _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static double? heightMultiplier;
  static double? widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  // static double fontSize;

  void init(BoxConstraints constraints, Orientation orientation, {bool disableLandscape = true}) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth !< 450) {
        isMobilePortrait =
            true; //for mobile portrait only not for tablet, and other screens
      }
    } else {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth !/ 100;
    _blockSizeVertical = _screenHeight !/ 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal * 0.7;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
  } //end of init

  // void setDeviceHeight(double _height) {
  //   fontSize = _height / 100;
  // }
}
