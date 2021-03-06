import 'dart:async';

import 'package:event/Add_Values.dart';
import 'package:event/Expense.dart';
import 'package:event/Revenue.dart';
import 'package:event/dashboard.dart';
import 'package:event/spalsh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences preferences;

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount _signAccount = await _googleSignIn.signIn().catchError((e){
      print("error $e");
    });
    GoogleSignInAuthentication _gsa = await _signAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _gsa.idToken, accessToken: _gsa.accessToken);
    FirebaseUser _user = await _firebaseAuth
        .signInWithCredential(credential)
        .then((onValue) async {
      // CircularProgressIndicator();
      preferences = await SharedPreferences.getInstance();
      preferences.setString('email', onValue.uid);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Details();
      }));
    }).catchError((err) => print(err));
    // _firebaseAuth.

    return _user;
  }
// Future<bool> pref() async{
//   SharedPreferences preferences = await SharedPreferences.getInstance();
// }
// NoSuchMethodError (NoSuchMethodError: The method 'signout' was called on null. Receiver: null Tried calling: signout()) in flutter

  void signout() async{
    print("object");
    // _firebaseAuth.signOut();
    _googleSignIn.signOut().then((result){
      print("result $result");
    });
    
    // preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: RaisedButton(
              color: Colors.black,
              child: Text(" Click To SignIn",style: TextStyle(fontSize: 40.0,color: Colors.white)),
              onPressed: () {
                _signIn();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  TabController tabcontroller;
  var option = 'REVENUE';
  _SignInState _signin = _SignInState();
  // Future<String> getPreference() async {
  //   SharedPreferences _preferences = await SharedPreferences.getInstance();
  //   String _email = _preferences.getString('email');
  //   return _email;
  // }

  @override
  void initState() {
    super.initState();
    tabcontroller = TabController(length: 3, vsync: this)..addListener((){
      setState(() {
        switch(tabcontroller.index){
          case 0:
            break;
          case 1:
            option = "REVENUE";
            break;
          case 2:
           option = "EXPENDITURE";
           break;
        }
      });
    });
    // var email = getPreference();
  }

  @override
  void dispose() {
    super.dispose();
    tabcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        actions: <Widget>[
          FlatButton(
            child: Text("LOGOUT"),
            onPressed: () {
              _signin.signout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return Splash("Logout");
              }));
              // FirebaseAuth.instance.signOut().then((test){print("jdfklkf");
              // });
            },
          ),
        ],
        bottom: TabBar(
          controller: tabcontroller,
          tabs: <Widget>[
            tabbar('profit/loss'),
            tabbar('revenue'),
            tabbar('expenditure'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        tooltip: 'Add transaction',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddDetails(option);
          }));
        },
      ),
      body: TabBarView(
        controller: tabcontroller,
        children: <Widget>[
          // Newtab('profit or loss'),
          // Newtab('Revenue'),
          // Newtab('Expenditure'),

          //Newtab(),
          Profit(),
          Revenue(),
          Expense(),
          // Newtab('Revenue'),
          // Newtab('Expenditure'),
        ],
      ),
    );
  }

  Widget tabbar(String data) {
    return Tab(
      text: data,
    );
  }
}
