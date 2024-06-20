import 'package:coolmovies/screens/all_movies_screen.dart';
import 'package:coolmovies/screens/create_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:coolmovies/blocs/rating/rating_bloc.dart';
import 'package:coolmovies/models/rating.dart';

class MovieDetailScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    final String movieId = widget.movie['id'];
    context.read<RatingBloc>().add(FetchRatings(movieId: movieId));
  }

  void _reloadPage() {
    final String movieId = widget.movie['id'];
    context.read<RatingBloc>().add(FetchRatings(movieId: movieId));
  }

  void _navigateToAddReview() async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'movieId', value: widget.movie['id']);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreateMovieReviewScreen(movie: widget.movie),
    )).then((newRating) {
      if (newRating != null) {
        _reloadPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratingBloc = context.read<RatingBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.movie['title']}'),
      ),
      body: Center(
        child: StreamBuilder<List<Rating>>(
          stream: ratingBloc.ratingsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No Ratings');
            } else {
              final ratings = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.movie['imgUrl'] != null)
                      Image.network(
                        widget.movie['imgUrl'],
                        fit: BoxFit.cover,
                        height: 200,
                        width: 100,
                      ),
                    const SizedBox(height: 30),
                    Text('Title: ${widget.movie['title'] ?? ""}'),
                    Text('Director ID: ${widget.movie['movieDirectorId'] ?? ""}'),
                    Text('ReleaseDate: ${widget.movie['releaseDate'] ?? ""}'),
                    const SizedBox(height: 20),
                    const Text(
                      'Ratings',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: ratings.length,
                        itemBuilder: (context, index) {
                          final rating = ratings[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < rating.rating
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      rating.title,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rating.body,
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Add Review',
            onTap: _navigateToAddReview,
          ),
          SpeedDialChild(
            child: Icon(Icons.arrow_back),
            label: 'Go Home',
            onTap: () async {
              const storage = FlutterSecureStorage();
              await storage.delete(key: 'movieId');

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AllMoviesScreen(title: 'cool movies')));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.refresh),
            label: 'Reload',
            onTap: _reloadPage,
          ),
        ],
      ),
    );
  }
}
