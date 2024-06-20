part of 'rating_bloc.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingLoaded extends RatingState {
  final List<Rating> ratings;

  const RatingLoaded(this.ratings);

  @override
  List<Object> get props => [ratings];
}

class RatingError extends RatingState {
  final String message;

  const RatingError({required this.message});

  @override
  List<Object> get props => [message];
}
