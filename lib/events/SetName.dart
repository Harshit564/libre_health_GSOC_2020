import 'package:librehealth/model/health.dart';

import 'NameEvent.dart';

class SetName extends NameEvent {
  List<Name> nameList;

  SetName(List<Name> names) {
    nameList = names;
  }
}