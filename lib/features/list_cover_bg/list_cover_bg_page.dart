import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

BuildContext? testCtx;

Widget? viewport;

class ListCoverBgPage extends StatelessWidget {
  const ListCoverBgPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('背景覆盖')),
      body: LXFCustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 100)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                testCtx = context;
                return ListTile(
                  title: Text('index -- $index'),
                );
              },
              childCount: 12,
            ),
          ),
          LXFSliverBanner(
            child: Container(
              clipBehavior: Clip.none,
              height: double.minPositive,
              color: Colors.orange,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 120,
                    child: Container(
                      height: 120,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.abc),
        onPressed: () {
          if (testCtx != null) {
            // (testCtx as SliverMultiBoxAdaptorElement);
            final obj = testCtx!.findRenderObject() as RenderSliver;
            final parentObj = obj.parent as RenderViewport;

            // final aa = viewport.;
            // debugPrint('obj1 -- ${obj.depth} -- $depth');
            // obj.redepthChild(obj);
            // obj.redepthChild(obj);
            // (obj.parent as RenderObject).markNeedsLayout();
            // MultiChildRenderObjectElement
            debugPrint('obj2 -- ${obj.depth}');
          }
        },
      ),
    );
  }
}

class LXFCustomScrollView extends CustomScrollView {
  const LXFCustomScrollView({
    Key? key,
    List<Widget> slivers = const <Widget>[],
  }) : super(
          key: key,
          slivers: slivers,
        );

  @override
  Widget buildViewport(BuildContext context, ViewportOffset offset,
      AxisDirection axisDirection, List<Widget> slivers) {
    final widget = super.buildViewport(context, offset, axisDirection, slivers);
    viewport = widget;
    return widget;
  }
}

class LXFSliverBanner extends SingleChildRenderObjectWidget {
  const LXFSliverBanner({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  LXFRenderSliverBanner createRenderObject(BuildContext context) {
    return LXFRenderSliverBanner(ctx: context);
  }
}

class LXFRenderSliverBanner extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a [RenderBox].
  LXFRenderSliverBanner({
    required this.ctx,
    RenderBox? child,
  }) : super(child: child);

  BuildContext ctx;

  @override
  void performLayout() {
    final viewport = _findViewport(ctx.findRenderObject() as RenderSliver);
    final pixels = viewport?.offset.pixels ?? 0;

    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    assert(childExtent != null);
    // final double childExtent = 0;
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);
    // final double paintedChildSize = 0;
    // final double cacheExtent = 0;
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    print('paintedChildSize -- $paintedChildSize');

    geometry = SliverGeometry(
      // paintOrigin: -706 + constraints.scrollOffset,
      paintOrigin: (paintedChildSize > 0
              ? (-constraints.precedingScrollExtent)
              : -constraints.viewportMainAxisExtent) -
          pixels,
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: false,
      visible: true,
    );

    setChildParentData(child!, constraints, geometry!);
  }
}

/// Find out the viewport
RenderViewport? _findViewport(RenderSliver obj) {
  int maxCycleCount = 10;
  int currentCycleCount = 1;
  AbstractNode? parent = obj.parent;
  while (parent != null && currentCycleCount <= maxCycleCount) {
    if (parent is RenderViewport) {
      return parent;
    }
    parent = parent.parent;
    currentCycleCount++;
  }
  return null;
}
