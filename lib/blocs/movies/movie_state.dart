part of 'movie_bloc.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Map<String, dynamic>> movies;

  MovieLoaded({required this.movies});
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}
