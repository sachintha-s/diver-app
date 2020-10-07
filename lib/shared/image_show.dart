import 'package:flutter/material.dart';

class ImageShow extends StatelessWidget {
  final String imgUrl;

  const ImageShow({Key key, this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Profile Photo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Hero(
        transitionOnUserGestures: true,
        tag: "profilepic",
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(),
                ));
          },
          child: Container(
            color: Colors.black,
            child: Center(
              child: (imgUrl == null)
                  ? Image.asset("images/default_profile_pic.jpg")
                  : Image.network(imgUrl),
            ),
          ),
        ),
      ),
    );
  }
}
