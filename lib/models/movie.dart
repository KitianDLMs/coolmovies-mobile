class Movie {
  final String? id;
  final String imgUrl;
  final String movieDirectorId;
  final String userCreatorId;
  final String title;
  final String releaseDate;
  final String? nodeId;
  int? rating;

  Movie({
    this.id,
    required this.imgUrl,
    required this.movieDirectorId,
    required this.userCreatorId,
    required this.title,
    required this.releaseDate,
    this.nodeId,
    this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      imgUrl: json['imgUrl'],
      movieDirectorId: json['movieDirectorId'],
      userCreatorId: json['userCreatorId'],
      title: json['title'],
      releaseDate: json['releaseDate'],
      nodeId: json['nodeId'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'movieDirectorId': movieDirectorId,
      'userCreatorId': userCreatorId,
      'title': title,
      'releaseDate': releaseDate,
      'nodeId': nodeId,
      'rating': rating,
    };
  }
}
