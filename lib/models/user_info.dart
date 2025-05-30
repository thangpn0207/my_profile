/// id : "65a77ddebfa49763f65c05fa"
/// userName : "thangpn0207"
/// name : "Phạm Ngọc Thắng"
/// role : "Flutter developer"
/// avatarURl : ""
/// dob : "2000-07-02T08:00:00Z"
/// exp : "2021-04-01T08:00:00Z"
/// city : "Ha Noi"
/// country : "VIET NAM"
/// university : "GREENWICH UNIVERSITY"
/// universityRank : "First class"
/// coding : [{"percent":0.8,"name":"Flutter"}]
/// skills : [{"percent":0.8,"name":"Team Work"}]
/// knowledge : [{"percent":0,"name":"Flutter, Dart"}]
/// cvURL : ""
/// facebookURL : ""
/// linkinURL : ""
/// mailto : ""

class UserInfo {
  UserInfo({
    String? id,
    String? userName,
    String? name,
    String? role,
    String? avatarURl,
    String? dob,
    String? exp,
    String? city,
    String? country,
    String? university,
    String? universityRank,
    List<Coding>? coding,
    List<Skills>? skills,
    List<Knowledge>? knowledge,
    String? cvURL,
    String? facebookURL,
    String? linkinURL,
    String? githubURL,
    String? mailto,
  }) {
    _id = id;
    _userName = userName;
    _name = name;
    _role = role;
    _avatarURl = avatarURl;
    _dob = dob;
    _exp = exp;
    _city = city;
    _country = country;
    _university = university;
    _universityRank = universityRank;
    _coding = coding;
    _skills = skills;
    _knowledge = knowledge;
    _cvURL = cvURL;
    _facebookURL = facebookURL;
    _linkinURL = linkinURL;
    _mailto = mailto;
  }

  UserInfo.fromJson(dynamic json) {
    _id = json['id'];
    _userName = json['userName'];
    _name = json['name'];
    _role = json['role'];
    _avatarURl = json['avatarURl'];
    _dob = json['dob'];
    _exp = json['exp'];
    _city = json['city'];
    _country = json['country'];
    _university = json['university'];
    _universityRank = json['universityRank'];
    if (json['coding'] != null) {
      _coding = [];
      json['coding'].forEach((v) {
        _coding?.add(Coding.fromJson(v));
      });
    }
    if (json['skills'] != null) {
      _skills = [];
      json['skills'].forEach((v) {
        _skills?.add(Skills.fromJson(v));
      });
    }
    if (json['knowledge'] != null) {
      _knowledge = [];
      json['knowledge'].forEach((v) {
        _knowledge?.add(Knowledge.fromJson(v));
      });
    }
    _cvURL = json['cvURL'];
    _facebookURL = json['facebookURL'];
    _linkinURL = json['linkinURL'];
    _githubURL = json['githubURL'];
    _mailto = json['mailto'];
  }
  String? _id;
  String? _userName;
  String? _name;
  String? _role;
  String? _avatarURl;
  String? _dob;
  String? _exp;
  String? _city;
  String? _country;
  String? _university;
  String? _universityRank;
  List<Coding>? _coding;
  List<Skills>? _skills;
  List<Knowledge>? _knowledge;
  String? _cvURL;
  String? _facebookURL;
  String? _linkinURL;
  String? _githubURL;
  String? _mailto;
  UserInfo copyWith({
    String? id,
    String? userName,
    String? name,
    String? role,
    String? avatarURl,
    String? dob,
    String? exp,
    String? city,
    String? country,
    String? university,
    String? universityRank,
    List<Coding>? coding,
    List<Skills>? skills,
    List<Knowledge>? knowledge,
    String? cvURL,
    String? facebookURL,
    String? linkinURL,
    String? mailto,
    String? githubURL,
  }) =>
      UserInfo(
        id: id ?? _id,
        userName: userName ?? _userName,
        name: name ?? _name,
        role: role ?? _role,
        avatarURl: avatarURl ?? _avatarURl,
        dob: dob ?? _dob,
        exp: exp ?? _exp,
        city: city ?? _city,
        country: country ?? _country,
        university: university ?? _university,
        universityRank: universityRank ?? _universityRank,
        coding: coding ?? _coding,
        skills: skills ?? _skills,
        knowledge: knowledge ?? _knowledge,
        cvURL: cvURL ?? _cvURL,
        facebookURL: facebookURL ?? _facebookURL,
        linkinURL: linkinURL ?? _linkinURL,
        githubURL: githubURL ?? _githubURL,
        mailto: mailto ?? _mailto,
      );
  String? get id => _id;
  String? get userName => _userName;
  String? get name => _name;
  String? get role => _role;
  String? get avatarURl => _avatarURl;
  String? get dob => _dob;
  String? get exp => _exp;
  String? get city => _city;
  String? get country => _country;
  String? get university => _university;
  String? get universityRank => _universityRank;
  List<Coding>? get coding => _coding;
  List<Skills>? get skills => _skills;
  List<Knowledge>? get knowledge => _knowledge;
  String? get cvURL => _cvURL;
  String? get facebookURL => _facebookURL;
  String? get linkinURL => _linkinURL;
  String? get githubURL => _githubURL;
  String? get mailto => _mailto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userName'] = _userName;
    map['name'] = _name;
    map['role'] = _role;
    map['avatarURl'] = _avatarURl;
    map['dob'] = _dob;
    map['exp'] = _exp;
    map['city'] = _city;
    map['country'] = _country;
    map['university'] = _university;
    map['universityRank'] = _universityRank;
    if (_coding != null) {
      map['coding'] = _coding?.map((v) => v.toJson()).toList();
    }
    if (_skills != null) {
      map['skills'] = _skills?.map((v) => v.toJson()).toList();
    }
    if (_knowledge != null) {
      map['knowledge'] = _knowledge?.map((v) => v.toJson()).toList();
    }
    map['cvURL'] = _cvURL;
    map['facebookURL'] = _facebookURL;
    map['linkinURL'] = _linkinURL;
    map['githubURL'] = _githubURL;
    map['mailto'] = _mailto;
    return map;
  }
}

/// percent : 0
/// name : "Flutter, Dart"

class Knowledge {
  Knowledge({
    num? percent,
    String? name,
  }) {
    _percent = percent;
    _name = name;
  }

  Knowledge.fromJson(dynamic json) {
    _percent = json['percent'];
    _name = json['name'];
  }
  num? _percent;
  String? _name;
  Knowledge copyWith({
    num? percent,
    String? name,
  }) =>
      Knowledge(
        percent: percent ?? _percent,
        name: name ?? _name,
      );
  num? get percent => _percent;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percent'] = _percent;
    map['name'] = _name;
    return map;
  }
}

/// percent : 0.8
/// name : "Team Work"

class Skills {
  Skills({
    double? percent,
    String? name,
  }) {
    _percent = percent;
    _name = name;
  }

  Skills.fromJson(dynamic json) {
    _percent = json['percent'];
    _name = json['name'];
  }
  double? _percent;
  String? _name;
  Skills copyWith({
    double? percent,
    String? name,
  }) =>
      Skills(
        percent: percent ?? _percent,
        name: name ?? _name,
      );
  double? get percent => _percent;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percent'] = _percent;
    map['name'] = _name;
    return map;
  }
}

/// percent : 0.8
/// name : "Flutter"

class Coding {
  Coding({
    double? percent,
    String? name,
  }) {
    _percent = percent;
    _name = name;
  }

  Coding.fromJson(dynamic json) {
    _percent = json['percent'];
    _name = json['name'];
  }
  double? _percent;
  String? _name;
  Coding copyWith({
    double? percent,
    String? name,
  }) =>
      Coding(
        percent: percent ?? _percent,
        name: name ?? _name,
      );
  double? get percent => _percent;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percent'] = _percent;
    map['name'] = _name;
    return map;
  }
}
