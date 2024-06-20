import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:coolmovies/models/movie.dart';
import 'package:coolmovies/models/rating.dart';
import 'package:coolmovies/models/rating_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;
  final _ratingController = StreamController<List<Rating>>();

  Stream<List<Rating>> get ratingsStream => _ratingController.stream;

  RatingBloc({required GraphQLClient client})
      : ratingRepository = RatingRepository(client: client),
        super(RatingInitial()) {
    on<FetchRatings>(_onFetchRatings);
    on<CreateRanking>(_onCreateRating);
  }

  void _onFetchRatings(FetchRatings event, Emitter<RatingState> emit) async {
    emit(RatingLoading());
    try {
      final ratings = await ratingRepository.getAllRatings(event.movieId);
      _ratingController.add(ratings);
      emit(RatingLoaded(ratings));
    } catch (e) {
      emit(RatingError(message: e.toString()));
    }
  }

  void _onCreateRating(CreateRanking event, Emitter<RatingState> emit) async {
    FlutterSecureStorage storage = FlutterSecureStorage();    
    var movieId = await storage.read(key: 'movieId');
    try {
      await ratingRepository.createRating(event.rating);
      emit(RatingLoading());
      final ratings = await ratingRepository.getAllRatings(movieId!);
      _ratingController.add(ratings);
      emit(RatingLoaded(ratings));
    } catch (e) {
      emit(RatingError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _ratingController.close();
    return super.close();
  }
}
