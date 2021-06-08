import 'package:consultation_app/common_widget/basic_button.dart';
import 'package:consultation_app/tools/app_localizations.dart';
import 'package:consultation_app/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  var _controllerUserName = TextEditingController();

  var _feedbackController = TextEditingController();

  @override
  void dispose() {
    _controllerUserName.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controllerUserName = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);

    Future<void> _sendFeedback(String feedback) async {
      if (feedback.length < 10) {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Lütfen en az 10 karakter giriniz.",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        String userId = _userViewModel.user.userId;

        bool result = await _userViewModel.sendFeedback(userId, feedback);

        if (result) {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Geri bildirminiz için teşekkürler.",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _feedbackController.clear();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              AppLocalizations.of(context).translate("error_occurred_text"),
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("feedback_txt")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  AppLocalizations.of(context).translate("username_text"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _controllerUserName,
                decoration: InputDecoration(
                  hintText: _userViewModel.user.userName,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  AppLocalizations.of(context).translate("feedback_txt"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              TextFormField(
                maxLines: 6,
                maxLength: 500,
                controller: _feedbackController,
                decoration: InputDecoration(
                  hintText: "Lütfen geri bildiriminizi girin.",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  contentPadding: EdgeInsets.fromLTRB(0, 15, 10, 5),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: BasicButton(
                  buttonText: "Gönder",
                  buttonOnPressed: () =>
                      _sendFeedback(_feedbackController.text),
                  buttonMargin: 0,
                  buttonColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
