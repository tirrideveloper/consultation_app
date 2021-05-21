import 'package:flutter/material.dart';

class KonuGir extends StatefulWidget {
  const KonuGir({Key key}) : super(key: key);

  @override
  _KonuGirState createState() => _KonuGirState();
}

class _KonuGirState extends State<KonuGir> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konu Gir"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Konu başlığı seç"),
          ],
        ),
      ),
    );
  }
}
