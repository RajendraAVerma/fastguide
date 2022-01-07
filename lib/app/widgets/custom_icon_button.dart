import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double elevation;
  final VoidCallback onTap;

  const CustomIconButton({
    required this.child,
    required this.color,
    required this.elevation,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.all(1.0),
          child: Card(
            elevation: elevation,
            shadowColor: Colors.blue,
            child: SizedBox(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: child,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            color: color,
          ),
        ),
      ),
    );
  }
}

class CustomIconTextButton extends StatelessWidget {
  final Widget text;
  final Widget icon;
  final VoidCallback onTap;
  CustomIconTextButton({
    required this.onTap,
    required this.text,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.redAccent.shade200,
                Colors.orangeAccent.shade200,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.5),
                blurRadius: 1.5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [icon, SizedBox(width: 10.0), text],
          ),
        ),
      ),
    );
  }
}

class CustomIconButton2 extends StatelessWidget {
  final Widget child;
  final Color color;
  final double elevation;
  final VoidCallback onTap;

  const CustomIconButton2({
    required this.child,
    required this.color,
    required this.elevation,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(1.0),
          child: SizedBox(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton3 extends StatelessWidget {
  final Widget child;
  final Color color;
  final double elevation;
  final VoidCallback onTap;

  const CustomIconButton3({
    required this.child,
    required this.color,
    required this.elevation,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: color,
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.all(1.0),
          child: SizedBox(
            child: Container(
              margin: EdgeInsets.all(0.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
