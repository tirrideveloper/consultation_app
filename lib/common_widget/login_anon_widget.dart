import 'package:consultation_app/models/app_localizations.dart';
import 'package:flutter/material.dart';

class LoginAnonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10, right: width / 4),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Text(
              AppLocalizations.of(context).translate("without_sign_up"),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
