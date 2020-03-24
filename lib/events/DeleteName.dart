import 'NameEvent.dart';

class DeleteName extends NameEvent {
  int nameIndex;

  DeleteName(int index) {
    nameIndex = index;
  }
}