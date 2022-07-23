import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class HelmetView extends StatefulWidget {
  @override
  _HelmetViewState createState() => _HelmetViewState();
}

class _HelmetViewState extends State<HelmetView> {
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
          '두상 교정모',
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
              height: screenHeight/4,
              width: screenWidth,
              child: Row(
                children: [
                  Expanded(
                  flex: 5,
                  child: Center(
                    child: AutoSizeText(
                      '두상교정모 안내',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Image(
                        image: AssetImage('assets/helmet.png'),
                        height: screenWidth/4,
                        width: screenWidth/4,
                      )
                    ),
                  ),
                )
                ]
                
              ),
            ),
            Container(
              height: screenHeight/2,
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    child: AutoSizeText(
                      '두상 교정모 치료가 필요한 경우는?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                        AutoSizeText(
                        '레벨 3 혹은 4에 해당한다면 사두증 전문가의 진단에 따라 교정모 착용이 필요할 수도 있습니다.',
                        style: TextStyle(
                                      color: Colors.blueGrey,
                              ),
                      ),
                      AutoSizeText(
                        '우선 영상 촬영으로 단순 사두증이라고 판단되면 빠르게 교정모 치료를 시작하여 두상의 비대칭이 악화되는 것을 방지해야 합니다. ',
                        style: TextStyle(
                                      color: Colors.blueGrey,
                              ),
                      )
                      ]
                      
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: screenHeight-56,
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    child: AutoSizeText(
                      '교정모의 치료 원리',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),

                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Image(
                          image: AssetImage('assets/baby_with_helmet.png'),
                          width: screenWidth/3,
                          height: screenHeight/3,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15,15,15,0),
                              child: Center(
                                child: AutoSizeText(
                                  '작용은 크게 두가지 입니다.',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                  ),

                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              //padding: EdgeInsets.all(15),
                              child: AutoSizeText(
                                '1. 아기 머리 밑에 쿠션을 두어 원하지 않은 압박을 방지합니다. 따라서, 두상이 올바르게 성장하도록 합니다.',
                                style: TextStyle(
                                      color: Colors.blueGrey,
                              ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              //padding: EdgeInsets.all(15),
                              child: AutoSizeText(
                                '2. 두상 교정모는 맞춤 제작되어 아기 머리의 납작한 부분이 자라도록 유발하여 돌출된 부위와의 차이를 경감시켜 자연적으로 이마의 비대칭도 치료합니다.',
                                style: TextStyle(
                                      color: Colors.blueGrey,
                              ),
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),
            Container(
              height: screenHeight/2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                  ),
                  child: AutoSizeText(
                    '교정모 치료 기간',
                    style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                    ),
                  ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: AutoSizeText(
                        '치료 기간은 아기의 사두증 정도 및 치료 시작 시기에 따라 달라집니다. 일반적으로 치료가 시작 되면 3-6개월 정도의 정도의 치료가 필요합니다. ',
                        style: TextStyle(
                                      color: Colors.blueGrey,
                              ),
                      )
                    ),
                  )
                ],
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
        )
      ),
    );
  }
}