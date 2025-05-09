import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool lightOn = true;
  final gradient = const [
    Color(0xFF696969),
    Color(0xFF484848),
    Color(0xFF3D3D3D)
  ];
  double get lh => 600;
  static const Size lampSize = Size(600 * 0.60, 600);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * .6;

    return Scaffold(
      backgroundColor: const Color(0XFF383838),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.all(24),
              height: size.width * .9,
              width: size.width * .5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0XFF4E4E4E),
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0XFF2D2D2D),
                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        lightOn = !lightOn;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: lightOn
                            ? const EdgeInsets.only(top: 20)
                            : const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF6F6F6F), width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors:
                                lightOn ? gradient : gradient.reversed.toList(),
                            stops: const [0, 0.5, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3D3D3D),
                              offset: Offset(0, lightOn ? -8 : 8),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      right: 15,
                      top: lightOn ? 35 : 15,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightOn
                              ? const Color(0xFF36EA69)
                              : const Color(0xFFE84A36),
                          boxShadow: [
                            BoxShadow(
                              color: lightOn
                                  ? const Color(0XFF43A45D)
                                  : const Color(0XFF9B4236),
                              offset: const Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            lampview()
          ],
        ),
      ),
    );
  }

  Widget lampview() {
    double topSize = lampSize.width * .5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipShadowPath(
          shadow: BoxShadow(
              color:
                  lightOn ? Colors.yellow.withOpacity(1) : Colors.transparent,
              blurRadius: 20,
              offset: const Offset(0, 5),
              spreadRadius: 2),
          clipper: MyCustomClipper(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: topSize * .8,
            width: topSize,
            decoration: BoxDecoration(
              color: lightOn
                  ? Colors.amber.withOpacity(1)
                  : Colors.white.withOpacity(.4),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: lampSize.height * .4,
          width: lampSize.width * .05,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: lightOn
                      ? [
                          Colors.yellow.withOpacity(.8),
                          Colors.yellow.withOpacity(.3)
                        ]
                      : [
                          Colors.white.withOpacity(.1),
                          Colors.white.withOpacity(.8)
                        ])),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: lampSize.width * .3,
          height: lampSize.width * .05,
          decoration: BoxDecoration(
              boxShadow: !lightOn
                  ? null
                  : [
                      BoxShadow(
                          color: Colors.yellow.withOpacity(.2),
                          blurRadius: 2,
                          spreadRadius: 0.5)
                    ],
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: lightOn
                      ? [
                          Colors.white.withOpacity(.2),
                          Colors.white.withOpacity(.4)
                        ]
                      : [
                          Colors.white.withOpacity(.6),
                          Colors.white.withOpacity(.2)
                        ])),
        )
      ],
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final double shadowWidth;
  final Color shadowColor;
  final double shadowBlur;

  MyCustomClipper({
    this.shadowWidth = 10.0,
    this.shadowColor = Colors.yellow,
    this.shadowBlur = 10.0,
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    double trimTop = size.width * 0.15;
    path.moveTo(trimTop, 0);
    path.lineTo(size.width - trimTop, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    var shadowPath = Path();
    shadowPath.moveTo(size.width, size.height - shadowWidth);
    shadowPath.lineTo(size.width, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.lineTo(0, size.height - shadowWidth);

    path = Path.combine(
        PathOperation.union, path, Path()..addPath(shadowPath, Offset.zero));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
