part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class FetchRatings extends RatingEvent {
  final String movieId;

  const FetchRatings({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class CreateRanking extends RatingEvent {
  final Rating rating;
  final BuildContext context;

  const CreateRanking({required this.rating, required this.context});

  @override
  List<Object> get props => [rating, context];
}
