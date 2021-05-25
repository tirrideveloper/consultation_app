import 'package:consultation_app/tools/app_localizations.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final String userRank;
  final String userCase;
  final String userComment;

  const NumbersWidget({Key key, this.userRank, this.userCase, this.userComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, userRank,
              AppLocalizations.of(context).translate("profile_rank")),
          buildDivider(),
          buildButton(context, userCase,
              "Vaka Sayısı"),
          buildDivider(),
          buildButton(context, userComment,
              "Yorum"),
        ],
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
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
