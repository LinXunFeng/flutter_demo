import 'package:flutter/material.dart';

class MaskPage extends StatelessWidget {
  OverlayEntry? overlayEntry;
  final globalKey = GlobalKey();

  ScrollMetrics? listViewMetrics;
  double appBarHeight = AppBar().preferredSize.height;

  MaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("遮罩")),
      body: _buildListView(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        _showMask(context);
      },
    );
  }

  Widget _buildListView() {
    Widget resultWidget = ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("$index"),
          key: index == 20 ? globalKey : null,
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

  void _showMask(BuildContext context) {
    Size size = Size.zero;
    Offset offset = Offset.zero;
    var renderBox = globalKey.currentContext?.findRenderObject();
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
        return Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.red.withOpacity(0.8),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      /// 任何颜色均可
                      color: Colors.white,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Positioned(
                    left: offset.dx,
                    top: offset.dy,
                    child: Container(
                      decoration: const BoxDecoration(
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
              left: offset.dx,
              top: offset.dy + 100,
              child: GestureDetector(
                onTap: () {
                  overlayEntry?.remove();
                },
                child: Container(
                  height: size.height,
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: const Text("知道了", style: TextStyle(fontSize: 20, color: Colors.black),),
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context)?.insert(overlayEntry!);
  }
}
