import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _imageIndex = 0;
  List<String> imageList = [];
  bool isFavorite;

  @override
  void initState() {
    super.initState();

    this.isFavorite = false;
  }

  void swipeImage(DragEndDetails details) {
    if (details.primaryVelocity > 30 || details.primaryVelocity < -30) {
      int imageIndex = details.primaryVelocity > 0
          ? this._imageIndex - 1
          : this._imageIndex + 1;
      imageIndex = imageIndex % this.imageList.length;
      setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        this._imageIndex = imageIndex;
      });
    }
  }

  Future<List<String>> getUserList(BuildContext context) async {
    if (this.imageList.length > 0) {
      return this.imageList;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfo = prefs.getString('userInfo');
    if (userInfo == null || userInfo != 'ok') {
      Navigator.pushNamed(context, '/login').then((value) {
        setState(() {
          // refresh state
        });
      });
    } else {
      for (int i = 1; i <= 9; ++i) {
        this.imageList.add(
            "https://shopincat.oss-cn-hangzhou.aliyuncs.com/meetyou/0" +
                i.toString() +
                ".jpeg");
      }
    }

    return this.imageList;
  }

  goToDetail() {
    Navigator.pushNamed(context, '/detail').then((value) {
      setState(() {
        // refresh state
      });
    });
  }

  _onPressedProfile() {
    Navigator.pushNamed(context, '/editProfile').then((value) {
      setState(() {
        // refresh state
      });
    });
  }

  Widget _buildHome(
      BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    return Scaffold(
      body: GestureDetector(
          onHorizontalDragEnd: swipeImage,
          onTap: goToDetail,
          child: this.imageList.length > 0
              ? ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: new Image.network(
                    this.imageList[this._imageIndex],
                    fit: BoxFit.cover,
                  ),
                )
              : null),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: _onPressedProfile,
        child: Icon(
          Icons.person,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<String>>(
      future: getUserList(context),
      builder: _buildHome,
    );
  }
}
