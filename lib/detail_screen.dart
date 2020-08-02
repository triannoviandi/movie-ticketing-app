import 'package:flutter/material.dart';
import 'package:movieticketingapp/app_util.dart';
import 'package:movieticketingapp/booking_screen.dart';
import 'package:movieticketingapp/movie_data.dart';
import 'package:rubber/rubber.dart';
import 'package:video_player/video_player.dart';

class DetailScreen extends StatefulWidget {
  final MovieModel movie;
  final Size size;

  DetailScreen({this.movie, this.size});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  Size get size => MediaQuery.of(context).size;
  RubberAnimationController rubberSheetAnimationController;
  ScrollController rubberSheetScrollController;

  VideoPlayerController moviePlayerController;
  VideoPlayerController reflectionPlayerController;

  @override
  void initState() {
    rubberSheetScrollController = ScrollController();
    rubberSheetAnimationController = RubberAnimationController(
      vsync: this,
      lowerBoundValue:
          AnimationControllerValue(pixel: widget.size.height * .75),
      dismissable: false,
      upperBoundValue: AnimationControllerValue(percentage: .9),
      duration: Duration(milliseconds: 300),
      springDescription: SpringDescription.withDampingRatio(
          mass: 1, stiffness: Stiffness.LOW, ratio: DampingRatio.LOW_BOUNCY),
    );

    moviePlayerController =
        VideoPlayerController.asset(widget.movie.videoClipPath)..initialize();
    reflectionPlayerController =
        VideoPlayerController.asset(widget.movie.videoClipReflectionPath)
          ..initialize();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          background(widget.movie.image),
          rubberSheet(),
          buyButton(context),
          backButton(context),
        ],
      ),
    );
  }

  Positioned backButton(BuildContext context) {
    return Positioned(
        left: 16,
        top: MediaQuery.of(context).padding.top + 16,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ));
  }

  Widget buyButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: size.width * .9,
        height: size.height * .08,
        margin: EdgeInsets.symmetric(vertical: size.width * .05),
        child: FlatButton(
            color: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (ctx, a1, a2) => BookingScreen(
                          movieName: widget.movie.name,
                          moviePlayerController: moviePlayerController,
                          reflectionPlayerController:
                              reflectionPlayerController)));
            },
            child: Text(
              'Buy Ticket',
              style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
      ),
    );
  }

  Widget rubberSheet() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 250),
      tween: Tween<double>(begin: size.height / 2, end: 0),
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: RubberBottomSheet(
        scrollController: rubberSheetScrollController,
        animationController: rubberSheetAnimationController,
        lowerLayer: Container(color: Colors.transparent),
        upperLayer: Container(
          // color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                  child: Center(
                child: Image(
                  image: widget.movie.imageText.image,
                  width: size.width / 2,
                ),
              )),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24))),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(24),
                    controller: rubberSheetScrollController,
                    children: <Widget>[
                      Text(
                        widget.movie.name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      genresFormat(widget.movie.genre),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.movie.rating.toString(),
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      starRating(widget.movie.rating),
                      SizedBox(
                        height: 28,
                      ),
                      Text(
                        'Story Line',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.movie.storyLine,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      cast(),
                      SizedBox(
                        height: 68,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cast() {
    return Container(
      width: size.width,
      height: 140,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: size.width / 6,
              child: Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: widget.movie.castList[index].photo.image,
                        width: size.width / 6,
                      )),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    widget.movie.castList[index].name,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget starRating(double rating) {
    Widget star(bool fill) {
      return Container(
        child: Icon(
          Icons.star,
          size: 18,
          color: fill ? AppColor.primary : Colors.grey[300],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.black),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(genres.length, (index) {
        if (index < genres.length - 1) {
          return Row(
            children: <Widget>[
              Text(
                genres[index],
                style: TextStyle(fontSize: 14),
              ),
              dot
            ],
          );
        } else {
          return Text(
            genres[index],
            style: TextStyle(fontSize: 14),
          );
        }
      }),
    );
  }

  Widget background(Image background) {
    return Positioned(
      top: -48,
      bottom: 0,
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 250),
        tween: Tween<double>(begin: .25, end: 1),
        builder: (_, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Image(
          fit: BoxFit.cover,
          image: background.image,
          width: size.width,
          height: size.height,
        ),
      ),
    );
  }
}
