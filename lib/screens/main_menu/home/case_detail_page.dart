import 'package:consultation_app/models/case_model.dart';
import 'package:flutter/material.dart';

class CaseDetailPage extends StatefulWidget {
  final CaseModel caseModel;

  const CaseDetailPage({this.caseModel});

  @override
  _CaseDetailPageState createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  @override
  Widget build(BuildContext context) {
    var _case = widget.caseModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(_case.caseTitle),
      ),
      body: Center(child: Text(_case.caseBody),),
    );
  }
}
