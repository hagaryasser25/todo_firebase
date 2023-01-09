class Tasks {
  Tasks({
      String? taskId, 
      String? taskName, 
      int? dt

  }){
    _taskId = taskId;
    _taskName = taskName;
    _dt= dt;

  }

  Tasks.fromJson(dynamic json) {
    _taskId = json['taskId'];
    _taskName = json['taskName'];
    _dt = json['dt'];

  }
  String? _taskId;
  String? _taskName;
  int? _dt;



  String? get taskId => _taskId;
  String? get taskName => _taskName;
  int? get dt => _dt;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskId'] = _taskId;
    map['taskName'] = _taskName;
    map['dt'] = _dt;
   
    return map;
  }

}