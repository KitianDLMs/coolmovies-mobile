import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coolmovies/blocs/rating/rating_bloc.dart';
import 'package:coolmovies/models/rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateMovieReviewScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  const CreateMovieReviewScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _CreateMovieReviewScreenState createState() => _CreateMovieReviewScreenState();
}

class _CreateMovieReviewScreenState extends State<CreateMovieReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  double _rating = 0.0;
  late String _userReviewerId;
  late String movieId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userReviewerId = widget.movie['userByUserCreatorId']['id'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    movieId = widget.movie['id'];
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newRating = Rating(
        movieId: movieId,
        rating: _rating.toInt(),
        title: _titleController.text,
        body: _bodyController.text,
        userReviewerId: _userReviewerId,
        movieTitle: 'new Review Movie',
      );

      context.read<RatingBloc>().add(CreateRanking(rating: newRating, context: context));
      Navigator.of(context).pop(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Review for ${widget.movie['title']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Review'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a review';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Text('Rating', style: TextStyle(fontSize: 16)),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
