import 'package:flutter/material.dart';

class MainCirclesBackground extends StatefulWidget {
  final Widget title;
  final Color backgroundColor;
  final double position;
  final int duration;
  final Widget base;

  const MainCirclesBackground({
    super.key,
    required this.title,
    this.backgroundColor = Colors.orange ,
    this.position = -930,
    this.duration = 300,
    required this.base,
  });

  @override
  State<MainCirclesBackground> createState() => _MainCirclesBackgroundState();
}

class _MainCirclesBackgroundState extends State<MainCirclesBackground> {
  double opacity = 0.0;
  double position = -1000;
  @override
  void initState() {
    super.initState();
    loadAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 80, 8, 0),
            child: widget.base,
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: widget.duration),
          top: position,
          right: -300,
          left: -300,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: widget.duration),
            opacity: opacity,
            child: Container(
              width: 1000,
              height: 1000,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(500),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [widget.title],
              ),
            ),
          ),
        ),
      ],
    );
  }

  loadAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      position = widget.position;
      opacity = 1;
    });
  }
}
