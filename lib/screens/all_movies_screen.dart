import 'package:coolmovies/screens/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coolmovies/blocs/movies/movie_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class AllMoviesScreen extends StatefulWidget {

  final String title;
  const AllMoviesScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends State<AllMoviesScreen> {

  @override
  void initState() {
    setState(() {});
    context.read<MovieBloc>().add(ListMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cool movies'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 36.0),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {                    
                    const storage = FlutterSecureStorage();
                    var id = await storage.read(key: 'movieId');
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('List Movies'),
                ),
                const SizedBox(height: 16),
                _buildMoviesList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesList(BuildContext context) {
    return context.select((MovieBloc bloc) {
      final state = bloc.state;
      if (state is MovieLoading) {
        return const CircularProgressIndicator();
      } else if (state is MovieLoaded) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.movies.length,
          itemBuilder: (context, index) {
            final movie = state.movies[index];
            return ListTile(
              onTap: () async {
                // print(movie['id']);
                const storage = FlutterSecureStorage();
                await storage.write(key: 'movieId', value: movie['id']); 
                await storage.write(key: 'movie', value: '$movie'); 
              
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)));
              },
              leading: movie['imgUrl'] != null
                  ? Image.network(movie['imgUrl'])
                  : const Icon(Icons.movie),
              title: Text(movie['title']),
              subtitle: Text('Director ID: ${movie['movieDirectorId']}'),
            );
          },
        );
      } else if (state is MovieError) {
        return Text('Error: ${state.message}');
      } else {
        return Container();
      }
    });
  }
}
