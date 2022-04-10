import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MaskPage extends StatefulWidget {
  const MaskPage({Key? key}) : super(key: key);

  @override
  State<MaskPage> createState() => _MaskPageState();
}

class _MaskPageState extends State<MaskPage> {
  OverlayEntry? overlayEntry;

  final observeScrollGlobalKey = GlobalKey();

  final maskTargetGlobalKey = GlobalKey();

  final listViewController = ItemScrollController();
  final listItemPositionsListener = ItemPositionsListener.create();

  ScrollMetrics? listViewMetrics;

  double appBarHeight = AppBar().preferredSize.height;
  double safeAreaTopHeight = 0;

  @override
  void initState() {
    super.initState();

    listItemPositionsListener.itemPositions.addListener(() {
      _observeScroll();
    });
  }

  @override
  void dispose() {
    super.dispose();
    listItemPositionsListener.itemPositions.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    safeAreaTopHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(title: const Text("遮罩")),
      body: _buildListView(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        debugPrint(
            "itemPositions -- ${listItemPositionsListener.itemPositions.value}");
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    Widget resultWidget = ScrollablePositionedList.separated(
      itemScrollController: listViewController,
      itemPositionsListener: listItemPositionsListener,
      itemCount: 100,
      itemBuilder: (context, index) {
        Key? key;
        if (index == 16) {
          key = observeScrollGlobalKey;
        } else if (index == 20) {
          key = maskTargetGlobalKey;
        }
        return ListTile(
          title: Text("$index"),
          key: key,
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          color: Colors.grey,
          height: 0.5,
          margin: const EdgeInsets.symmetric(horizontal: 10),
        );
      },
    );
    resultWidget = NotificationListener<ScrollNotification>(
      child: resultWidget,
      onNotification: (notification) {
        listViewMetrics = notification.metrics;
        return false;
      },
    );
    return resultWidget;
  }

  void _observeScroll() {
    var renderBox = observeScrollGlobalKey.currentContext?.findRenderObject();
    if (renderBox is RenderBox?) {
      var globalOffsetY = appBarHeight + safeAreaTopHeight;
      var offset = renderBox?.localToGlobal(Offset(0, -globalOffsetY));
      if (offset == null) {
        return;
      }
      var _listViewMetrics = listViewMetrics;
      if (_listViewMetrics == null) {
        return;
      }
      double cellOffsetY = offset.dy;
      if (cellOffsetY >= 0) {
        return;
      }

      debugPrint("cellOffsetY -- $cellOffsetY");
      // 滚动指定下标模块(alignment可设置偏移系数，依据listview的高度，范围[-1.0, 1.0])
      // listViewController.jumpTo(index: 16, alignment: 0.1);
      listViewController.jumpTo(index: 16);
      Future.delayed(const Duration(milliseconds: 100), () {
        _showMask();
      });
    }
  }

  void _showMask() {
    if (overlayEntry != null) {
      return;
    }
    Size size = Size.zero;
    Offset offset = Offset.zero;
    var renderBox = maskTargetGlobalKey.currentContext?.findRenderObject();
    if (renderBox is RenderBox?) {
      var _size = renderBox?.size;
      var _offset = renderBox?.localToGlobal(Offset.zero);
      if (_size == null || _offset == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("目标cell不在显示范围内"),
          ),
        );
        return;
      }
      size = _size;
      offset = _offset;

      var _listViewMetrics = listViewMetrics;
      if (_listViewMetrics == null) {
        return;
      }

      // debugPrint("extentBefore -- ${_listViewMetrics.extentBefore}");
      // debugPrint("extentInside -- ${_listViewMetrics.extentInside}");
      // debugPrint("extentAfter -- ${_listViewMetrics.extentAfter}");
      // debugPrint("offset -- $offset : $size");
      // debugPrint("topHeight -- $appBarHeight : $safeAreaTopHeight");

      double safeAreaTopHeight = MediaQuery.of(context).padding.top;
      double cellOffsetY = offset.dy - appBarHeight - safeAreaTopHeight;
      if (cellOffsetY < 0 || cellOffsetY > _listViewMetrics.extentInside) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("目标cell不在显示范围内"),
          ),
        );
        return;
      }
    }
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.red.withOpacity(0.8),
                  BlendMode.srcOut,
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        // 任何颜色均可
                        color: Colors.white,
                        backgroundBlendMode: BlendMode.dstOut,
                      ),
                    ),
                    Positioned(
                      top: offset.dy - 80,
                      child: Container(
                        decoration: const BoxDecoration(
                          /// 任何颜色均可
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        width: 150,
                        height: size.height,
                      ),
                    ),
                    Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      child: Container(
                        decoration: const BoxDecoration(
                          /// 任何颜色均可
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        width: size.width,
                        height: size.height,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: offset.dy + 100,
                child: GestureDetector(
                  onTap: () {
                    overlayEntry?.remove();
                    overlayEntry = null;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.white,
                    child: const Text(
                      "知道了",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context)?.insert(overlayEntry!);
  }
}
