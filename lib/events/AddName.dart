import 'package:librehealth/model/health.dart';

import 'NameEvent.dart';

class AddName extends NameEvent {
  Name newName;

  AddName(Name name) {
    newName = name;
  }
}