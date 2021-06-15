import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PhotoDetail extends StatefulWidget {
  final dynamic imgPath;

  PhotoDetail({this.imgPath});

  @override
  _PhotoDetailState createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {
  PaletteGenerator paletteGenerator;
  Color paletteBackgroundColor;

  @override
  void initState() {
    super.initState();
    findColor();
  }

  void findColor() {
    Future<PaletteGenerator> fPaletteGenerator = PaletteGenerator
        .fromImageProvider(NetworkImage(widget.imgPath));
    fPaletteGenerator.then((value){
      paletteGenerator = value;
      setState(() {
        paletteBackgroundColor = paletteGenerator.lightMutedColor.color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery
                .of(context)
                .size
                .height,
            backgroundColor: paletteBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.imgPath,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.imgPath),
                          fit: BoxFit.fitWidth)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}