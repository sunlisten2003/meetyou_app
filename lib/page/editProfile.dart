import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nickNameEditController;
  TextEditingController _heightEditController;
  TextEditingController _selfIntroductionEditController;
  int _gender; //0 男，1 女
  DateTime _birthday;
  Result _city;
  List<File> _imageList;

  final FocusNode _nickNameFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _selfIntroductionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _nickNameEditController = TextEditingController();
    _nickNameFocusNode.addListener(() => setState(() => {}));
    _heightEditController = TextEditingController();
    _heightFocusNode.addListener(() => setState(() => {}));
    _selfIntroductionEditController = TextEditingController();
    _selfIntroductionFocusNode.addListener(() => setState(() => {}));

    this._gender = 0;
    this._birthday = DateTime.now();
    this._city = null;
    this._imageList = [];
  }

  _buildEditProfileTip() {
    return Padding(
      padding: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 45),
      child: Text(
        "请完善您的个人信息，让TA找到你！",
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }

  _buildNickNameTextField() {
    return TextField(
      controller: _nickNameEditController,
      focusNode: _nickNameFocusNode,
      decoration: InputDecoration(
        hintText: "昵称",
        border: InputBorder.none,
      ),
    );
  }

  _onChangedGenderRadio(int v) {
    setState(() {
      this._gender = v;
    });
  }

  _buildGenderRadio() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '性别',
          style: TextStyle(fontSize: 16),
        ),
        Radio(
          value: 0,
          groupValue: _gender,
          onChanged: _onChangedGenderRadio,
        ),
        Text(
          '男',
          style: TextStyle(fontSize: 16),
        ),
        Radio(
          value: 1,
          groupValue: _gender,
          onChanged: _onChangedGenderRadio,
        ),
        Text(
          '女',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  _buildBirthdayPicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime dt = await showDatePicker(
          context: context,
          initialDate: _birthday == null ? DateTime.now() : _birthday,
          firstDate: DateTime.now().subtract(new Duration(days: 21900)),
          lastDate: DateTime.now(),
        );
        setState(() {
          this._birthday = dt;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '生日',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 3),
              child: Text(
                "${this._birthday.year}-${this._birthday.month}-${this._birthday.day}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCityPicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Result rt = await CityPickers.showCityPicker(
          context: context,
        );
        setState(() {
          this._city = rt;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '城市',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                this._city == null ? "请选择" : this._city.cityName,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeightTextField() {
    return TextField(
      controller: _heightEditController,
      focusNode: _heightFocusNode,
      decoration: InputDecoration(
        hintText: "身高，单位cm",
        border: InputBorder.none,
      ),
    );
  }

  _openGallery() async {
    final picker = ImagePicker();
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        this._imageList.add(File(image.path));
      });
    }
  }

  _buildImagePicker() {
    List<Widget> images = [];
    for (var i = 0; i < this._imageList.length; ++i) {
      images.add(
        new GestureDetector(
          onDoubleTap: () {
            this._imageList.removeAt(i);
            setState(() {});
          },
          child: Padding(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              width: 70.0,
              height: 70.0,
              child: Image.file(
                this._imageList[i],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '照片',
              style: TextStyle(fontSize: 16),
            ),
            FlatButton(
              onPressed: _openGallery,
              child: Text("选择照片"),
            )
          ],
        ),
        Wrap(
          children: images,
        ),
      ],
    );
  }

_buildSelfIntroduction(){
  return TextField(
      controller: _selfIntroductionEditController,
      focusNode: _selfIntroductionFocusNode,
      maxLength: 1000,
      minLines: 6,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: "介绍一下自己吧",
        border: OutlineInputBorder(),
      ),
    );
}

  _onSave(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', "ok");
    Navigator.pop(context);
  }

  _buildEditWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          _buildNickNameTextField(),
          Divider(height: 1.0),
          _buildGenderRadio(),
          Divider(height: 1.0),
          _buildBirthdayPicker(context),
          Divider(height: 1.0),
          _buildCityPicker(context),
          Divider(height: 1.0),
          _buildHeightTextField(),
          Divider(height: 1.0),
          _buildImagePicker(),
          Divider(height: 1.0),
          _buildSelfIntroduction(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('遇见你'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                _onSave(context);
              },
              child: Text(
                "保存",
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildEditProfileTip(),
            Divider(height: 1.0),
            _buildEditWidget(context),
          ],
        ),
      ),
    );
  }
}
