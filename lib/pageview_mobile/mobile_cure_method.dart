import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mybabyskull/constants.dart';
import 'package:mybabyskull/pageview_mobile/mobile_cureleveltile.dart';

class CureMethodView extends StatefulWidget {
  @override
  _CureMethodViewState createState() => _CureMethodViewState();
}

class _CureMethodViewState extends State<CureMethodView> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.8),
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
      /*floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellow,
        icon: Image.asset('assets/kakaotalk.png', height: 35, width: 35,),
        label: Text('질문하기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),),
        elevation: 10,
        onPressed: (){
          //카카오톡으로 연결
        },
      ),*/
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            //사두증 단계별 치료
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
                height: screenHeight,
                width: screenWidth,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      '사두증 단계별 치료',
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    AutoSizeText(
                      '아이에 대한 관심은 아이를 올바르게 성장시킵니다.',
                      style: TextStyle(
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    AutoSizeText(
                      '아래로 스크롤해주세요',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ))),
            //레벨 1r
            CureLevelTile(
              title: '레벨 1: 사두증 수치 < 5 & 단두증 < 90',
              subtitle: '안심단계 - 치료: 낮에 2시간 엎어 놓기',
              img: 'assets/normal.png',
              content:
                  '만약 아이가 이 수치에 해당된다면 안심하셔도 됩니다.  낮에 아이와 Tummy time를(엎어 놓기 놀이) 자주해 주세요. 엎어 놓기 놀이는 아이의 행동 발달에도 도움이 되고 두상 비대칭 예방도 되어 일석이조의 효과를 얻을수 있습니다.',
            ),
            SizedBox(height: 56),
            //레벨2
            CureLevelTile(
              title: '레벨 2: 사두증 수치 5-8 & 단두증 < 90',
              subtitle: '관심단계 - 치료: 잘때 위치 변경 + 낮에 자주 엎어 놓기',
              img: 'assets/level2.png',
              content:
                  '이 수치에 해당 된다면 정상에 가깝고, 이마 및 두상의 비대칭이 심하지 않아 잘 관리 해주시면 심한 얼굴 비대칭까지 오지는 않습니다. 다만, 아이의 두상 모양은 성장하면서 좋아지지 않는 경우도 많습니다. 따라서, 방심은 금물! 이 상태를 유지하기 위해 잘때 머리위치를 자주 변경해주시고 낮에는 엎어놓기를 통해서 이쁜 두상을 유지하도록 해주세요!',
            ),
            SizedBox(height: 56),
            //레벨3
            CureLevelTile(
              title: '레벨 3: 사두증 수치 8-12 OR 단두증 > 90 ',
              subtitle: '행동단계 - 치료: 교정모 치료 고려, 위치 변경 베개 필수',
              img: 'assets/level3.png',
              content:
                  '이 수치에 해당 된다면 이마 비대칭도 육안적으로 보이고 심하면 양 귀 위치의 관계에도 차이가 있습니다. 이는 어릴 때 바르게 잡아주지 않으면 심한 비대칭이 발생하고 더 큰 건강 문제도 초래 할 수 있으므로 예방 및 치료가 필요합니다. 빠른 시일 내에 사두증 전문 병원을 방문하여 검사를 받아 보세요!',
            ),
            SizedBox(height: 56),
            //레벨4
            CureLevelTile(
              title: '레벨 4: 사두증 수치 > 12',
              subtitle: '걱정단계 - 치료: 두상모 교정 치료 필수',
              img: 'assets/level4.png',
              content:
                  '이단계는 귀의 위치뿐만 아니라 정면에서 눈썹 및 눈의 위치도 다르게 보입니다. 이 경우에는 두개의 비대칭이 심하여 추후 턱 관절 문제와 더불어 목 사경까지 이르를 수 있어서 상당한 건강 문제를 초래할 수도 있습니다. 이 단계는 자연적 치료가 어려우니 적극적으로 치료를 해주세요. 어떻게 시작할지 모르실 경우에는 반드시 병원을 방문하거나 전문가에게 도움을 요청해야합니다',
            ),
            SizedBox(height: 56),
            Container(
              height: screenHeight * 0.1,
              decoration: BoxDecoration(color: Color(0xffbF5F5F5)),
              child: Container(
                alignment: Alignment.center,
                child: AutoSizeText(
                  '회사소개 | 이용약관 | 개인정보처리방침\nCOPYRIGHT (C) Innoyard ALL RIGHTS RESERVED',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xffD3D3D3)),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
