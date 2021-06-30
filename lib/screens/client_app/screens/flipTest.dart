import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';

class FlipPage extends StatefulWidget {
  final String theme;
  FlipPage(this.theme);
  @override
  _FlipPageState createState() => _FlipPageState();
}

class _FlipPageState extends State<FlipPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Animation _animationFlip;
  bool anim = false;
  Widget visibleScreen = Container();

  Widget getScreen() {
    if (_animationFlip.value < 0.5) {
      visibleScreen = Container(
        height: 100,
        width: 100,
        color: Colors.purple,
        child: Center(child: Text(widget.theme)),
      );
    } else {
      visibleScreen = Container(
        height: 100,
        width: 100,
        color: Colors.red,
        child: Center(child: Text('HIII!!!!')),
      );
      ;
    }
    return visibleScreen;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.15,
      width: width,
      child: Center(
        child: InkWell(
          onTap: () {
            print('anim ==> $anim');
            if (anim == false) {
              _controller.forward();

              print('click');
              setState(() {
                anim = true;
              });
            } else {
              _controller.reverse();
              print('unclick');

              setState(() {
                anim = false;
              });
            }
          },
          child: Stack(
            children: [
              Container(
                  height: 100,
                  width: 100,
                  color: Colors.orange,
                  child: Center(child: Text(widget.theme))),
              Transform(
                transform: Matrix4.rotationY(pi * _animationFlip.value ),
                child: getScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
