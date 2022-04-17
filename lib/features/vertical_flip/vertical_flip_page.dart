import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/color_utils.dart';

enum VerticalFlipShowingType {
  aaa,
  bbb,
}

class VerticalFlipPage extends StatefulWidget {
  VerticalFlipPage({Key? key}) : super(key: key);

  @override
  State<VerticalFlipPage> createState() => _VerticalFlipPageState();
}

class _VerticalFlipPageState extends State<VerticalFlipPage> {
  final ScrollController scrollController = ScrollController();
  final double headerFlipThreshold = 50;
  final double headerFlipHeightA = 400;
  final double headerFlipHeightB = 250;

  /// header翻页视图的总高
  double get headerFlipHeight => headerFlipHeightA + headerFlipHeightB;

  /// 当前header翻页视图显示的视图类型
  VerticalFlipShowingType headerFlipShowingType = VerticalFlipShowingType.aaa;

  /// 是否是从最顶部开始滚动的
  bool isStartScrollAtTop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _handleListScroll(notification);
          return false; // return true 会导致进度条将失效
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(child: _buildHeaderWidget()),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  return ListTile(title: Text("index -- $index"));
                },
                childCount: 40,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            headerFlipShowingType =
                headerFlipShowingType == VerticalFlipShowingType.aaa
                    ? VerticalFlipShowingType.bbb
                    : VerticalFlipShowingType.aaa;
          });
        },
        child: const Icon(Icons.wifi_protected_setup),
      ),
    );
  }

  Widget _buildHeaderWidget() {
    var duration = const Duration(milliseconds: 200);
    // AnimatedContainer A
    return AnimatedContainer(
      duration: duration,
      height: headerFlipShowingType == VerticalFlipShowingType.aaa
          ? headerFlipHeightA
          : headerFlipHeightB,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: headerFlipHeight,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // AnimatedContainer B
                AnimatedContainer(
                  duration: duration,
                  height: headerFlipShowingType == VerticalFlipShowingType.aaa
                      ? headerFlipHeightB
                      : 0,
                ),
                SizedBox(
                  height: headerFlipHeightA,
                  child: const HeaderFlipWidget(
                    text: "AAA",
                    color: Color(0xFFFA5252),
                  ),
                ),
                SizedBox(
                  height: headerFlipHeightB,
                  child: const HeaderFlipWidget(
                    text: "BBB",
                    color: Color(0xFF228BE6),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleListScroll(ScrollNotification notification) {
    var offset = notification.metrics.pixels;
    if (notification is ScrollStartNotification) {
      isStartScrollAtTop = offset == 0;
    } else {
      if (headerFlipShowingType == VerticalFlipShowingType.aaa) {
        if (offset > headerFlipThreshold) {
          setState(() {
            headerFlipShowingType = VerticalFlipShowingType.bbb;
          });
          scrollController.jumpTo(0);
        }
      } else {
        if (!isStartScrollAtTop) {
          return;
        }
        if (offset < -headerFlipThreshold) {
          setState(() {
            headerFlipShowingType = VerticalFlipShowingType.aaa;
          });
          scrollController.jumpTo(0);
        }
      }
    }
  }
}

class HeaderFlipWidget extends StatelessWidget {
  final String text;
  final Color? color;

  const HeaderFlipWidget({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? ColorUtils.getRandomColor(),
      child: Center(
        child: Text(
          text,
          textScaleFactor: 5,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
