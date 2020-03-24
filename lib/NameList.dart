import 'package:librehealth/db/DatabaseProvider.dart';
import 'package:librehealth/events/DeleteName.dart';
import 'package:librehealth/events/SetName.dart';
import 'package:librehealth/NameForm.dart';
import 'package:librehealth/model/health.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/NameBloc.dart';

class NameList extends StatefulWidget {
  const NameList({Key key}) : super(key: key);

  @override
  _NameListState createState() => _NameListState();
}

class _NameListState extends State<NameList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getNames().then(
          (nameList) {
            //context.bloc<NameBloc>().add(SetName(nameList));
             BlocProvider.of<NameBloc>(context).add(SetName(nameList));
      },
    );
  }

  showNameDialog(BuildContext context, Name name, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name.name),
        content: Text("ID ${name.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NameForm(name: name, nameIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(name.id).then((_) {
              //context.bloc<NameBloc>().add(DeleteName(index));
              BlocProvider.of<NameBloc>(context).add(
                DeleteName(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire name list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("NameList")),
      body: Container(
        child: BlocConsumer<NameBloc, List<Name>>(
          builder: (context, nameList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("nameList: $nameList");

                Name name = nameList[index];
                return ListTile(
                    title: Text(name.name, style: TextStyle(fontSize: 30)),
                    subtitle: Text(
                      "Calories: ${name.calories}\nVegan: ${name.isVegan}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showNameDialog(context, name, index));
              },
              itemCount: nameList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, nameList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => NameForm()),
        ),
      ),
    );
  }
}