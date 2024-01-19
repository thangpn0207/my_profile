/// id : "65a79374c18cb7ac40a64f8a"
/// userName : "thangpn0207"
/// infoType : "Additional Information"
/// details : ["I am a sociable person, able to communicate well.","I have an interest in technology, especially new technologies.","I am not afraid of difficulties, always try to find ways to solve difficult problems.","I always wanted to improve myself.","I was studious, easy to acquire new knowledge."]

class MoreInfo {
  MoreInfo({
    String? id,
    String? userName,
    String? infoType,
    List<String>? details,
  }) {
    _id = id;
    _userName = userName;
    _infoType = infoType;
    _details = details;
  }

  MoreInfo.fromJson(dynamic json) {
    _id = json['id'];
    _userName = json['userName'];
    _infoType = json['infoType'];
    _details = json['details'] != null ? json['details'].cast<String>() : [];
  }
  String? _id;
  String? _userName;
  String? _infoType;
  List<String>? _details;
  MoreInfo copyWith({
    String? id,
    String? userName,
    String? infoType,
    List<String>? details,
  }) =>
      MoreInfo(
        id: id ?? _id,
        userName: userName ?? _userName,
        infoType: infoType ?? _infoType,
        details: details ?? _details,
      );
  String? get id => _id;
  String? get userName => _userName;
  String? get infoType => _infoType;
  List<String>? get details => _details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userName'] = _userName;
    map['infoType'] = _infoType;
    map['details'] = _details;
    return map;
  }

  static List<MoreInfo> listFromJson(dynamic list) {
    if (list is! List<dynamic>) return [];

    if (list.isEmpty) return [];

    return list.map((e) {
      return MoreInfo.fromJson(e);
    }).toList();
  }
}
