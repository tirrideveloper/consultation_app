import 'dart:io';

import 'package:consultation_app/common_widget/photo_detail.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key key,
    this.imagePath,
    this.isEdit = false,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(context),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    final image = imagePath.contains('https')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => PhotoDetail(imgPath: imagePath))),
      child: Hero(
        tag: imagePath,
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: image as ImageProvider,
              fit: BoxFit.cover,
              width: 128,
              height: 128,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: Color(0xff689f38),
          all: 8,
          child: InkWell(
            onTap: onClicked,
            child: Icon(
              isEdit ? Icons.mail : Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    Widget child,
    double all,
    Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
