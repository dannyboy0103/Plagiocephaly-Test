import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyGridContainer extends StatefulWidget {
  final List<String> tapList = [];
  final List<String> positions;
  final List<bool> buttonPressedList;

  MyGridContainer({
    this.positions,
    this.buttonPressedList,
  });

  @override
  _MyGridContainerState createState() => _MyGridContainerState();
}

class _MyGridContainerState extends State<MyGridContainer> {
  @override
  Widget build(BuildContext context) {
    var tapList = widget.tapList;
    var positions = widget.positions;
    var buttonsPressedList = widget.buttonPressedList;
    int mode = buttonsPressedList.indexOf(true);
    List<List<Widget>> flatButtonListList = [];
    for (int i = 0; i < 400; i++) {
      tapList.add('0');
    }

    for (int i = 0; i < 20; i++) {
      List<Widget> internalList = [];
      for (int j = 0; j < 20; j++) {
        internalList.add(GestureDetector(
          onTap: () {
            print(buttonsPressedList);
            print(mode);
            if (tapList[i * 20 + j] == '0' || tapList[i * 20 + j] == '') {
              setState(() {
                tapList[i * 20 + j] = '$mode';
                positions[mode] = '$i,$j';
              });
            } else {
              setState(() {
                tapList[i * 20 + j] = '0';
                positions[mode] = '0';
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 20,
            height: MediaQuery.of(context).size.width / 20,
            child: Text(
              '$i,$j',
              style: TextStyle(
                color: Colors.transparent,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 0.2),
              color: ('$i,$j' == positions[0])
                  ? Colors.red
                  : ('$i,$j' == positions[1])
                      ? Colors.green
                      : ('$i,$j' == positions[2]
                          ? Colors.blue
                          : ('$i,$j' == positions[3])
                              ? Colors.yellow
                              : ('$i,$j' == positions[4])
                                  ? Colors.purple
                                  : ('$i,$j' == positions[5])
                                      ? Colors.pink
                                      : ('$i,$j' == positions[6])
                                          ? Colors.orange
                                          : ('$i,$j' == positions[7])
                                              ? Colors.amber
                                              : Colors.transparent),
            ),
          ),
        ));
      }
      flatButtonListList.add(internalList);
    }
    return Container(
      child: Column(
        children: [
          for (var internalList in flatButtonListList)
            Row(
              children: internalList,
            )
        ],
      ),
    );
  }
}
