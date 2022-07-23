import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
class Rules extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: AutoSizeText(
          '(주) 이노야드',
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
            Image.asset('assets/member10241024_1.jpg'),
            Image.asset('assets/member10241024_2.jpg'),
            Image.asset('assets/member10241024_3.jpg'),
            Image.asset('assets/member10241024_4.jpg'),
            Image.asset('assets/member10241024_5.jpg'),
            Image.asset('assets/member10241024_6.jpg'),
            Image.asset('assets/member10241024_7.jpg'),
            Image.asset('assets/member10241024_8.jpg'),
            Image.asset('assets/member10241024_9.jpg'),
            Image.asset('assets/member10241024_10.jpg'),
            Image.asset('assets/member10241024_11.jpg'),
            Image.asset('assets/personal_info10241024_1.png'),
            Image.asset('assets/personal_info10241024_2.png'),
            Image.asset('assets/personal_info10241024_3.png'),
            Image.asset('assets/personal_info10241024_4.png'),
            Image.asset('assets/personal_info10241024_5.png'),
            Image.asset('assets/personal_info10241024_6.png'),
            Image.asset('assets/personal_info10241024_7.png'),
            Image.asset('assets/personal_info10241024_8.png'),
            Image.asset('assets/personal_info10241024_9.png'),


          ],
        ),
      ),
    );
  }
}