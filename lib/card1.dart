// import 'dart:math';

import 'dart:async';
import 'dart:convert';

import 'package:app/shop.dart';
import 'package:flutter/material.dart';
import 'package:app/login.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class Card1Page extends StatefulWidget {
  const Card1Page({super.key});

  @override
  _Card1PageState createState() => _Card1PageState();
}

class _Card1PageState extends State<Card1Page> {
  final _focusNode = FocusNode();
  late List<dynamic> _item = [];

  @override
  void initState() {
    super.initState();
    _drawCards(apiUrl);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _drawCards(apiUrl) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };
    Map<String, dynamic> data1 = {
      "pool": "1",
      "type": 0,
    };

    String drawCardsurl = ('$apiUrl:8000/drawCards');
    try {
      String jsonData = jsonEncode(data1);
      http.Response response = await http.post(
          Uri.parse(drawCardsurl), headers: headers, body: jsonData);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      final itemsList = data['list'];
      // final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(jsonDecode(itemsList));
      // final List<Item> item = items.map((itemData) => Item.fromJson(itemData)).toList();

      _item = [];
      if (status == 0) {
        print(itemsList);
        setState(() {
          _item = itemsList;
        });
        // print(_item[0]['photo']);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
              const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('取得資訊有誤請檢查網路或重啟應用程式',),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('確定'),
                ),
              ],
              contentPadding: EdgeInsets.only(top: 40, right: 20, left: 20),
            );
          },
        );
        // 登錄失敗，處理失敗的邏輯
        print('取得資訊錯誤：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    // 检查 _item 列表是否为空
    if (_item.isEmpty) {
      return CircularProgressIndicator(); // 或者其他加载中的 UI 组件
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/getCard.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.215),
              Center(
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: screenHeight * 0.17),
                        // Container(
                        //   height: screenWidth * 0.3,
                        //   width: screenWidth * 0.3,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Color(0xfff5eeda),
                        //       borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     width: screenWidth * 0.18,
                        //     height: screenWidth * 0.18,
                        //     child: Image.asset(
                        //       _item[0]['photo']!,
                        //       fit: BoxFit.contain,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xfff5eeda),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: screenWidth * 0.3,
                          width: screenWidth * 0.3,
                          child: _item.isNotEmpty
                              ? Image.asset(
                            _item[0]['photo']!,
                            fit: BoxFit.contain,
                          )
                              : CircularProgressIndicator(), // 或其他加载指示符
                        ),
                        SizedBox(height: screenHeight * 0.12),
                        TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(width: 2, color: Colors.black),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff7A7186)),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) =>ShopPage()),
                            );
                            print('close click');
                          },
                          child: SizedBox(
                            width: 60,
                            height: 25,
                            child: Center(
                              child: Text(
                                '確認',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  letterSpacing: 5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Item {
  final int id;
  final String name;
  final String photo;

  Item({required this.id, required this.name, required this.photo});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      name: json['name'] as String,
      photo: json['photo'] as String,
    );
  }
}
