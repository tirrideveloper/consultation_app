import 'package:consultation_app/models/app_localizations.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("tab_item_search")),
      ),
      body: Center(
        child: Text("Arama Sayfasi"),
      ),
    );
  }
}
