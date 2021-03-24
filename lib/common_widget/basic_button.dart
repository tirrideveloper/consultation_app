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

  const BasicButton(
      {Key key,
        @required this.buttonText,
        this.buttonColor,
        this.buttonTextColor: Colors.white,
        this.buttonRadius: 15,
        this.buttonIcon,
        this.buttonOnPressed,
        this.buttonHeight,
        this.buttonMargin: 10})
      : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: buttonMargin),
      child: SizedBox(
        height: buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius))
          ),
          onPressed: buttonOnPressed,
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (buttonIcon != null) ...[
                  buttonIcon,
                  Text(buttonText,
                      style: TextStyle(color: buttonTextColor, fontSize: 17)),
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
