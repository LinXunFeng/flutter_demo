import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PageViewPage extends StatefulWidget {
  const PageViewPage({Key? key}) : super(key: key);

  @override
  State<PageViewPage> createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> {
  int _lastReportedPage = 0;

  double perPageSize = 337;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageView'),
      ),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    Widget resultWidget = ListView.separated(
      physics: LXFPageScrollPhysics(perPageSize: perPageSize),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          height: 232,
          width: 327,
          color: Colors.amber,
          child: Center(child: Text('index - $index')),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10);
      },
      itemCount: 4,
    );
    resultWidget = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth == 0 &&
            // widget.onPageChanged != null &&
            notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          final pixels = metrics.pixels;
          final minScrollExtent = metrics.minScrollExtent;
          final maxScrollExtent = metrics.maxScrollExtent;
          double page = math.max(
                  0.0, clampDouble(pixels, minScrollExtent, maxScrollExtent)) /
              math.max(1.0, perPageSize);

          final int currentPage = page.round();
          if (currentPage != _lastReportedPage) {
            _lastReportedPage = currentPage;
            // widget.onPageChanged!(currentPage);
            debugPrint('current page -- $currentPage');
          }
        }
        return false;
      },
      child: resultWidget,
    );
    resultWidget = SizedBox(height: 232, child: resultWidget);
    return resultWidget;
  }
}

class LXFPageScrollPhysics extends PageScrollPhysics {
  final double perPageSize;

  const LXFPageScrollPhysics({
    parent,
    required this.perPageSize,
  }) : super(parent: parent);

  @override
  LXFPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LXFPageScrollPhysics(
      parent: buildParent(ancestor),
      perPageSize: perPageSize,
    );
  }

  double _getPage(ScrollMetrics position) {
    return position.pixels / perPageSize;
  }

  double _getPixels(ScrollMetrics position, double page) {
    return page * perPageSize;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = this.tolerance;
    double targetPixels = _getTargetPixels(position, tolerance, velocity);
    targetPixels = math.min(targetPixels, position.maxScrollExtent);
    double currentPixels = math.min(position.pixels, position.maxScrollExtent);
    if (targetPixels != currentPixels) {
      return ScrollSpringSimulation(
        spring,
        currentPixels,
        targetPixels,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }
}
