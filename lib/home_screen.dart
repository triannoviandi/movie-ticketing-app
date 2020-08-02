import 'package:flutter/material.dart';
import 'package:movieticketingapp/app_util.dart';
import 'package:movieticketingapp/detail_screen.dart';
import 'package:movieticketingapp/movie_data.dart';
import 'package:movieticketingapp/videoclipper.dart';
import 'package:movieticketingapp/videoclipper2.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var movieData = MovieData();
  Size get size => MediaQuery.of(context).size;
  double get movieItemWidth => size.width / 2 + 48;
  ScrollController movieScrollController = ScrollController();
  ScrollController backgroundScrollController = ScrollController();
  double maxMovieTranslate = 65;
  int movieIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    movieScrollController.addListener(() {
      backgroundScrollController
          .jumpTo(movieScrollController.offset * (size.width / movieItemWidth));
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          backgroundListView(),
          movieListView(),
          buyButton(context)
        ],
      ),
    );
  }

  Widget backgroundListView() {
    return ListView.builder(
        controller: backgroundScrollController,
        padding: EdgeInsets.zero,
        reverse: true,
        itemCount: movieData.movieList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return Container(
            width: size.width,
            height: size.height,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned(
                  left: -size.width / 3,
                  right: -size.width / 3,
                  child: Image(
                    image: movieData.movieList[index].image.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.grey.withOpacity(.6),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(.9),
                          Colors.black.withOpacity(.3),
                          Colors.black.withOpacity(.95)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.5, 0.9]),
                  ),
                ),
                Container(
                  height: size.height * .25,
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image(
                      width: size.width / 1.8,
                      image: movieData.movieList[index].imageText.image,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget movieListView() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 700),
      tween: Tween<double>(begin: 600, end: 0),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: Container(
        height: size.height * .75,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: ScrollSnapList(
              listController: movieScrollController,
              onItemFocus: (item) {
                movieIndex = item;
              },
              itemSize: movieItemWidth,
              padding: EdgeInsets.zero,
              itemCount: movieData.movieList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return movieItem(index);
              }),
        ),
      ),
    );
  }

  Widget movieItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: movieScrollController,
            builder: (ctx, child) {
              double activeOffset = index * movieItemWidth;

              double translate =
                  movieTranslate(movieScrollController.offset, activeOffset);

              return SizedBox(
                height: translate,
              );
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: movieData.movieList[index].image.image,
              width: size.width / 2,
            ),
          ),
          SizedBox(
            height: size.height * .02,
          ),
          AnimatedBuilder(
            animation: movieScrollController,
            builder: (context, child) {
              double activeOffset = index * movieItemWidth;
              double opacity = movieDescriptionOpacity(
                  movieScrollController.offset, activeOffset);

              return Opacity(
                opacity: opacity / 100,
                child: Column(
                  children: <Widget>[
                    Text(
                      movieData.movieList[index].name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width / 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    genresFormat(movieData.movieList[index].genre),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Text(
                      movieData.movieList[index].rating.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 16,
                      ),
                    ),
                    SizedBox(
                      height: size.height * .005,
                    ),
                    starRating(movieData.movieList[index].rating)
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buyButton(BuildContext context) {
    return Container(
      height: size.height * .10,
      margin: EdgeInsets.symmetric(horizontal: 32),
      child: Align(
        alignment: Alignment.topCenter,
        child: FlatButton(
            color: AppColor.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (ctx, a1, a2) => DetailScreen(
                            movie: movieData.movieList[movieIndex],
                            size: size,
                          )));
            },
            child: Container(
              width: double.infinity,
              height: size.height * .08,
              child: Center(
                child: Text(
                  'Buy Ticket',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            )),
      ),
    );
  }

  double movieDescriptionOpacity(double offset, double activeOffset) {
    double opacity;
    if (movieScrollController.offset + movieItemWidth <= activeOffset) {
      opacity = 0;
    } else if (movieScrollController.offset <= activeOffset) {
      opacity =
          ((movieScrollController.offset - (activeOffset - movieItemWidth)) /
              movieItemWidth *
              100);
    } else if (movieScrollController.offset < activeOffset + movieItemWidth) {
      opacity = 100 -
          (((movieScrollController.offset - (activeOffset - movieItemWidth)) /
                  movieItemWidth *
                  100) -
              100);
    } else {
      opacity = 0;
    }
    return opacity;
  }

  double movieTranslate(double offset, double activeOffset) {
    double translate;
    if (movieScrollController.offset + movieItemWidth <= activeOffset) {
      translate = maxMovieTranslate;
    } else if (movieScrollController.offset <= activeOffset) {
      translate = maxMovieTranslate -
          ((movieScrollController.offset - (activeOffset - movieItemWidth)) /
              movieItemWidth *
              maxMovieTranslate);
    } else if (movieScrollController.offset < activeOffset + movieItemWidth) {
      translate =
          ((movieScrollController.offset - (activeOffset - movieItemWidth)) /
                  movieItemWidth *
                  maxMovieTranslate) -
              maxMovieTranslate;
    } else {
      translate = maxMovieTranslate;
    }
    return translate;
  }

  Widget starRating(double rating) {
    Widget star(bool fill) {
      return Container(
        child: Icon(
          Icons.star,
          size: 18,
          color: fill ? AppColor.primary : Colors.grey,
        ),
      );
    }

    return Row(
      children: List.generate(5, (index) {
        if (index < (rating / 2).round()) {
          return star(true);
        } else
          return star(false);
      }),
    );
  }

  Widget genresFormat(List<String> genres) {
    Widget dot = Container(
      width: 6,
      height: 6,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
    );

    return Row(
      children: List.generate(genres.length, (index) {
        if (index < genres.length - 1) {
          return Row(
            children: <Widget>[
              Text(
                genres[index],
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              dot
            ],
          );
        } else {
          return Text(
            genres[index],
            style: TextStyle(color: Colors.white, fontSize: 12),
          );
        }
      }),
    );
  }
}
