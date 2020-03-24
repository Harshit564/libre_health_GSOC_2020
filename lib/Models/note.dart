class Note {
  int _id;
  String _name;
  String _bloodgroup;
  String _date;
  int _gender;

  Note(this._name, this._date, this._gender, [this._bloodgroup]);

  Note.withId(this._id, this._name, this._date, this._gender,
      [this._bloodgroup]);

  int get id => _id;

  String get name => _name;

  String get bloodgroup => _bloodgroup;

  int get gender => _gender;

  String get date => _date;

  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set bloodgroup(String newBloodGroup) {
    if (newBloodGroup.length <= 255) {
      this._bloodgroup = newBloodGroup;
    }
  }

  set gender(int newGender) {
    if (newGender >= 1 && newGender <= 2) {
      this._gender = newGender;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['bloodgroup'] = _bloodgroup;
    map['gender'] = _gender;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._bloodgroup = map['bloodgroup'];
    this._gender = map['gender'];
    this._date = map['date'];
  }
}
