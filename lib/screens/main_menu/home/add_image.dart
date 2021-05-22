import 'package:consultation_app/models/case_model.dart';
import 'package:flutter/material.dart';

class AddImage extends StatefulWidget {
  final CaseModel caseModel;

  AddImage({this.caseModel});

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    var _case = widget.caseModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(_case.caseTitle),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Yükle"),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return index == 0
              ? Center(
                  child: IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () {},
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
