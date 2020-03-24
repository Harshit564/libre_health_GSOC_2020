
import 'package:librehealth/events/AddName.dart';
import 'package:librehealth/events/DeleteName.dart';
import 'package:librehealth/events/NameEvent.dart';
import 'package:librehealth/events/SetName.dart';
import 'package:librehealth/events/UpdateName.dart';
import 'package:librehealth/model/health.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../NameList.dart';

class NameBloc extends Bloc<NameEvent, List<Name>> {
  @override
  List<Name> get initialState => List<Name>();

  @override
  Stream<List<Name>> mapEventToState(NameEvent event) async* {
    if (event is SetName) {
      yield event.nameList;
    } else if (event is AddName) {
      List<Name> newState = List.from(state);
      if (event.newName != null) {
        newState.add(event.newName);
      }
      yield newState;
    } else if (event is DeleteName) {
      List<Name> newState = List.from(state);
      newState.removeAt(event.nameIndex);
      yield newState;
    } else if (event is UpdateName) {
      List<Name> newState = List.from(state);
      newState[event.nameIndex] = event.newName;
      yield newState;
    }
  }
}