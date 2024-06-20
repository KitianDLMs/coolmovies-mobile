import 'dart:io';
import 'package:coolmovies/blocs/movies/movie_bloc.dart';
import 'package:coolmovies/blocs/rating/rating_bloc.dart';
import 'package:coolmovies/screens/all_movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  final HttpLink httpLink = HttpLink(
    Platform.isAndroid ? 'http://192.168.0.107:5001/graphql' : 'http://localhost:5001/graphql',
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  runApp(GraphQLProvider(
    client: client,
    child: const BlocsProviders(),
  ));
}

class BlocsProviders extends StatelessWidget {
  const BlocsProviders({super.key});

  @override
  Widget build(BuildContext context) {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MovieBloc(client: client)),
        BlocProvider(create: (context) => RatingBloc(client: client)),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => AllMoviesScreen(title: 'cool movies',),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      title: 'coolmovies app',          
    );
  }
}