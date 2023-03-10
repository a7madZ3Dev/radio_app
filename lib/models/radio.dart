abstract class BaseModel {
  void fromJson(Map<String, dynamic> json);
}

abstract class DBBaseModel {
  Map<String, dynamic> toMap();
}

class RadioAPIModel extends BaseModel {
  List<RadioModel>? data;

  RadioAPIModel({this.data});

  @override
  void fromJson(Map<String, dynamic> json) {
    data = (json['Data'] as List)
        .map<RadioModel>(
          (element) => RadioModel.fromJson(element),
        )
        .toList();
  }
}

class RadioModel extends DBBaseModel {
  static String table = 'radios';

  final int? id;
  final String? radioName;
  final String? radioURL;
  final String? radioDesc;
  final String? radioWebsite;
  final String? radioPic;
  final bool? isBookmarked;

  RadioModel(
      {this.id,
      this.radioName,
      this.radioURL,
      this.radioDesc,
      this.radioWebsite,
      this.radioPic,
      this.isBookmarked});

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      id: json["ID"],
      radioName: json['RadioName'],
      radioURL: json['RadioURL'],
      radioDesc: json['RadioDesc'],
      radioWebsite: json['RadioWebsite'],
      radioPic: json['RadioPic'],
      isBookmarked: false,
    );
  }

  static RadioModel fromMap(Map<String, dynamic> map) {
    return RadioModel(
      id: map["id"],
      radioName: map['radioName'],
      radioURL: map['radioURL'],
      radioDesc: map['radioDesc'],
      radioWebsite: map['radioWebsite'],
      radioPic: map['radioPic'],
      isBookmarked: map['isFavorite'] == 1 ? true : false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'radioName': radioName,
      'radioURL': radioURL,
      'radioDesc': radioDesc,
      'radioWebsite': radioWebsite,
      'radioPic': radioPic
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
