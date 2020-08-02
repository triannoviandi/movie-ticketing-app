import 'package:flutter/material.dart';

class MovieData {
  List<MovieModel> movieList;

  MovieData() {
    movieList = List();
    movieList.add(
      MovieModel(
          id: 0,
          name: 'Dolittle',
          rating: 5.6,
          genre: ["Family", "Adventure"],
          storyLine:
              "Dr. John Dolittle lives in solitude behind the high walls of his lush manor in 19th-century England. His only companionship comes from an array of exotic animals that he speaks to on a daily basis. But when young Queen Victoria becomes gravely ill, the eccentric doctor and his furry friends embark on an epic adventure to a mythical island to find the cure.",
          image: Image.asset("assets/image/dolittle.jpg"),
          imageText: Image.asset("assets/image/dolittle-text.png"),
          videoClipPath: "assets/video/dolittleclip.mp4",
          videoClipReflectionPath: "assets/video/dolittleclip-reflection.mp4",
          castList: [
            MovieCastModel(
              name: "Robert Downey Jr",
              photo: Image.asset("assets/image/cast/robert.jpg"),
            ),
            MovieCastModel(
              name: "Tom Holland",
              photo: Image.asset("assets/image/cast/tom.jpg"),
            ),
            MovieCastModel(
              name: "Rami Malek",
              photo: Image.asset("assets/image/cast/rami.jpg"),
            ),
            MovieCastModel(
              name: "Selena Gomez",
              photo: Image.asset("assets/image/cast/selena.jpg"),
            )
          ]),
    );
    movieList.add(
      MovieModel(
          id: 1,
          name: 'Mulan',
          rating: 4.0,
          genre: ["Action", "Adventure"],
          storyLine:
              "Fearful that her ailing father will be drafted into the Chinese military, Mulan (Ming-Na Wen) takes his spot -- though, as a girl living under a patriarchal regime, she is technically unqualified to serve. She cleverly impersonates a man and goes off to train with fellow recruits. Accompanied by her dragon, Mushu (Eddie Murphy), she uses her smarts to help ward off a Hun invasion, falling in love with a dashing captain along the way.",
          image: Image.asset("assets/image/mulan.jpg"),
          imageText: Image.asset("assets/image/mulan-text.png"),
          videoClipPath: "assets/video/mulanclip.mp4",
          videoClipReflectionPath: "assets/video/mulanclip-reflection.mp4",
          castList: [
            MovieCastModel(
              name: "Liu Yifei",
              photo: Image.asset("assets/image/cast/liu.jpg"),
            ),
            MovieCastModel(
              name: "Donnie Yen",
              photo: Image.asset("assets/image/cast/donnie.jpg"),
            ),
            MovieCastModel(
              name: "Jet Li",
              photo: Image.asset("assets/image/cast/jetli.jpg"),
            ),
            MovieCastModel(
              name: "Gong Li",
              photo: Image.asset("assets/image/cast/gongli.jpg"),
            )
          ]),
    );
    movieList.add(
      MovieModel(
          id: 2,
          name: 'Black Widow',
          rating: 7.0,
          genre: ["Action", "Adventure"],
          storyLine:
              "At birth the Black Widow (aka Natasha Romanova) is given to the KGB, which grooms her to become its ultimate operative. When the U.S.S.R. breaks up, the government tries to kill her as the action moves to present-day New York, where she is a freelance operative.",
          image: Image.asset("assets/image/blackwidow.jpg"),
          imageText: Image.asset("assets/image/blackwidow-text.png"),
          videoClipPath: "assets/video/blackwidowclip.mp4",
          videoClipReflectionPath: "assets/video/blackwidowclip-reflection.mp4",
          castList: [
            MovieCastModel(
              name: "Scarlett Johansson",
              photo: Image.asset("assets/image/cast/scarlett.jpg"),
            ),
            MovieCastModel(
              name: "Florance Pugh",
              photo: Image.asset("assets/image/cast/florance.jpg"),
            ),
            MovieCastModel(
              name: "David Harbour",
              photo: Image.asset("assets/image/cast/david.jpg"),
            ),
            MovieCastModel(
              name: "Rachel Weisz",
              photo: Image.asset("assets/image/cast/rachel.jpg"),
            )
          ]),
    );
  }
}

class MovieModel {
  int id;
  String name;
  List<String> genre;
  double rating;
  String storyLine;
  Image image;
  Image imageText;
  String videoClipPath;
  String videoClipReflectionPath;
  List<MovieCastModel> castList = List();

  MovieModel(
      {this.id,
      this.genre,
      this.name,
      this.rating,
      this.storyLine,
      this.image,
      this.imageText,
      this.castList,
      this.videoClipPath,
      this.videoClipReflectionPath});
}

class MovieCastModel {
  String name;
  Image photo;

  MovieCastModel({this.name, this.photo});
}
