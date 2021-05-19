import 'dart:ui' as ui;

class TabletDetector{
  static bool isTablet() {

    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;
    if(devicePixelRatio < 2 && (width >=1000 || height>=1000)){
      return true;
    }
    else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)){
      return true;
    }
    else{
      return false;
    }
  }
}
