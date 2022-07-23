import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultLevelBox extends StatefulWidget {
  final String title, descriptions, text;

  const ResultLevelBox({Key key, this.title, this.descriptions, this.text})
      : super(key: key);

  @override
  _ResultLevelBoxState createState() => _ResultLevelBoxState();
}

class _ResultLevelBoxState extends State<ResultLevelBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var min30 = min(screenWidth * (1 / 30), screenHeight * (1 / 30));
    var min20 = min(screenWidth * (1 / 20), screenHeight * (1 / 20));
    var min10 = min(screenWidth * (1 / 10), screenHeight * (1 / 10));

    return Container(
      child: Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Image(
                height: screenHeight * (5 / 6),
                image: AssetImage(
                  'assets/resultLevel.jpeg',
                ),
              ),
            ),
            NeumorphicButton(
              style: NeumorphicStyle(
                color: Colors.blueAccent,
                depth: 3,
                // shadowDarkColor: Colors.grey,
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(10),
                ),
              ),
              onPressed: _launchURL,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: min20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //     extendBodyBehindAppBar: true,
    //     appBar: AppBar(
    //       backgroundColor: Colors.white.withOpacity(0),
    //       actions: [
    //         FlatButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Icon(
    //             Icons.close,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ],
    //     ),
    //     body: Column(
    //       children: [
    //         Image(
    //           image: AssetImage('assets/resultLevel.jpeg'),
    //           height: screenHeight * (2 / 3),
    //         ),
    //         NeumorphicButton(
    //           style: NeumorphicStyle(
    //             color: Colors.blueAccent,
    //             depth: 3,
    //             shadowDarkColor: Colors.grey,
    //             shape: NeumorphicShape.convex,
    //             boxShape: NeumorphicBoxShape.roundRect(
    //               BorderRadius.circular(10),
    //             ),
    //           ),
    //           onPressed: _launchURL,
    //           child: Text(
    //             widget.text,
    //             style: TextStyle(
    //               fontSize: min20,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ));
  }
}

_launchURL() async {
  const url = 'https://naver.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Constants {
  Constants._();
  static const double padding = 10;
  static const double avatarRadius = 45;
}
