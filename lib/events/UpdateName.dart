import 'package:librehealth/model/health.dart';

import 'NameEvent.dart';

class UpdateName extends NameEvent {
  Name newName;
  int nameIndex;

  UpdateName(int index, Name name) {
    newName = name;
    nameIndex = index;
  }
}
