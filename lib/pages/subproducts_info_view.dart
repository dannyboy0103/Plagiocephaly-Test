import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SubproductsView extends StatefulWidget {
  @override
  _SubproductsViewState createState() => _SubproductsViewState();
}

class _SubproductsViewState extends State<SubproductsView> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.8),
        title: AutoSizeText( 
          '사두증 보조 제품',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: FlatButton(
          child: Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            //Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'initialView');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 56,),
            Container(
              decoration: BoxDecoration(
                color: Colors.black
              ),
              margin: EdgeInsets.symmetric(vertical:25),
              padding: EdgeInsets.symmetric(vertical:20),
              child: Center(
                child: AutoSizeText(
                  'TOP 5 제품',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SubProductTile(
              name: 'Clevamama Baby Pillow',
              img: 'assets/Clevamama_Baby_Pillow.png',
              content: 'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
            ),
            SubProductTile(
              name: 'BabyMoon Pillow',
              img: 'assets/BabyMoon_Pillow.png',
              content: 'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
            ),
            SubProductTile(
              name: 'Safe T Sleep Headwedge Flat Head Deterrent',
              img: 'assets/Headwedge_Flat_Head_Deterrent.png',
              content: 'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
            ),
            SubProductTile(
              name: 'Boppy Noggin Nest Head Support',
              img: 'assets/Boppy_Noggin.png',
              content: 'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
            ),
            SubProductTile(
              name: 'Lifenest Sleep System',
              img: 'assets/Lifenest_Sleep_System.png',
              content: 'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
            ),
            Container(
              height: screenHeight*0.1,
              decoration: BoxDecoration(
                color: Color(0xffbF5F5F5)
              ),
              child: Container(
                alignment: Alignment.center,
                child: AutoSizeText(
                  '회사소개 | 이용약관 | 개인정보처리방침\nCOPYRIGHT (C) Innoyard ALL RIGHTS RESERVED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffD3D3D3)
                  ),
                ),
              ),
            ),
            ],
        ),
      ),
    );
  }
}

class SubProductTile extends StatelessWidget {
  String name;
  String img;
  String content;
  SubProductTile({this.name, this.img, this.content});
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return  Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: AutoSizeText(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kDarkBlueColor,
                    ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Image(
                              image: AssetImage(img),
                              height: screenWidth/3,
                              width: screenWidth/3,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: AutoSizeText(
                              content,
                              style: TextStyle(
                                      color: Colors.blueGrey,
                                  ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              );
  }
}