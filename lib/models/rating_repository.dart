import 'package:coolmovies/models/movies_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'rating.dart';

class RatingRepository {
  final GraphQLClient client;

  RatingRepository({required this.client});

  Future<List<Rating>> getAllRatings(String movieId) async {
    final QueryOptions options = QueryOptions(
      document: gql(getAllMovieReviewsByMovieId),
      variables: {
        'movieId': movieId,
      },
    );

    final QueryResult result = await client.query(options);
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> ratingsData = result.data?['allMovieReviews']['nodes'] ?? [];
    return ratingsData.map((review) => Rating.fromJson(review)).toList();
  }

  Future<void> createRating(Rating rating) async {
    const storage = FlutterSecureStorage();
    String? movieId = await storage.read(key: 'movieId');
    String? userReviewerId = await storage.read(key: 'userReviewerId');
    print(movieId);
    print(userReviewerId);
    if (movieId == null || userReviewerId == null) {
      throw Exception('movieId o userReviewerId no se pudieron leer desde el almacenamiento seguro.');
    }
    print(userReviewerId);
    print(movieId);
    final MutationOptions options = MutationOptions(
      document: gql('''
        mutation CreateMovieReview(\$title: String!, \$body: String!, \$rating: Int!, \$movieId: UUID!, \$userReviewerId: UUID!) {
          createMovieReview(input: {
            movieReview: {
              title: \$title,
              body: \$body,
              rating: \$rating,
              movieId: \$movieId,
              userReviewerId: \$userReviewerId,
            }
          }) {
            movieReview {
              id
              title
              body
              rating
              movieByMovieId {
                title
              }
              userByUserReviewerId {
                name
              }
            }
          }
        }
      '''),
      variables: {
        'title': rating.title,
        'body': rating.body,
        'rating': rating.rating,
        'movieId': movieId,
        'userReviewerId': userReviewerId,
      },
    );

    final QueryResult result = await client.mutate(options);
    print(result);
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
  }
}
