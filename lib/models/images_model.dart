class Images {
  Images({
      String? imageUrl, 
      String? imageName, 
      

  }){
    _imageUrl = imageUrl;
    _imageName = imageName;
   

  }

  Images.fromJson(dynamic json) {
    _imageUrl = json['imageUrl'];
    _imageName = json['imageName'];

  }
  String? _imageUrl;
  String? _imageName;



  String? get imageUrl => _imageUrl;
  String? get imageName => _imageName;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageUrl'] = _imageUrl;
    map['imageName'] = _imageName;
   
    return map;
  }

}