import 'package:bloc/bloc.dart';
import 'package:coolmovies/models/movies_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GraphQLClient client;

  MovieBloc({required this.client}) : super(MovieInitial()) {
    on<ListMovies>(_onListMovies);
  }

  Future<void> _onListMovies(ListMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(getAllMoviesQuery),
        ),
      );

      if (result.hasException) {
        emit(MovieError(result.exception.toString()));
        return;
      }

      final movies = (result.data!['allMovies']['nodes'] as List).map((e) => e as Map<String, dynamic>).toList();
      emit(MovieLoaded(movies: movies));      
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}
