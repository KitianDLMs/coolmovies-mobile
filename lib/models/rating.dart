class Rating {
  final String title;
  final String body;
  final int rating;
  final String movieTitle;  

  Rating({
    required this.title,
    required this.body,
    required this.rating,
    required this.movieTitle, 
    String? userReviewerId, 
    required movieId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {    
    return Rating(
      title: json['title'],
      body: json['body'],
      rating: json['rating'],
      movieTitle: json['movieByMovieId']['title'], 
      userReviewerId: '', 
      movieId: null,
    );
  }
}