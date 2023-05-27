// import 'dart:math';

import 'dart:async';
import 'dart:convert';

import 'package:app/cardinfo.dart';
import 'package:app/notify.dart';
import 'package:flutter/material.dart';
import 'package:app/user.dart';
import 'package:http/http.dart' as http;
import 'package:loading_gifs/loading_gifs.dart';

import 'deal.dart';
import 'home.dart';
import 'login.dart';
import 'main.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final _focusNode = FocusNode();
  bool isMenuOpen = false;
  bool showImage = true;
  late String card = "";
  var bocoin;

  void _startTimer() {
    Timer(Duration(seconds: 4), () {
      setState(() {
        showImage = false;
      });
    });
  }

  Future<void> _listPool(apiUrl) async {

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    String getUserOutlookurl = ('$apiUrl:8000/listPool');
    try {
      http.Response response = await http.get(Uri.parse(getUserOutlookurl), headers: headers);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      var pool =data['pools'][0];

      if (status == 0) {
        // print("成功取得抽獎池! ,$pool");
        setState(() {
          card = pool['photo'];
          print(card);
        });
        print("成功取得抽獎池! ,$data");
      } else{

        print('取得抽獎池錯誤：$responseData');
      }
    } catch (e) {
      print('api ERROR：$e');
    }
  }

  Future<void> _getUserInfo(apiUrl) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    String getUserInfourl = ('$apiUrl:8000/getUserInfo');
    try {
      http.Response response = await http.get(Uri.parse(getUserInfourl), headers: headers);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      bocoin = data['bocoin'];


      if (status == 0) {
        print('取得使用者資料：$responseData');
        print(bocoin);

      } else{
        print('取得資訊錯誤：$responseData');
      }
    } catch (e) {
      print('api ERROR：$e');
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    setState(() {
      bool isMenuOpen = false;
      _listPool(apiUrl);
      _getUserInfo(apiUrl);
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });
  }


  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          setState(() {
            isMenuOpen =false;
            _listPool(apiUrl);
            _getUserInfo(apiUrl);
          });
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/shop.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.only(left: 25,top: 25),
                                height: 70,
                                width: 70,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomePage()),
                                      );
                                      print('bakeButton click');
                                    },
                                    child: Image.asset('assets/images/back.png')
                                ),
                              ),
                            )
                        ),
                        Center(
                            child: Column(
                              children: [
                                Row(
                              children: <Widget>[
                                SizedBox(width: screenWidth*0.5,),
                                Transform.rotate(
                                  angle: -0.5,
                                  child: Container(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const CardInfoPage()),
                                          );
                                          print('CardInfo click');
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 40,
                                        )
                                    ),
                                  ),
                                ),
                              ],
                           ),
                                Container(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isMenuOpen = !isMenuOpen;
                                        showImage = false;
                                      });
                                      print('confirm click');
                                    },
                                    child: Align(
                                      alignment: Alignment(0.0045, 0),
                                      child: Transform.translate(

                                        offset: Offset(0, 4),
                                        child: Container(
                                          height: screenWidth * 0.4645,
                                          width: screenWidth * 0.4645,
                                          child: Image.asset(card)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight*0.145,),
                                Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: screenHeight*0.2,
                                      child:
                                      showImage ? Image.asset(
                                        'assets/images/shopdialog.png',
                                        fit: BoxFit.contain,
                                      ):Container(
                                        height: screenHeight*0.2,
                                      )
                                    ),
                                    Container(
                                        child: isMenuOpen ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(width: screenWidth*0.05,),
                                            Stack(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: screenHeight*0.2,
                                                  child: Image.asset(
                                                    'assets/images/confirm.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ) ,
                                                Column(
                                                  children: [
                                                    SizedBox(height: screenHeight*0.08,),
                                                    Row(
                                                        children: <Widget>[
                                                          SizedBox(width: screenWidth*0.30),
                                                          Container(
                                                            child: Text(
                                                              '目前持有Bocoin數：',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff050505),
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 11.0,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15,),
                                                          Container(
                                                            child: Text(
                                                              "$bocoin",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xffc09e5d),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 11.0,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),

                                                    SizedBox(height:35,),
                                                    Row(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        SizedBox(width: screenWidth*0.27,),
                                                        TextButton(
                                                          style: ButtonStyle(
                                                            side: MaterialStateProperty.all<BorderSide>(
                                                              const BorderSide(width: 2, color: Colors.black),
                                                            ),
                                                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff7A7186)),
                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => const ShopPage()),
                                                            );
                                                            print('close click');
                                                          },
                                                          child: const SizedBox(
                                                            width: 40,
                                                            height: 20,
                                                            child:
                                                            Center(
                                                              child: Text(
                                                                '1抽',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  letterSpacing: 2,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),SizedBox(width: 45,),
                                                        TextButton(
                                                          style: ButtonStyle(
                                                            side: MaterialStateProperty.all<BorderSide>(
                                                              const BorderSide(width: 2, color: Colors.black),
                                                            ),
                                                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff7A7186)),
                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => const ShopPage()),
                                                            );
                                                            print('close click');
                                                          },
                                                          child: const SizedBox(
                                                            width: 40,
                                                            height: 20,
                                                            child:
                                                            Center(
                                                              child: Text(
                                                                '10抽',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  letterSpacing: 2,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )

                                              ],
                                            )
                                          ],
                                        ) : Column(
                                          children: [
                                            Container(
                                              height: screenHeight*0.2,
                                            )
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight*0.1,),
                              ],
                            )
                        )
                      ],
                    )
                ),
              ],
            )
        )
    );
  }
}
