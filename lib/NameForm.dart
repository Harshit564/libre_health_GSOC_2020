import 'package:librehealth/bloc/NameBloc.dart';
import 'package:librehealth/db/DatabaseProvider.dart';
import 'package:librehealth/events/AddName.dart';
import 'package:librehealth/events/UpdateName.dart';
import 'package:librehealth/model/health.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameForm extends StatefulWidget {
  final Name name;
  final int nameIndex;

  NameForm({this.name, this.nameIndex});

  @override
  State<StatefulWidget> createState() {
    return NameFormState();
  }
}

class NameFormState extends State<NameForm> {
  String _name;
  String _calories;
  bool _isVegan = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildCalories() {
    return TextFormField(
      initialValue: _calories,
      decoration: InputDecoration(labelText: 'Calories'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 0) {
          return 'Calories must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _calories = value;
      },
    );
  }

  Widget _buildIsVegan() {
    return SwitchListTile(
      title: Text("Vegan?", style: TextStyle(fontSize: 20)),
      value: _isVegan,
      onChanged: (bool newValue) => setState(() {
        _isVegan = newValue;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      _name = widget.name.name;
      _calories = widget.name.calories;
      _isVegan = widget.name.isVegan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Name Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildCalories(),
              SizedBox(height: 16),
              _buildIsVegan(),
              SizedBox(height: 20),
              widget.name == null
                  ? RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  Name name = Name(
                    name: _name,
                    calories: _calories,
                    isVegan: _isVegan,
                  );

                  DatabaseProvider.db.insert(name).then(
                        (storedName) => BlocProvider.of<NameBloc>(context).add(
                      AddName(storedName),
                    ),
                  );

                  Navigator.pop(context);
                },
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        print("form");
                        return;
                      }

                      _formKey.currentState.save();

                      Name name = Name(
                        name: _name,
                        calories: _calories,
                        isVegan: _isVegan,
                      );

                      DatabaseProvider.db.update(widget.name).then(
                            (storedName) => BlocProvider.of<NameBloc>(context).add(
                          UpdateName(widget.nameIndex, name),
                        ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}