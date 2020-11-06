import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MainLandingPage extends StatefulWidget {
  @override
  _MainLandingPageState createState() => _MainLandingPageState();
}

class _MainLandingPageState extends State<MainLandingPage> {
  List<Color> colours = [
    Color(0xFFffc452),
    Color(0xFFFB5A50),
    Color(0xFF26E29E),
    Color(0xFF7773FB),
  ];

  String title = '';
  String body = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Verses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final downloadedVerses = snapshot.data.documents;
        List<VersesHolder> allVerses = [];
        for (DocumentSnapshot verse in downloadedVerses) {
          final title = verse.data['Title'];
          final body = verse.data['Body'];
          final posted = verse.data['Posted'].replaceAll(",", "");
          final sorting = verse.data['Sorting'];
          final tempHolder = VersesHolder(
              sorting: sorting, posted: posted, body: body, title: title);
          allVerses.add(tempHolder);
        }

        allVerses.sort((b, a) => a.sorting.compareTo(b.sorting));

        void createNewDevotion() async {
          await Firestore.instance.collection('Verses').document().setData({
            'Title': title,
            'Body': body,
            'Sorting': DateTime.now().toString(),
            'Posted': DateFormat.yMMMd().format(DateTime.now()).toString()
          });
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  context: context,
                  builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50,
                                right: 35,
                                left: 35,
                                top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 8)
                                      ],
                                      color: colours[0],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'New Devotion',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
                                      ),
                                      Spacer(),
                                      FaIcon(
                                        FontAwesomeIcons.prayingHands,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Title',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                        child: TextField(
                                      onChanged: (String newValue) {
                                        title = newValue;
                                      },
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Input title'),
                                    ))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Body',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                        child: TextField(
                                      onChanged: (String newValue) {
                                        body = newValue;
                                      },
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Input Body'),
                                    )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Spacer(),
                                    RaisedButton(
                                      padding: EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: colours[2],
                                      onPressed: () {
                                        createNewDevotion();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Add',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.plus,
                  size: 13,
                ),
                Text(
                  'Verse',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            backgroundColor: colours[3],
          ),
          backgroundColor: Color(0xFFF5EAE1),
          body: Padding(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10)
                      ]),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        child: FaIcon(
                          FontAwesomeIcons.solidHeart,
                          size: 20,
                        ),
                        backgroundColor: colours[1],
                        foregroundColor: Colors.white,
                        radius: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'My Weekly Devotion\nwith Mum',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => ReusableContainer(
                              string: allVerses[index].body,
                              month: allVerses[index].posted.substring(3, 6),
                              colour: colours[index % colours.length],
                              date: allVerses[index].posted.substring(0, 3),
                              title: allVerses[index].title,
                            ),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: allVerses.length))
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReusableContainer extends StatelessWidget {
  final Color colour;
  final String month;
  final String date;
  final String string;
  final String title;
  ReusableContainer(
      {this.string, this.colour, this.title, this.date, this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
          ]),
      padding: EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 10)
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            padding: EdgeInsets.all(10),
            height: 50,
            width: 70,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      month,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                  ],
                ),
                Positioned(
                  top: 18,
                  left: -10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: colour,
                    ),
                    height: 30,
                    width: 70,
                    padding: EdgeInsets.all(0),
                    child: Center(
                        child: Text(
                      date,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(string),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VersesHolder {
  String title;
  String body;
  String posted;
  String sorting;
  VersesHolder({this.title, this.body, this.posted, this.sorting});
}
