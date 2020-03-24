import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:librehealth/Models/note.dart';
import 'package:librehealth/Pages/LoginPage.dart';
import 'package:librehealth/Screens/BirthDetail.dart';
import 'package:librehealth/Screens/BirthList.dart';
import 'package:librehealth/Utils/DatabaseHelper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Home Page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => _onAlertButtonsPressed(context),
              tooltip: "Log Out",
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Image.asset('images/lh.png'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 100.0, right: 100.0),
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 100.0, right: 100.0),
                child: RaisedButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    child: Text(
                      'View Data',
                      textScaleFactor: 1.3,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoteList()),
                      );
                    }),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.only(left: 100.0, right: 100.0),
                child: RaisedButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    child: Text(
                      'New Data',
                      textScaleFactor: 1.3,
                    ),
                    onPressed: () {
                      navigateToDetail(Note('', '', 2), 'Add Birth Detail');
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onAlertButtonsPressed(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.black,
        titleStyle: TextStyle(color: Colors.white),
        descStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      type: AlertType.warning,
      title: "LOG OUT",
      desc: "Do you want to log out your ID ?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color(0xFF20BF55),
            Color(0xFF01BAEF),
          ]),
        ),
        DialogButton(
          child: Text(
            "Log Out",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
