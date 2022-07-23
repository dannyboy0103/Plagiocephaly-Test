import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mybabyskull/constants.dart';

class WebsiteIntroView extends StatefulWidget {
  @override
  _WebsiteIntroViewState createState() => _WebsiteIntroViewState();
}

class _WebsiteIntroViewState extends State<WebsiteIntroView> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  Colors.black.withOpacity(0.8),
        title: AutoSizeText(
          '우리 아기 두상 괜찮을까?',
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
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              //margin: EdgeInsets.all(40),
              //padding: EdgeInsets.all(20),
              width: screenWidth,
              child: Column(
                children: [
                  Container(
                    //height: screenHeight-56,
                    width: screenWidth,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: AutoSizeText(
                              '이 사이트는 누구를 위한 사이트 인가요?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: AutoSizeText(
                                  '아이에게 이쁜두상을 만들어주고 싶은 엄마 아빠',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: AutoSizeText(
                                  '비대칭인 아이의 두상이 병원에 갈 정도 인지 궁금한 엄마 아빠',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: AutoSizeText(
                                  '두상 비대칭에 대한 정보가 부족해서 전문가에게 상의하고 싶은 엄마 아빠',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: AutoSizeText(
                                  '두상 비대칭이 왜 우리아기의 미래에 중요한지 아직 모르는 엄마 아빠',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              )
                            ],
                          )
                        )
                        
                      ],
                    ),
                  ),
                  Container(
                    //height: screenHeight-56,
                    width: screenWidth,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: AutoSizeText(
                              '치료해야하는 비대칭을 치료하지 않는다면?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: AutoSizeText(
                                  '심한 사두증을 가진 아기 중 일부는 두개골 조기유합증일 가능성도 있습니다. ',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: AutoSizeText(
                                  '두개골 조기유합증은 두개골 뼈의 유합이 너무 일찍 되어서 두개골이 제대로 자라지 못하는 병입니다. 수술적 치료는 필수이며 조기에 발견하는 것이 매우 중요합니다.',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: AutoSizeText(
                                  '육안으로는 사두증과 구별하기 어렵기 때문에 비대칭이 심한 아기는 꼭 전문가의 진찰을 받아야 합니다. ',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: AutoSizeText(
                                  '조기 치료를 하지 않을경우 아기 두뇌 발달에도 영향이 있으므로 조금만 관심을 가지면 올바른 치료를 받을수 있습니다.',
                                  style: TextStyle(
                                            color: Colors.blueGrey,
                                    ),
                                  ),
                              ),
                              
                            ],
                          )
                        )
                        
                      ],
                    ),
                  ),
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
        ),
      ),
    );
  }
}