import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliceblue/util/sizer.dart';

import '../res/res.dart';

class CustomLongButton extends StatelessWidget {
  final String label;
  final Function onPress;
  final double? borderRadius;
  final Color color;
  final bool? loading;
  final TextStyle? labelStyle;
  final double? height;
  final SvgPicture? icon;
  const CustomLongButton({
    Key? key,
    this.loading,
    this.height,
    required this.color,
    this.labelStyle,
    this.borderRadius,
    this.icon,
    required this.label,
    required this.onPress,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading == true ? () {} : () => onPress(),
      style: ElevatedButton.styleFrom(
          primary: color,
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 4)),
          fixedSize: Size(MediaQuery.of(context).size.width, height ?? 50)),
      child: loading == true
          ? const SizedBox(
              child: JumpingDots(
              numberOfDots: 3,
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? const SizedBox(),
                icon != null ? Sizer.halfHorizontal() : const SizedBox(),
                Text(
                  label,
                  style: labelStyle ?? textStyles.kTextFourteenW700,
                ),
              ],
            ),
    );
  }
}

class DotWidget extends StatelessWidget {
  const DotWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      height: 7,
      width: 7,
    );
  }
}

class JumpingDots extends StatefulWidget {
  final int numberOfDots;

  const JumpingDots({
    Key? key,
    this.numberOfDots = 3,
  }) : super(key: key);

  @override
  _JumpingDotsState createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State with TickerProviderStateMixin {
  late List _animationControllers;

  List _animations = [];

  int animationDuration = 200;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    ///initialization of _animationControllers
    ///each _animationController will have same animation duration

    _animationControllers = List.generate(
      3,
      (index) {
        return AnimationController(
            vsync: this, duration: Duration(milliseconds: animationDuration));
      },
    ).toList();

    ///initialization of _animations
    ///here end value is -20
    ///end value is amount of jump.
    ///and we want our dot to jump in upward direction
    for (int i = 0; i < 3; i++) {
      _animations.add(
          Tween<double>(begin: 0, end: -20).animate(_animationControllers[i]));
    }

    for (int i = 0; i < 3; i++) {
      _animationControllers[i].addStatusListener((status) {
        //On Complete
        if (status == AnimationStatus.completed) {
          //return of original postion
          _animationControllers[i].reverse();
          //if it is not last dot then start the animation of next dot.
          if (i != 3 - 1) {
            _animationControllers[i + 1].forward();
          }
        }
        //if last dot is back to its original postion then start animation of the first dot.
        // now this animation will be repeated infinitely
        if (i == 3 - 1 && status == AnimationStatus.dismissed) {
          _animationControllers[0].forward();
        }
      });
    }

    //trigger animtion of first dot to start the whole animation.
    _animationControllers.first.forward();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        //AnimatedBuilder widget will rebuild it self when
        //_animationControllers[index] value changes.
        return AnimatedBuilder(
          animation: _animationControllers[index],
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(3),
              //Transform widget's translate constructor will help us to move the dot
              //in upward direction by changing the offset of the dot.
              //X-axis position of dot will not change.
              //Only Y-axis position will change.
              child: Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: DotWidget(),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
