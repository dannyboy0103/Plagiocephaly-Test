import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TummyView extends StatefulWidget {
  @override
  _TummyViewState createState() => _TummyViewState();
}

class _TummyViewState extends State<TummyView> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text(
          '터미타임',
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
          children: [
            SizedBox(height: 56,),
            Container(
              padding: EdgeInsets.all(20),
              child: AutoSizeText(
                '터미 타임이란?',
                minFontSize: 20,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/2,
              width: MediaQuery.of(context).size.width/2,
              child: Center(
                child: Image.asset(
                  'assets/tummy_baby.png',
                  fit: BoxFit.fill,
                  )
                ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: AutoSizeText(
                '아기를 들고, 안고, 기저귀를 갈고, 놓고, 수유하고, 함께 놀이를 하는 것과 같은 활동입니다.',
                style: TextStyle(
                  height: 2,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: AutoSizeText(
                '왜 필요한가요?',
                minFontSize: 20,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: AutoSizeText(
                '눕혀 재우는 자세로 아기의 머리에 지속적인 압박을 주면 두개골을 납작하게 만들 수 있습니다. 이는 두상 비대칭을 초래할 수 있으니 항상 터미 타임을 통해 예방해줘야 합니다.',
                style: TextStyle(
                  height: 2,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: AutoSizeText(
                '터미 타임은 모든 아기들에게 도움이 되고 부모와 유대감을 형성할 수 있는 좋은 시간입니다.',
                style: TextStyle(
                  height: 2,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: AutoSizeText(
                '터미 타임은 목과 어깨 근육을 발달시키고 목 근육이 뻣뻣해지는 것을 방지하며 머리가 납작해지는 것을 방지합니다.',
                style: TextStyle(
                  height: 2,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),
              ),
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