/// id : "65a79c30937828ea5b93d8e6"
/// userName : "thangpn0207"
/// name : "ICHECK TRACE PROJECT"
/// company : "ICHECK"
/// role : "Mobile Developer"
/// techUsed : ["Flutter"]
/// dependencies : ["BLOC","DIO"]
/// tasks : ["Authentication","User infomation"]
/// startTime : "April/2021"
/// endTime : "June/2021"

class MyProject {
  MyProject({
    String? id,
    String? userName,
    String? name,
    String? company,
    String? role,
    List<String>? techUsed,
    List<String>? dependencies,
    List<String>? tasks,
    String? startTime,
    String? endTime,
  }) {
    _id = id;
    _userName = userName;
    _name = name;
    _company = company;
    _role = role;
    _techUsed = techUsed;
    _dependencies = dependencies;
    _tasks = tasks;
    _startTime = startTime;
    _endTime = endTime;
  }

  MyProject.fromJson(dynamic json) {
    _id = json['id'];
    _userName = json['userName'];
    _name = json['name'];
    _company = json['company'];
    _role = json['role'];
    _techUsed = json['techUsed'] != null ? json['techUsed'].cast<String>() : [];
    _dependencies =
        json['dependencies'] != null ? json['dependencies'].cast<String>() : [];
    _tasks = json['tasks'] != null ? json['tasks'].cast<String>() : [];
    _startTime = json['startTime'];
    _endTime = json['endTime'];
  }
  String? _id;
  String? _userName;
  String? _name;
  String? _company;
  String? _role;
  List<String>? _techUsed;
  List<String>? _dependencies;
  List<String>? _tasks;
  String? _startTime;
  String? _endTime;
  MyProject copyWith({
    String? id,
    String? userName,
    String? name,
    String? company,
    String? role,
    List<String>? techUsed,
    List<String>? dependencies,
    List<String>? tasks,
    String? startTime,
    String? endTime,
  }) =>
      MyProject(
        id: id ?? _id,
        userName: userName ?? _userName,
        name: name ?? _name,
        company: company ?? _company,
        role: role ?? _role,
        techUsed: techUsed ?? _techUsed,
        dependencies: dependencies ?? _dependencies,
        tasks: tasks ?? _tasks,
        startTime: startTime ?? _startTime,
        endTime: endTime ?? _endTime,
      );
  String? get id => _id;
  String? get userName => _userName;
  String? get name => _name;
  String? get company => _company;
  String? get role => _role;
  List<String>? get techUsed => _techUsed;
  List<String>? get dependencies => _dependencies;
  List<String>? get tasks => _tasks;
  String? get startTime => _startTime;
  String? get endTime => _endTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userName'] = _userName;
    map['name'] = _name;
    map['company'] = _company;
    map['role'] = _role;
    map['techUsed'] = _techUsed;
    map['dependencies'] = _dependencies;
    map['tasks'] = _tasks;
    map['startTime'] = _startTime;
    map['endTime'] = _endTime;
    return map;
  }

  static List<MyProject> listFromJson(dynamic list) {
    if (list is! List<dynamic>) return [];

    if (list.isEmpty) return [];

    return list.map((e) {
      return MyProject.fromJson(e);
    }).toList();
  }
}
