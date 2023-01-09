class Users {
  Users({
    String? uid,
    String? fullName,
    String? email,
    int? id,
  }) {
    _uid = uid;
    _fullName = fullName;
    _email = email;
    _id = id;
  }

  Users.fromJson(dynamic json) {
    _uid = json['uid'];
    _fullName = json['fullNamee'];
    _email = json['email'];
    _id = json['id'];
  }
  String? _uid;
  String? _fullName;
  String? _email;
  int? _id;

  String? get uid => _uid;
  String? get fullName => _fullName;
  String? get email => _email;
  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['fullName'] = _fullName;
    map['email'] = _email;
    map['id'] = _id;

    return map;
  }
}
