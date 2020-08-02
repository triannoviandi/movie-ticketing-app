import 'package:flutter/material.dart';
import 'package:movieticketingapp/app_util.dart';
import 'package:movieticketingapp/videoclipper.dart';
import 'package:movieticketingapp/videoclipper2.dart';
import 'package:video_player/video_player.dart';

class BookingScreen extends StatefulWidget {
  VideoPlayerController moviePlayerController;
  VideoPlayerController reflectionPlayerController;
  String movieName;

  BookingScreen(
      {this.moviePlayerController,
      this.reflectionPlayerController,
      this.movieName});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  Size get size => MediaQuery.of(context).size;
  List<AnimationController> dateSelectorACList = List();
  List<Animation<double>> dateSelectorTweenList = List();

  List<AnimationController> timeSelectorACList = List();
  List<Animation<double>> timeSelectorTweenList = List();

  AnimationController dateBackgroundAc;
  Animation<double> dateBackgroundTween;

  AnimationController cinemaScreenAc;
  Animation<double> cinemaScreenTween;

  AnimationController reflectionAc;
  Animation<double> reflectionTween;

  AnimationController payButtonAc;
  Animation<double> payButtonTween;

  AnimationController cinemaChairAc;
  Animation<double> cinemaChairTween;

  int dateIndexSelected = 1;
  int timeIndexSelected = 1;
  var chairStatus = [
    [0, 3, 2, 1, 2, 2, 0],
    [2, 2, 2, 2, 1, 2, 2],
    [1, 1, 2, 2, 2, 2, 2],
    [0, 2, 1, 1, 1, 2, 0],
    [2, 2, 2, 2, 2, 2, 2],
    [0, 3, 3, 2, 1, 1, 0]
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.moviePlayerController.setLooping(true);
    widget.reflectionPlayerController.setLooping(true);
    widget.moviePlayerController.play();
    widget.reflectionPlayerController.play();

    initializeAnimation();
  }

  void initializeAnimation() {
    // initialize dateSelector List
    for (int i = 0; i < 7; i++) {
      dateSelectorACList.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)));
      dateSelectorTweenList.add(Tween<double>(begin: 1000, end: 0)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(dateSelectorACList[i]));
      Future.delayed(Duration(milliseconds: i * 50 + 170), () {
        dateSelectorACList[i].forward();
      });
    }

    // initialize dateSelector Background
    dateBackgroundAc =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    dateBackgroundTween = Tween<double>(begin: 1000, end: 0)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(dateBackgroundAc);
    Future.delayed(Duration(milliseconds: 150), () {
      dateBackgroundAc.forward();
    });

    // initialize timeSelector List
    for (int i = 0; i < 3; i++) {
      timeSelectorACList.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)));
      timeSelectorTweenList.add(Tween<double>(begin: 1000, end: 0)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(dateSelectorACList[i]));
      Future.delayed(Duration(milliseconds: i * 25 + 100), () {
        timeSelectorACList[i].forward();
      });
    }

    // initialize cinemaScreen
    cinemaScreenAc = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    cinemaScreenTween = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOutQuart))
        .animate(cinemaScreenAc);
    Future.delayed(Duration(milliseconds: 800), () {
      cinemaScreenAc.forward();
    });

    // initialize reflection
    reflectionAc =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    reflectionTween = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOutQuart))
        .animate(reflectionAc);
    Future.delayed(Duration(milliseconds: 1800), () {
      reflectionAc.forward();
    });

    // paybutton
    payButtonAc = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    payButtonTween = Tween<double>(begin: -1, end: 0)
        .chain(CurveTween(curve: Curves.easeInOutQuart))
        .animate(payButtonAc);
    Future.delayed(Duration(milliseconds: 800), () {
      payButtonAc.forward();
    });

    // chair
    cinemaChairAc = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1600));
    cinemaChairTween = Tween<double>(begin: -1, end: 0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(cinemaChairAc);
    Future.delayed(Duration(milliseconds: 1200), () {
      cinemaChairAc.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: <Widget>[
            appbar(),
            dateSelector(),
            timeSelector(),
            cinemaRoom(),
            payButton()
          ],
        ),
      ),
    );
  }

  Widget cinemaRoom() {
    return Expanded(
        flex: 47,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: size.width,
            ),
            Container(
              padding: EdgeInsets.only(top: 18),
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                height: 800,
                child: Center(
                  child: widget.reflectionPlayerController.value.initialized
                      ? AnimatedBuilder(
                          animation: reflectionAc,
                          builder: (ctx, child) {
                            return Opacity(
                              opacity: reflectionTween.value,
                              child: child,
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: .5,
                            child:
                                VideoPlayer(widget.reflectionPlayerController),
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
            Positioned(
              top: 48,
              child: ClipPath(
                clipper: VideoClipper2(),
                child: AnimatedBuilder(
                  animation: reflectionAc,
                  builder: (ctx, child) {
                    return Opacity(
                      opacity: reflectionTween.value,
                      child: child,
                    );
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.grey[300], Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 1])),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: size.height * .02,
                child: AnimatedBuilder(
                    animation: cinemaChairAc,
                    builder: (ctx, child) {
                      return Transform.translate(
                        offset: Offset(0, cinemaChairTween.value * 100),
                        child: Opacity(
                            opacity: cinemaChairTween.value + 1, child: child),
                      );
                    },
                    child: Container(width: size.width, child: chairList()))),
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: widget.moviePlayerController.value.initialized
                          ? AnimatedBuilder(
                              animation: cinemaScreenAc,
                              builder: (ctx, child) {
                                double perspective =
                                    0.004 * cinemaScreenTween.value;
                                // return ClipPath(
                                //     clipper: VideoClipper(
                                //         curveValue: monitorTween.value),
                                //     child: child);
                                return AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Transform(
                                      alignment: Alignment.topCenter,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, perspective)
                                        ..rotateX(cinemaScreenTween.value),
                                      child: ClipPath(
                                          clipper: VideoClipper(
                                              curveValue:
                                                  cinemaScreenTween.value),
                                          child: child)),
                                );
                              },
                              child: VideoPlayer(widget.moviePlayerController),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget payButton() {
    return Expanded(
      flex: 13,
      child: AnimatedBuilder(
        animation: payButtonAc,
        builder: (ctx, child) {
          double opacity() {
            if (payButtonTween.value + 1 < 0.2) {
              return (payButtonTween.value + 1) * 5;
            }
            return 1;
          }

          return Transform.translate(
            offset: Offset(0, payButtonTween.value * 200),
            child: Opacity(opacity: opacity(), child: child),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  chairCategory(Colors.white, "FREE"),
                  chairCategory(AppColor.primary, "YOURS"),
                  chairCategory(Colors.grey[700], "RESERVED"),
                  chairCategory(Colors.red[800], "NOT AVAILABLE"),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32, bottom: 8),
              child: FlatButton(
                  color: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () {},
                  child: Container(
                    width: size.width - 64,
                    height: size.height * .08,
                    child: Center(
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget chairCategory(Color color, String category) {
    return Row(
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: color),
        ),
        Text(
          category,
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontFamily: "Bebas-Neue"),
        ),
      ],
    );
  }

  Widget chairList() {
    // 0 is null
    // 1 is free
    // 2 is reserved
    // 3 is notavailable
    // 4 is yours

    return Container(
      child: Column(
        children: <Widget>[
          for (int i = 0; i < 6; i++)
            Container(
              margin: EdgeInsets.only(top: i == 3 ? size.height * .02 : 0),
              child: Row(
                children: <Widget>[
                  for (int x = 0; x < 9; x++)
                    Expanded(
                        flex: x == 0 || x == 8 ? 2 : 1,
                        child: x == 0 ||
                                x == 8 ||
                                (i == 0 && x == 1) ||
                                (i == 0 && x == 7) ||
                                (i == 3 && x == 1) ||
                                (i == 3 && x == 7) ||
                                (i == 5 && x == 1) ||
                                (i == 5 && x == 7)
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  if (chairStatus[i][x - 1] == 1) {
                                    setState(() {
                                      chairStatus[i][x - 1] = 4;
                                    });
                                  } else if (chairStatus[i][x - 1] == 4) {
                                    setState(() {
                                      chairStatus[i][x - 1] = 1;
                                    });
                                  }
                                },
                                child: Container(
                                  height: size.width / 11 - 10,
                                  margin: EdgeInsets.all(5),
                                  child: chairStatus[i][x - 1] == 1
                                      ? AppIcon.whiteChair()
                                      : chairStatus[i][x - 1] == 2
                                          ? AppIcon.greyChair()
                                          : chairStatus[i][x - 1] == 3
                                              ? AppIcon.redChair()
                                              : AppIcon.yellowChair(),
                                ),
                              )),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget timeSelector() {
    var time = [
      ["01.30", 45],
      ["06.30", 45],
      ["10.30", 45]
    ];

    return Expanded(
      flex: 17,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * .035),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (ctx, index) {
            return AnimatedBuilder(
              animation: timeSelectorACList[index],
              builder: (ctx, child) {
                return Transform.translate(
                  offset: Offset(timeSelectorTweenList[index].value, 0),
                  child: child,
                );
              },
              child: Container(
                  margin: EdgeInsets.only(left: index == 0 ? 32 : 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        timeIndexSelected = index;
                      });
                    },
                    child: timeItem(time[index][0], time[index][1],
                        index == timeIndexSelected ? true : false),
                  )),
            );
          },
        ),
      ),
    );
  }

  Widget timeItem(String time, int price, bool active) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
            color: active ? AppColor.primary : Colors.white, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: time,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColor.primary : Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' PM',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: active ? AppColor.primary : Colors.white,
                    ),
                  )
                ]),
          ),
          Text(
            "IDR ${price}K",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget dateSelector() {
    DateTime currentDate = DateTime.now();

    return Expanded(
      flex: 13,
      child: Container(
        width: size.width,
        padding: EdgeInsets.only(left: 32),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            AnimatedBuilder(
              animation: dateBackgroundAc,
              builder: (ctx, child) {
                return Transform.translate(
                  offset: Offset(dateBackgroundTween.value, 0),
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
              ),
            ),
            Container(
              width: size.width,
              child: ListView.builder(
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  var date = currentDate.add(Duration(days: index));

                  return AnimatedBuilder(
                    animation: dateSelectorACList[index],
                    builder: (ctx, child) {
                      return Transform.translate(
                        offset: Offset(dateSelectorTweenList[index].value, 0),
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          dateIndexSelected = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(
                            vertical: size.height * .025, horizontal: 12),
                        width: 44,
                        decoration: BoxDecoration(
                            color: dateIndexSelected == index
                                ? AppColor.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              dayFormat(date.weekday),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: index == dateIndexSelected
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                  color: index == dateIndexSelected
                                      ? Colors.black
                                      : Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String dayFormat(int dayWeek) {
    switch (dayWeek) {
      case 1:
        return "MO";
        break;
      case 2:
        return "TU";
        break;
      case 3:
        return "WE";
        break;
      case 4:
        return "TH";
        break;
      case 5:
        return "FR";
        break;
      case 6:
        return "SA";
        break;
      case 7:
        return "SU";

        break;
      default:
        return "MO";
    }
  }

  Widget appbar() {
    return Expanded(
      flex: 8,
      child: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(
              widget.movieName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Positioned(
                left: 24,
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 18,
                        )))),
          ],
        ),
      ),
    );
  }
}
