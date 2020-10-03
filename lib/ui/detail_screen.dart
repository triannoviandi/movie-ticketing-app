import 'package:flutter/material.dart';
import 'package:movieticketingapp/data/movie_data.dart';
import 'package:movieticketingapp/ui/booking_screen.dart';
import 'package:movieticketingapp/widget/app_widget.dart';
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
  Size get _size => MediaQuery.of(context).size;
  RubberAnimationController _rubberSheetAnimationController;
  ScrollController _rubberSheetScrollController;

  VideoPlayerController _moviePlayerController;
  VideoPlayerController _reflectionPlayerController;

  @override
  void initState() {
    super.initState();
    _rubberSheetScrollController = ScrollController();
    _rubberSheetAnimationController = RubberAnimationController(
      vsync: this,
      lowerBoundValue:
          AnimationControllerValue(pixel: widget.size.height * .75),
      dismissable: false,
      upperBoundValue: AnimationControllerValue(percentage: .9),
      duration: Duration(milliseconds: 300),
      springDescription: SpringDescription.withDampingRatio(
          mass: 1, stiffness: Stiffness.LOW, ratio: DampingRatio.LOW_BOUNCY),
    );

    _moviePlayerController =
        VideoPlayerController.asset(widget.movie.videoClipPath)..initialize();
    _reflectionPlayerController =
        VideoPlayerController.asset(widget.movie.videoClipReflectionPath)
          ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _background(widget.movie.image),
          _rubberSheet(),
          _buyButton(context),
          _backButton(context),
        ],
      ),
    );
  }

  Positioned _backButton(BuildContext context) {
    return Positioned(
      left: 16,
      top: MediaQuery.of(context).padding.top + 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buyButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: _size.width * .9,
        height: _size.height * .08,
        margin: EdgeInsets.symmetric(vertical: _size.width * .05),
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
                    moviePlayerController: _moviePlayerController,
                    reflectionPlayerController: _reflectionPlayerController),
              ),
            );
          },
          child: Text(
            'Buy Ticket',
            style: TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _rubberSheet() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 250),
      tween: Tween<double>(begin: _size.height / 2, end: 0),
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: RubberBottomSheet(
        scrollController: _rubberSheetScrollController,
        animationController: _rubberSheetAnimationController,
        lowerLayer: Container(color: Colors.transparent),
        upperLayer: Container(
          // color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                  child: Center(
                child: Image(
                  image: widget.movie.imageText.image,
                  width: _size.width / 2,
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
                    controller: _rubberSheetScrollController,
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
                      AppWidget.genresFormat(widget.movie.genre, Colors.black),
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
                      AppWidget.starRating(widget.movie.rating),
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
                      _cast(),
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

  Widget _cast() {
    return Container(
      width: _size.width,
      height: 140,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: _size.width / 6,
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: widget.movie.castList[index].photo.image,
                      width: _size.width / 6,
                    ),
                  ),
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

  Widget _background(Image background) {
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
          width: _size.width,
          height: _size.height,
        ),
      ),
    );
  }
}
