import 'dart:math';

import 'package:bottom_navigation/screens/admin_app/models/Request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlipItem extends StatefulWidget {
  final PersonalRequest request;
  FlipItem({this.request});

  @override
  _FlipItemState createState() => _FlipItemState();
}

class _FlipItemState extends State<FlipItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Animation _animationFlip;
  bool anim = false;
  Widget visibleScreen = Container();

  Widget getScreen(BuildContext context) {
    if (_animationFlip.value < 0.5) {
      visibleScreen = Center(child: ThemeBox(widget.request));
    } else {
      visibleScreen = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationX(_animationFlip.value != 0 ? pi : 0.0),
        child: Container(
          height: 100,
          width: 300,
          // color: Colors.purple,
          child: Center(
              child: Card(
            color: Colors.deepOrange,
            elevation: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  child: Center(
                      child: Text(
                    widget.request.level,
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'status: Not Confirmed',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd – kk:mm')
                          .format(DateTime.parse(widget.request.date)),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          )),
        ),
      );
      ;
    }
    return visibleScreen;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _animation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(100, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
            setState(() {});
          });

//flip anim (container3)
    _animationFlip = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
      height: anim ? 200 : 100,
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {
          // print('anim ==> $anim');
          if (anim == false) {
            _controller.forward();

            // print('click');
            setState(() {
              anim = true;
            });
          } else {
            _controller.reverse();
            // print('unclick');

            setState(() {
              anim = false;
            });
          }
        },
        child: Stack(
          children: [
            Container(
              height: 100,
              width: 300,
              // color: Colors.orange,
              child: Center(
                child: Card(
                  color: Colors.deepOrange,
                  elevation: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 70,
                        child: Center(
                            child: Text(
                          widget.request.theme,
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.request.name} ${widget.request.lastName}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            widget.request.email,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(pi * _animationFlip.value),
                alignment: Alignment.bottomCenter,
                child: getScreen(context)),
          ],
        ),
      ),
    );
  }
}

Widget ThemeBox(PersonalRequest request) {
  return Center(
    child: Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Container(
                width: 50,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat('dd').format(DateTime.parse(request.date)),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      DateFormat('MMM').format(DateTime.parse(request.date)),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ))),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Colors.blue,
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Color(0xff6A88E5),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff6A88E5),
                      blurRadius: 4,
                      // offset: Offset.infinite,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      request.theme,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${request.name} ${request.lastName}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      request.email,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
