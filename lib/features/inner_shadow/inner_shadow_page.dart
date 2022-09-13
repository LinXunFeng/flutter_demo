import 'package:flutter/material.dart';

class InnerShadowPage extends StatelessWidget {
  const InnerShadowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('内阴影')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: const FooDecoration(
                inner: true,
                color: Colors.red,
                blurRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FooDecoration extends Decoration {
  final EdgeInsets insets;
  final Color color;
  final double blurRadius;
  final bool inner;

  const FooDecoration({
    this.insets = const EdgeInsets.all(12),
    this.color = Colors.black,
    this.blurRadius = 8,
    this.inner = false,
  });
  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _FooBoxPainter(insets, color, blurRadius, inner);
  }
}

class _FooBoxPainter extends BoxPainter {
  final EdgeInsets insets;
  final Color color;
  final double blurRadius;
  final bool inner;

  _FooBoxPainter(
    this.insets,
    this.color,
    this.blurRadius,
    this.inner,
  );

  @override
  void paint(
    Canvas canvas,
    Offset offset,
    ImageConfiguration configuration,
  ) {
    var rect = offset & (configuration.size ?? Size.zero);
    canvas.clipRect(rect);
    var paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(
        BlurStyle.outer,
        blurRadius,
      );

    var path = Path();
    if (inner) {
      path
        ..fillType = PathFillType.evenOdd
        ..addRect(insets.inflateRect(rect))
        ..addRect(rect);
    } else {
      path.addRect(insets.deflateRect(rect));
    }
    canvas.drawPath(path, paint);
  }
}
