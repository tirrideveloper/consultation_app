import 'package:consultation_app/models/app_localizations.dart';
import 'package:flutter/material.dart';

class Errors {
  static String showError(String errorCode, BuildContext context) {
    switch (errorCode) {
      case 'emaıl-already-ın-use':
        return AppLocalizations.of(context)
            .translate("email_already_use_error");

      case 'user-not-found':
        return AppLocalizations.of(context).translate("user_not_found_error");

      case 'wrong-password':
        return AppLocalizations.of(context).translate("wrong_password_error");

      default:
        return AppLocalizations.of(context).translate("error_occurred_tex");
    }
  }
}
