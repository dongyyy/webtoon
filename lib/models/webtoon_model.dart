class WebtoonModel {
  final String title, thumb, id;

  // WebtoonModel({
  //   required this.title,
  //   required this.thumb,
  //   required this.id,
  // });

  //named constructure
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
