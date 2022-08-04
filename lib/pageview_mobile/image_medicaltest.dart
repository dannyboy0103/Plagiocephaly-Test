import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:mybabyskull/auth/shared_preferences.dart';
import 'package:mybabyskull/pageview_mobile/imagesizer.dart';
import 'package:mybabyskull/pageview_mobile/mobile_test_result.dart';
import 'package:mybabyskull/services/CRUD.dart';
import 'package:mybabyskull/warning.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:toast/toast.dart';
import 'package:word_break_text/word_break_text.dart';
import 'dart:math';
import '../constants.dart';
import '../dialog_widget.dart';
import '../testvalues.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class AnnotationView extends StatefulWidget {
  @override
  _AnnotationViewState createState() => _AnnotationViewState();
}

class _AnnotationViewState extends State<AnnotationView> {
  //Image image;
  ui.Image image;
  ImageSizer imagesizer = new ImageSizer();
  CRUD crudmethods = new CRUD();
  bool isloading = false;
  Uint8List pickedImage;
  final croffsets = <Offset>[];
  final cvaioffsets = <Offset>[];
  int count = 0;
  bool crdone = false;
  bool cvaidone = false;
  double crvalue = 0;
  double cvaivalue = 0;

  double angle = 0;
  int rotation_count = 0;
  double _scale = 1.0;
  double _previousScale = 1.0;
  //int scaleforX;

  Future loadImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);

    setState(() => this.image = image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage('assets/target1.png');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomWarningBox(
              title: "참고 사항",
              descriptions:
                  "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
              text: "확인했습니다",
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size) {
        if (size.deviceScreenType == DeviceScreenType.desktop) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.black.withOpacity(0.8),
              title: Text(
                '두상 검사',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              leading: FlatButton(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: AutoSizeText(
                  '스마트폰으로 사진을 올려서 테스트해보세요!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          );
        } else {
          var screenWidth = MediaQuery.of(context).size.width;
          var screenHeight = MediaQuery.of(context).size.height;
          var min30 = min(screenWidth * (1 / 30), screenHeight * (1 / 30));
          var min20 = min(screenWidth * (1 / 20), screenHeight * (1 / 20));
          var min10 = min(screenWidth * (1 / 10), screenHeight * (1 / 10));
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.black,
              /*title: (cvaidone==false && crdone==false) ? Text(
          '1단계',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ): (crdone==true)?Text(
          '2단계',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ):Text(''),*/
              // leading: FlatButton(
              //   child: Icon(
              //     Icons.home_outlined,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {
              //     //Navigator.pop(context);
              //     Navigator.pushReplacementNamed(context, 'initialView');
              //   },
              // ),
              actions: [
                FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              title: "진단하는 방법",
                              descriptions:
                                  "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                              text: "확인",
                            );
                          });
                    },
                    // child: Padding(
                    //   padding: const EdgeInsets.all(2.0),
                    //   child: Column(
                    //     children: [
                    //       Icon(Icons.info, color: Colors.white),
                    //       AutoSizeText('진단 방법',
                    //           style:
                    //               TextStyle(color: Colors.white, fontSize: 10)),
                    //     ],
                    //   ),
                    // ),
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                    )),
                (pickedImage != null)
                    ? FlatButton(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(4, 4, 5, 4),
                            child: Icon(Icons.add_a_photo_outlined,
                                color: Colors.white)),
                        onPressed: () async {
                          Uint8List bytefrompicker =
                              await ImagePickerWeb.getImage(
                                  outputType: ImageType.bytes);
                          setState(() {
                            pickedImage = bytefrompicker;
                            imagesizer.getImagesize(pickedImage);
                          });
                        },
                      )
                    : Container()
              ],
            ),
            body: (isloading)
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                        ),
                        (pickedImage != null)
                            ? Card(
                                child: Stack(
                                  children: [
                                    Transform(
                                        alignment: FractionalOffset.center,
                                        transform: Matrix4.diagonal3(
                                            Vector3(_scale, _scale, _scale)),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              2 /
                                              3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Transform.rotate(
                                            angle: angle,
                                            child: Image.memory(
                                              pickedImage,
                                              fit: (imagesizer.imgheight * 2 >
                                                      imagesizer.imgwidth *
                                                          3) // 가로 세로 비율을 2/3 기준으로 피팅할 기준 잡음
                                                  ? BoxFit.fitHeight
                                                  : BoxFit.fitWidth,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        )),
                                    GestureDetector(
                                      // onTapDown: (details) {
                                      onTapUp: (details) {
                                        print(details.localPosition);
                                        setState(() {
                                          if (crdone == false) {
                                            if (croffsets.length < 4) {
                                              croffsets
                                                  .add(details.localPosition);
                                            } else {
                                              Toast.show(
                                                "cr 점 네개를 이미 찍었습니다.\n다음 버튼을 눌러주세요.",
                                                context,
                                                duration: 2,
                                                gravity: Toast.BOTTOM,
                                              );
                                            }
                                          } else {
                                            if (cvaioffsets.length < 4) {
                                              cvaioffsets
                                                  .add(details.localPosition);
                                            } else {
                                              Toast.show(
                                                "cvai 점 네개를 이미 찍었습니다.\n결과를 확인해보세요.",
                                                context,
                                                duration: 2,
                                                gravity: Toast.BOTTOM,
                                              );
                                            }
                                          }
                                        });
                                      },
                                      child: Center(
                                        child: CustomPaint(
                                          painter: ImagePainter(
                                            image,
                                            croffsets,
                                            cvaioffsets,
                                            crdone,
                                            MediaQuery.of(context).size.width *
                                                sqrt(3),
                                          ),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                2 /
                                                3,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      //X선이 카드를 넘는거 방지용 위젯
                                      top: MediaQuery.of(context).size.width *
                                              1.2 +
                                          70,
                                      child: Container(),
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // AutoSizeText('검사를 위해 아이 머리 사진을 추가해주세요.',
                                    //     textAlign: TextAlign.center,
                                    //     style: TextStyle(
                                    //         fontSize: min(
                                    //             screenWidth * (1 / 30),
                                    //             screenHeight * (1 / 30)),
                                    //         // color: Colors.blueGrey,
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.bold)),
                                    NeumorphicButton(
                                      margin: const EdgeInsets.all(20.0),
                                      padding: const EdgeInsets.all(50),
                                      style: NeumorphicStyle(
                                        color: Colors.white,
                                        depth: 3,
                                        shape: NeumorphicShape.convex,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(8)),
                                      ),
                                      onPressed: () async {
                                        Uint8List bytefrompicker =
                                            await ImagePickerWeb.getImage(
                                                outputType: ImageType.bytes);
                                        setState(() {
                                          pickedImage = bytefrompicker;
                                          print(pickedImage.length);
                                          imagesizer.getImagesize(pickedImage);
                                        });
                                        print("width" +
                                            imagesizer.imgwidth.toString());
                                        print("height" +
                                            imagesizer.imgheight.toString());
                                      },
                                      child: Icon(Icons.add_a_photo_outlined,
                                          color: Colors.blueAccent,
                                          size: min(screenWidth * (1 / 10),
                                              screenHeight * (1 / 10))),
                                    ),
                                    Neumorphic(
                                      style: NeumorphicStyle(
                                        color:
                                            Colors.blueAccent.withOpacity(0.5),
                                        depth: 3,
                                        shape: NeumorphicShape.convex,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: min20, horizontal: min20),
                                        // child: Text(
                                        child: Text(
                                          '위의 버튼을 눌러\n아이 머리 사진을 추가해주세요.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: min20,
                                              // color: Colors.blueGrey,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        (pickedImage != null)
                            // ? Container(
                            //     color: Colors.blueAccent.withOpacity(0.5),
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(
                            //         vertical: min20,
                            //         horizontal: min20,
                            //         // horizontal: 13,
                            //       ),
                            //       child: Text(
                            //           (crdone == false)
                            //               ? '화면 상 아이의 양쪽 귀, 앞통수, 뒤통수에 점 \n(총 4개의 점)을 찍습니다'
                            //               : 'X자와 머리의 끝부분이 교차하는 지점들에 각각 점 \n(총 4개의 점)을 찍습니다.',
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //               fontSize: min30,
                            //               // color: Colors.blueGrey,
                            //               color: Colors.black,
                            //               fontWeight: FontWeight.bold)),
                            //     ),
                            //   )
                            ? Neumorphic(
                                style: NeumorphicStyle(
                                  color: Colors.blueAccent.withOpacity(0.5),
                                  depth: 3,
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(8)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: min20,
                                    horizontal: min20,
                                    // horizontal: 13,
                                  ),
                                  child: Text(
                                      (crdone == false)
                                          // ? '화면 상 아이의 양쪽 귀의 뒷부분, 앞통수, 코와 직선거리의 뒤통수에 점 \n(총 4개의 점)을 찍습니다'
                                          ? '화면 상 아이의 양쪽 귀, 앞통수, 뒤통수에 점\n(총 4개의 점)을 찍습니다'
                                          : 'X자와 머리의 끝부분이 교차하는 지점들에 각각 점 \n(총 4개의 점)을 찍습니다.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: min30,
                                          // color: Colors.blueGrey,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            : Container(),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                // 점 취소 버튼
                                padding: const EdgeInsets.all(2),
                                child: NeumorphicButton(
                                  style: NeumorphicStyle(
                                    color: Colors.white,
                                    depth: 3,
                                    shape: NeumorphicShape.convex,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(8)),
                                  ),
                                  padding: EdgeInsets.all(5
                                      /*min(screenWidth * (1 / 30),
                                        screenHeight * (1 / 30)),*/
                                      ),
                                  //color: Colors.blueAccent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.navigate_before,
                                        color: Colors.blueAccent,
                                        /*size: min(screenWidth * (1 / 30),
                                            screenHeight * (1 / 30)),*/
                                      ),
                                      SizedBox(width: 2),
                                      AutoSizeText(
                                        '점 취소',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            /*fontSize: min(
                                                screenWidth * (1 / 30),
                                                screenHeight * (1 / 30)),*/
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    if (pickedImage == null) {
                                      Toast.show(
                                        "이미지를 불러오세요.",
                                        context,
                                        duration: 1,
                                        gravity: Toast.BOTTOM,
                                      );
                                    } else {
                                      setState(() {
                                        if (crdone == false) {
                                          if (croffsets.length == 0) {
                                            Toast.show(
                                              "점을 찍어주세요",
                                              context,
                                              duration: 1,
                                              gravity: Toast.BOTTOM,
                                            );
                                          } else {
                                            croffsets.removeLast();
                                          }
                                        } else {
                                          if (cvaioffsets.length == 0) {
                                            Toast.show(
                                              "점을 찍어주세요",
                                              context,
                                              duration: 1,
                                              gravity: Toast.BOTTOM,
                                            );
                                          } else {
                                            cvaioffsets.removeLast();
                                          }
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: NeumorphicButton(
                                    style: NeumorphicStyle(
                                      color: Colors.white,
                                      depth: 3,
                                      shape: NeumorphicShape.convex,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(8)),
                                    ),
                                    padding: EdgeInsets.all(5
                                        /*min(screenWidth * (1 / 30),
                                          screenHeight * (1 / 30)),*/
                                        ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.screen_rotation,
                                          color: Colors.blueAccent,
                                          /*size: min(screenWidth * (1 / 30),
                                              screenHeight * (1 / 30)),*/
                                        ),
                                        SizedBox(width: 2),
                                        AutoSizeText(
                                          ' 돌리기',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // fontSize: min(
                                              //     screenWidth * (1 / 30),
                                              //     screenHeight * (1 / 30)),
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        rotation_count++;
                                        if (rotation_count % 4 == 0) {
                                          angle = 0;
                                        } else if (rotation_count % 4 == 1) {
                                          angle = pi / 2;
                                        } else if (rotation_count % 4 == 2) {
                                          angle = pi;
                                        } else if (rotation_count % 4 == 3) {
                                          angle = 3 * pi / 2;
                                        }
                                      });
                                    },
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: NeumorphicButton(
                                  style: NeumorphicStyle(
                                    color: Colors.white,
                                    depth: 3,
                                    shape: NeumorphicShape.convex,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(8)),
                                  ),
                                  padding: EdgeInsets.all(5
                                      // min(screenWidth * (1 / 30),
                                      //     screenHeight * (1 / 30)),
                                      ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.navigate_next,
                                        color: Colors.blueAccent,
                                        // size: min(screenWidth * (1 / 30),
                                        //     screenHeight * (1 / 30)),
                                      ),
                                      SizedBox(width: 2),
                                      (crdone == false)
                                          ? AutoSizeText(
                                              '다음',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  /*fontSize: min(
                                                      screenWidth * (1 / 30),
                                                      screenHeight *
                                                          (1 / 30)),*/
                                                  color: Colors.black),
                                            )
                                          : AutoSizeText('결과보기',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  /*fontSize: min(
                                                      screenWidth * (1 / 30),
                                                      screenHeight *
                                                          (1 / 30)),*/
                                                  color: Colors.black)),
                                    ],
                                  ),
                                  onPressed: () {
                                    print('crdone');
                                    print(crdone);
                                    print('cvaidone');
                                    print(cvaidone);

                                    if (pickedImage == null) {
                                      Toast.show(
                                        "이미지를 불러오세요.",
                                        context,
                                        duration: 1,
                                        gravity: Toast.BOTTOM,
                                      );
                                    } else {
                                      setState(() {
                                        if (crdone == true &&
                                            cvaidone == false) {
                                          if (cvaioffsets.length < 4) {
                                            Toast.show(
                                              "점이 네개 보다 적습니다.",
                                              context,
                                              duration: 2,
                                              gravity: Toast.BOTTOM,
                                            );
                                          } else {
                                            print('wow');
                                            // setState(() {
                                            //   isloading = true;
                                            // });
                                            cvaidone = true;
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TestResultView(
                                                          crvalue: TestValues
                                                              .crvalue,
                                                          cvaivalue: TestValues
                                                              .cvaivalue,
                                                          myimage: pickedImage,
                                                        )));
                                          }
                                        } else if (crdone == false &&
                                            cvaidone == false) {
                                          if (croffsets.length < 4) {
                                            Toast.show(
                                              "점이 네개 보다 적습니다.",
                                              context,
                                              duration: 2,
                                              gravity: Toast.BOTTOM,
                                            );
                                          } else {
                                            crdone = true;
                                          }
                                        } else if (crdone == true &&
                                            cvaidone == true) {
                                          setState(() {
                                            isloading = true;
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TestResultView(
                                                        crvalue:
                                                            TestValues.crvalue,
                                                        cvaivalue: TestValues
                                                            .cvaivalue,
                                                      )));
                                        } else {
                                          print('?');
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }
      },
    );
  }
}

class ImagePainter extends CustomPainter {
  final List<Offset> croffsets;
  final List<Offset> cvaioffsets;
  final ui.Image image;
  bool crdone;
  double scaleforX;
  var maxX;
  int maxi = 0;
  var minX;
  int mini = 0;
  var maxY;
  int maxyi = 0;
  var minY;
  int minyi = 0;
  ImagePainter(
      this.image, this.croffsets, this.cvaioffsets, this.crdone, this.scaleforX)
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double eWidth = size.width / 25;
    double eHeight = size.height / 25;

    final paint = Paint()
      ..color = Colors.black38
      ..isAntiAlias = true
      ..strokeWidth = 10;

    final paintpoints = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 5;

    final paintpoints2 = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 5;

    final gridlines = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black38
      ..strokeWidth = 1.1;

    // 격자 만들기
    for (int i = 0; i <= 25; ++i) {
      double dy = eHeight * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridlines);
    }

    // 격자 만들기
    for (int i = 0; i <= 25; ++i) {
      double dx = eWidth * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridlines);
    }

    for (var offset in croffsets) {
      canvas.drawPoints(ui.PointMode.points, [offset], paintpoints);
      //canvas.drawImage(image, offset, paintpoints);
      canvas.drawCircle(offset, 12, paintpoints); //첫 네개점
      // Offset newoffset = Offset(offset.dx - 40, offset.dy - 40);
      // canvas.drawCircle(newoffset, 12, paintpoints); //첫 네개점
    }
    if (crdone == true) {
      maxX = croffsets[0].dx;
      for (int i = 1; i < 4; i++) {
        if (croffsets[i].dx > maxX) {
          maxX = croffsets[i].dx;
          maxi = i;
        }
      }

      minX = croffsets[0].dx;
      for (int i = 1; i < 4; i++) {
        if (croffsets[i].dx < minX) {
          minX = croffsets[i].dx;
          mini = i;
        }
      }

      maxY = croffsets[0].dy;
      for (int i = 1; i < 4; i++) {
        if (croffsets[i].dy > maxY) {
          maxY = croffsets[i].dy;
          maxyi = i;
        }
      }

      minY = croffsets[0].dy;
      for (int i = 1; i < 4; i++) {
        if (croffsets[i].dy < minY) {
          minY = croffsets[i].dy;
          minyi = i;
        }
      }

      var slope1 = (croffsets[maxi].dy - croffsets[mini].dy) /
          (croffsets[maxi].dx - croffsets[mini].dx); // slope of horizontal
      var slope2 = (croffsets[maxyi].dy - croffsets[minyi].dy) /
          (croffsets[maxyi].dx - croffsets[minyi].dx);
      var yint1 = croffsets[maxi].dy - slope1 * croffsets[maxi].dx;
      var yint2 = croffsets[maxyi].dy - slope2 * croffsets[maxyi].dx;

      var its_point_x = (yint2 - yint1) / (slope1 - slope2);
      var its_point_y = (slope2 * yint1 - slope1 * yint2) / (slope2 - slope1);
      var xint1 = -1 * yint1 / slope1;
      var xint2 = -1 * yint2 / slope2;

      Offset interpoint = Offset(its_point_x, its_point_y);
      var c = its_point_x - xint2;
      var b = its_point_y;
      var rotation_angle = atan(c / b);

      Offset rightbottom = Offset(
          its_point_x + scaleforX / 2 * cos((pi / 3) - rotation_angle),
          its_point_y + scaleforX / 2 * sin((pi / 3) - rotation_angle));
      Offset leftbottom = Offset(
          its_point_x + scaleforX / 2 * cos((2 * pi / 3) - rotation_angle),
          its_point_y + scaleforX / 2 * sin((2 * pi / 3) - rotation_angle));
      Offset lefttop = Offset(
          its_point_x + scaleforX / 2 * cos((4 * pi / 3) - rotation_angle),
          its_point_y + scaleforX / 2 * sin((4 * pi / 3) - rotation_angle));
      Offset righttop = Offset(
          its_point_x + scaleforX / 2 * cos((5 * pi / 3) - rotation_angle),
          its_point_y + scaleforX / 2 * sin((5 * pi / 3) - rotation_angle));
      canvas.drawLine(interpoint, leftbottom, paint);
      canvas.drawLine(interpoint, rightbottom, paint);
      canvas.drawLine(interpoint, righttop, paint);
      canvas.drawLine(interpoint, lefttop, paint);

      TestValues.crvalue = (croffsets[maxi] - croffsets[mini]).distance /
          (croffsets[maxyi] - croffsets[minyi]).distance *
          100;

      //print('This is CR: ${crvalue}');

      for (var cvaioffset in cvaioffsets) {
        canvas.drawPoints(ui.PointMode.points, [cvaioffset], paintpoints2);
        canvas.drawCircle(cvaioffset, 10, paintpoints2);
        //canvas.drawImage(Image.asset());
      }

      //sorting the cvai offsets max->min
      List<double> sum_of_offsets = [];
      for (int i = 0; i < cvaioffsets.length; i++) {
        sum_of_offsets.add(cvaioffsets[i].dx + cvaioffsets[i].dy);
      }

      if (cvaioffsets.length == 4) {
        double temp;
        Offset temp_offset;
        for (int i = 0; i < 3; i++) {
          for (int j = i + 1; j < 4; j++) {
            if (sum_of_offsets[i] < sum_of_offsets[j]) {
              temp = sum_of_offsets[i];
              sum_of_offsets[i] = sum_of_offsets[j];
              sum_of_offsets[j] = temp;

              temp_offset = cvaioffsets[i];
              cvaioffsets[i] = cvaioffsets[j];
              cvaioffsets[j] = temp_offset;
            }
          }
        }

        double chosen_diagonal;
        if ((cvaioffsets[0] - cvaioffsets[3]).distance >
            (cvaioffsets[1] - cvaioffsets[2]).distance) {
          chosen_diagonal = (cvaioffsets[0] - cvaioffsets[3]).distance;
        } else {
          chosen_diagonal = (cvaioffsets[1] - cvaioffsets[2]).distance;
        }
        TestValues.cvaivalue = ((cvaioffsets[0] - cvaioffsets[3]).distance -
                    (cvaioffsets[1] - cvaioffsets[2]).distance)
                .abs() /
            chosen_diagonal *
            100;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
