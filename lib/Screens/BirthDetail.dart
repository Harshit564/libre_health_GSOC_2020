import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librehealth/Models/note.dart';
import 'package:librehealth/Pages/HomePage.dart';
import 'package:librehealth/Screens/BirthList.dart';
import 'package:librehealth/Utils/DatabaseHelper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _gender = ['Male', 'Female', 'Transgender'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController nameController = TextEditingController();
  TextEditingController bloodgroupController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    nameController.text = note.name;
    bloodgroupController.text = note.bloodgroup;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            centerTitle: true,
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // First element
                ListTile(
                  title: DropdownButton(
                      items: _gender.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getGenderAsString(note.gender),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Name Text Field');
                      updateName();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: bloodgroupController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Blood Group Text Field');
                      updateBloodGroup();
                    },
                    decoration: InputDecoration(
                        labelText: 'Blood Group',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          color: Colors.orange,
                          textColor: Colors.white,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.3,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          color: Colors.orange,
                          textColor: Colors.white,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.3,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Male':
        note.gender = 1;
        break;
      case 'Female':
        note.gender = 2;
        break;
      case 'Transgender':
        note.gender = 3;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getGenderAsString(int value) {
    String gender;
    switch (value) {
      case 1:
        gender = _gender[0]; // 'Male'
        break;
      case 2:
        gender = _gender[1]; // 'Female'
        break;
      case 3:
        gender = _gender[2]; // 'Transgender'
    }
    return gender;
  }

  // Update the title of Note object
  void updateName() {
    note.name = nameController.text;
  }

  // Update the description of Note object
  void updateBloodGroup() {
    note.bloodgroup = bloodgroupController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Credential Generated', '0x54D65C');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Birth Detail');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Birth Detail was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Credential Deleted', 'Birth Entry Deleted Successfully');
    } else {
      _showAlertDialog('Credential Deleted', 'Error Occured while Deleting Birth Detail');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
