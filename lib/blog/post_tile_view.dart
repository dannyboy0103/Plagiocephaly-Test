import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybabyskull/blog/mobile_post_detail.dart';
import 'package:mybabyskull/constants.dart';

class PostTile extends StatelessWidget {

  String title, author, content, id;
  List<dynamic> imgURL;
  PostTile({@required this.title, @required this.author, @required this.content, @required this.id, this.imgURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      child: GestureDetector(
            onTap: (){
              print(imgURL.toString());
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => PostDetailView(
                  title: title,
                  author: author,
                  content: content,
                  postid: id,
                  imgURL: imgURL,
                )
                ));
            },
            child: Card(
            child: Container(
            decoration: BoxDecoration(
              color: kPinkColor,
            ),
            child: Row(
              children: [
                Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Image(
                      image: AssetImage('parent.png')
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: AutoSizeText(
                        title,
                        wrapWords: true,
                        style: TextStyle(
                          color: kDarkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: AutoSizeText(
                        author
                      ),
                    )
                  ],
                ),
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}