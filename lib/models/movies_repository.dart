
const String getAllMoviesQuery = r'''
  query AllMovies {
    allMovies {
      nodes {
        id
        imgUrl
        movieDirectorId
        userCreatorId
        title
        releaseDate
        nodeId
        userByUserCreatorId {
          id
          name
          nodeId
        }
      }
    }
  }
''';

const String getAllMovieReviewsByMovieId = r'''
  query AllMovieReviewsByMovieId($movieId: UUID!) {
    allMovieReviews(
      filter: {movieId: {equalTo: $movieId}}
    ) {
      nodes {
        title
        body
        rating
        movieByMovieId {
          title
        }
      }
    }
  }
''';




const String createMovieMutation = r'''
  mutation CreateMovie($input: CreateMovieInput!) {
    createMovie(input: $input) {
      movie {
        id
        imgUrl
        movieDirectorId
        userCreatorId
        title
        releaseDate
        nodeId
      }
    }
  }
''';
