import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mybabyskull/constants.dart';

class CureLevelTile extends StatelessWidget {
  String title, subtitle, img, content;
  CureLevelTile({
    this.title, 
    this.subtitle, 
    this.img,
    this.content});

  @override
  Widget build(BuildContext context) {
      var screenWidth = MediaQuery.of(context).size.width;
      var screenHeight = MediaQuery.of(context).size.height;
      return Container(
                height: screenHeight-56,
                width: screenWidth,
                child: Column(
                  children: [
                    Container(//title
                      height: (screenHeight-56)*0.1,
                      width: screenWidth - 40,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center
                        ),
                      ),
                    ),
                    Container(
                      height: (screenHeight-56)*0.45,
                      width: (screenHeight-56)*0.45,
                      child: Image.asset(img, fit: BoxFit.fill),
                    
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: (screenHeight-56)*0.1,
                            child: AutoSizeText(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            ),
                          ),
                          Container(
                            height: (screenHeight-56)*0.25,
                            padding: EdgeInsets.symmetric(horizontal:20),
                            child: AutoSizeText(
                              content,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],                  
                ),
              );
  }
}