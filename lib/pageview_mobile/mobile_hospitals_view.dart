import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:mybabyskull/map/google_map.dart';
import 'package:mybabyskull/services/CRUD.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class HospitalView extends StatefulWidget {
  @override
  _HospitalViewState createState() => _HospitalViewState();
}

class _HospitalViewState extends State<HospitalView> {

  List<String> places = ['경기','서울','인천','강원','충북','부산','충남','울산','광주','전남','경북','경남','전북','대전','대구','제주','',];
  QuerySnapshot hospitals;
  CRUD crudmethods = new CRUD();

  gethospitalstream() async {
    await crudmethods.getHospitals().then((result){
      setState((){
        hospitals = result;
      });
    });
  }

  
  @override
  void initState() {
    // TODO: implement initState
    gethospitalstream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text(
          '치료 지원 병원',
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: HospitalSearchDelegate(),
                  
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                '치료 지원 병원 리스트',
                minFontSize: 15,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(2),
              //padding: EdgeInsets.symmetric(horizontal:15),
              child: (hospitals != null) ? ListView.builder(
                padding: EdgeInsets.all(2),
                physics: NeverScrollableScrollPhysics(),//to make singlescrollchild scrollable
                reverse: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: true, 
                itemCount: hospitals.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: AutoSizeText(
                        hospitals.docs[index].get('location'),
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      title: AutoSizeText(
                        hospitals.docs[index].get('hospital_name'),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      subtitle: AutoSizeText(
                        hospitals.docs[index].get('address'),
                        style: TextStyle(
                          color: Colors.blueGrey
                        ),
                        ),
                      trailing: Icon(
                        Icons.location_pin,
                        color: Colors.blueAccent
                        ),
                      onTap: () async {
                        var url = hospitals.docs[index].get('URL');
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  );
                },
              ):Center(child: CircularProgressIndicator())
                  
                
              
            ),
          ],
        ),
      )
     
    );
  }
}


class HospitalSearchDelegate extends SearchDelegate<String> {
  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "지역 이름 검색";

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 30),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Hospitals').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return new Text('검색해주세요');
        }
        final results = snapshot.data.docs.where((DocumentSnapshot a) => a['location'].toString().contains(query)); 
        
        return ListView(
          children: results.map<Widget>((DocumentSnapshot a) => 
            Card(
              child: ListTile(
                  leading: AutoSizeText(
                        a.get('location'),
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                  title: AutoSizeText(
                    a.get('hospital_name'),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  subtitle: AutoSizeText(
                    a.get('address'),
                    style: TextStyle(
                      color: Colors.blueGrey
                    ),
                    ),
                  trailing: Icon(
                        Icons.location_pin,
                        color: Colors.blueAccent
                        ),  
                  onTap: () async {
                    var url = a.get('URL');
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                  },
                ),
            )
            ).toList()
          );
      },
    );
  }
}