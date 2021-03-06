import 'dart:async';

import 'package:flutter/material.dart';
import 'services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Revenue extends StatefulWidget {
  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  QuerySnapshot revenue;
  CrudServices services = CrudServices();
  @override
  void initState() {
    super.initState();
    getRevenue();
  }

  Future getRevenue() async {
    await services.getData('Revenue').then((result) {
      if(this.mounted){
        setState(() {
        print(result);
        revenue = result;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 18;
    return Container(
        margin: EdgeInsets.only(top: 20.0,left: 20.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(fontSize: width, fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(

              // ),
              Expanded(
                child: Text(
                  'Date',
                  style: TextStyle(fontSize: width, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  'Amount',
                  style: TextStyle(fontSize: width, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  'Desc',
                  style: TextStyle(fontSize: width, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
              flex: 1,
              child: Container(
                child: _data(),
              )),
        ]));
  }

  Widget _data() {
    if (revenue != null) {
      return ListView.builder(
          itemCount: revenue.documents.length,
          itemBuilder: (BuildContext context, int item) {
            return Card(
              margin: EdgeInsets.only(top: 12.0, bottom: 2.0),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  //   return
                  // }));
                },
                onLongPress: () {
                  services.delete('Revenue',revenue.documents[item].documentID,revenue.documents[item].data['date'],revenue.documents[item].data['amount']);
                  AlertDialog alertDialog =AlertDialog(
                    actions: <Widget>[
                      Text('Item Deleted'),
                      FlatButton(
                        child: Text('OK'),
                        onPressed: (){
                          getRevenue();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                  showDialog(
                    barrierDismissible: false,
                    context: context,builder: (context) => alertDialog);
                },
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        revenue.documents[item].data['name'],
                        style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width / 23),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        revenue.documents[item].data['date'].toString(),
                        style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width / 23),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Text(
                        revenue.documents[item].data['amount'],
                        style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width / 23),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Icon(Icons.description),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                      revenue
                                          .documents[item].data['description'],
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width / 23)),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      return Center(
          child: Text("please wait.....", style: TextStyle(fontSize: MediaQuery.of(context).size.width / 18)));
    }
  }
}
