import 'package:consultation_app/tools/tablet_detector.dart';
import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final double buttonHeight;
  final double buttonRadius;
  final Widget buttonIcon;
  final VoidCallback buttonOnPressed;
  final double buttonMargin;
  final double buttonTextSize;

  const BasicButton(
      {Key key,
      @required this.buttonText,
      this.buttonColor,
      this.buttonTextColor: Colors.white,
      this.buttonRadius: 15,
      this.buttonIcon,
      this.buttonOnPressed,
      this.buttonHeight,
      this.buttonMargin: 10,
      this.buttonTextSize: 16})
      : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: TabletDetector.isTablet() != true
              ? buttonMargin
              : buttonMargin * 2),
      child: SizedBox(
        height:
            TabletDetector.isTablet() != true ? buttonHeight : buttonHeight * 2,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  TabletDetector.isTablet() != true
                      ? buttonRadius
                      : buttonRadius * 2),
            ),
          ),
          onPressed: buttonOnPressed,
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (buttonIcon != null) ...[
                  buttonIcon,
                  Text(
                    buttonText,
                    style: TextStyle(
                        color: buttonTextColor,
                        fontSize: TabletDetector.isTablet() != true
                            ? buttonTextSize
                            : buttonTextSize * 2),
                  ),
                  Container()
                ],
                if (buttonIcon == null) ...[
                  Container(),
                  Text(buttonText, style: TextStyle(color: buttonTextColor)),
                  Container()
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
