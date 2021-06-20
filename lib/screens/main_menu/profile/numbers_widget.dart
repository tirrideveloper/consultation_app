import 'package:consultation_app/tools/app_localizations.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  String userRank;
  int userCase;
  int userComment;

  NumbersWidget({this.userRank, this.userCase, this.userComment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(context, userRank,
            AppLocalizations.of(context).translate("profile_rank")),
        buildDivider(),
        buildButton(context, userCase.toString(),
            AppLocalizations.of(context).translate("case_txt")),
        buildDivider(),
        buildButton(context, userComment.toString(),
            AppLocalizations.of(context).translate("comment_txt")),
      ],
    );
  }

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
