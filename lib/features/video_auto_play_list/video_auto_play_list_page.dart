import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class VideoAutoPlayListPage extends StatefulWidget {
  const VideoAutoPlayListPage({Key? key}) : super(key: key);

  @override
  State<VideoAutoPlayListPage> createState() => _VideoAutoPlayListPageState();
}

class _VideoAutoPlayListPageState extends State<VideoAutoPlayListPage> {
  final GlobalKey _customScrollViewGlobalKey = GlobalKey();
  final GlobalKey _listViewGlobalKey = GlobalKey();
  final _listViewController = ItemScrollController();
  final _listItemPositionsListener = ItemPositionsListener.create();

  BuildContext? _ctx1;

  int _hitIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListViewObserver(
        child: _buildListView(),
        sliverListContexts: () {
          return [if (_ctx1 != null) _ctx1!];
        },
        onObserve: (resultMap) {
          final model = resultMap[_ctx1];
          if (model == null) return;

          print('firstChild.index -- ${model.firstChild.index}');
          print('showing -- ${model.showingChildIndexList}');
        },
        offset: 100,
      ),
      // body: _buildSliverListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ListViewOnceObserveNotification().dispatch(_ctx1);
        },
      ),
    );

    Widget resultWidget = _buildListView();
    // Widget resultWidget = _buildSliverListView();
    // Widget resultWidget = _buildPositionedListView();

    resultWidget = SafeArea(child: resultWidget);
    resultWidget = NotificationListener<ScrollNotification>(
      key: _customScrollViewGlobalKey,
      onNotification: (notification) {
        if (notification.depth != 0) return false;
        if (notification is ScrollEndNotification) {
          _findListViewTargetChild();
        }
        return false;
      },
      child: resultWidget,
    );
    return Scaffold(
      // body: _buildListView(),
      // body: _buildSliverListView(),
      // body: _buildPositionedListView(),
      body: resultWidget,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _findListViewTargetChild();
          // _findSliverLiwTargetChild();
        },
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      key: _listViewGlobalKey,
      padding: EdgeInsets.zero,
      itemCount: 200,
      itemBuilder: (ctx, index) {
        _ctx1 = ctx;
        return _buildListItemView(index);
      },
    );

    return ListView.separated(
      itemBuilder: (ctx, index) {
        return _buildListItemView(index);
      },
      separatorBuilder: (ctx, index) {
        return _buildSeparatorView();
      },
      itemCount: 50,
    );
  }

  Widget _buildListItemView(int index) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 10),
      height: (index % 2 == 0) ? 60 : 40,
      color: _hitIndex == index ? Colors.red : Colors.lightBlueAccent,
      child: Center(
        child: Text(
          "index -- $index",
          style: TextStyle(
            color: _hitIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  _findListViewTargetChild() {
    RenderObject? _obj =
        _customScrollViewGlobalKey.currentContext?.findRenderObject();
    while ((_obj is RenderObjectWithChildMixin) ||
        (_obj is RenderSliverList) ||
        (_obj is ContainerRenderObjectMixin)) {
      if (_obj is RenderSliverList) {
        print('找到');
        break;
      } else if (_obj is RenderObjectWithChildMixin) {
        _obj = _obj.child;
        continue;
      } else if (_obj is ContainerRenderObjectMixin) {
        _obj = _obj.firstChild;
        continue;
      }
    }
    if (_obj is! RenderSliverList) return;
    print('_obj -- $_obj');

    var firstChild = _obj.firstChild;
    if (firstChild == null) return;
    var listViewOffset = _obj.constraints.scrollOffset; // + 100;
    var parentData = firstChild.parentData as SliverMultiBoxAdaptorParentData;
    var index = parentData.index ?? 0;

    var targetChild = firstChild;
    var targetData = targetChild.parentData as SliverMultiBoxAdaptorParentData;
    while (
        listViewOffset > targetChild.size.height + targetData.layoutOffset!) {
      // while (listViewOffset >
      //     targetChild.size.height / 2 + targetData.layoutOffset!) {
      index = index + 1;
      var nextChild = _obj.childAfter(targetChild);
      if (nextChild == null) break;

      // if ((nextChild is RenderObjectWithChildMixin) && (nextChild as RenderObjectWithChildMixin).child is! RenderIndexedSemantics && (nextChild is! RenderIndexedSemantics)) {
      //   nextChild = _obj.childAfter(nextChild);
      // }
      if (nextChild is! RenderIndexedSemantics) {
        // it is separator
        nextChild = _obj.childAfter(nextChild);
      }
      if (nextChild == null) break;
      targetChild = nextChild;
      targetData = targetChild.parentData as SliverMultiBoxAdaptorParentData;
    }
    print("targetChild");

    var newHitIndex = targetData.index ?? 0;
    if (targetChild is RenderIndexedSemantics) {
      newHitIndex = targetChild.index;
    }
    setState(() {
      _hitIndex = newHitIndex;
    });

    return;

    final test = _customScrollViewGlobalKey.currentContext?.findRenderObject();

    var currentContext = _listViewGlobalKey.currentContext;
    if (currentContext == null) return;
    var objc = currentContext.findRenderObject();

    // final childrenDelegate = (currentContext.widget as ListView).childrenDelegate;
    // (childrenDelegate as SliverChildBuilderDelegate).findChildIndexCallback
    // final firstChild = (objc as ContainerRenderObjectMixin).firstChild;
    // print("firstChild -- $firstChild");
    var aa = objc as RenderObject?;
    var bb = objc?.parent as RenderCustomMultiChildLayoutBox?;
    currentContext.visitChildElements((element) {
      var ooo = element.findRenderObject();
      print('element -- $element');
    });
    // var aaa = (aa as ContainerRenderObjectMixin);
    print('aa -- $aa');

    // RenderBox
    // RenderPointerListener
  }

  Widget _buildSliverListView() {
    return CustomScrollView(
      slivers: [
        SliverList(
          key: _listViewGlobalKey,
          delegate: SliverChildBuilderDelegate(
            (ctx, index) {
              return _buildListItemView(index);
            },
            childCount: 10,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, index) {
              return _buildListItemView(index);
            },
            childCount: 10,
          ),
        )
      ],
    );
  }

  _findSliverListViewTargetChild() {
    var currentContext = _listViewGlobalKey.currentContext;
    if (currentContext == null) return;
    var renderObject = currentContext.findRenderObject();
    var obj = renderObject as RenderSliverList;
    var firstChild = renderObject.firstChild;
    if (firstChild == null) return;
    var listViewOffset = obj.constraints.scrollOffset + 100;
    var parentData = firstChild.parentData as SliverMultiBoxAdaptorParentData;
    var index = parentData.index ?? 0;

    var targetChild = firstChild;
    var targetData = targetChild.parentData as SliverMultiBoxAdaptorParentData;
    while (listViewOffset >
        targetChild.size.height / 2 + targetData.layoutOffset!) {
      index = index + 1;
      targetChild = obj.childAfter(targetChild)!;
      targetData = targetChild.parentData as SliverMultiBoxAdaptorParentData;
    }
    print("targetChild");
  }

  Widget _buildPositionedListView() {
    Widget resultWidget = ScrollablePositionedList.separated(
      // key: _listViewGlobalKey,
      itemScrollController: _listViewController,
      itemPositionsListener: _listItemPositionsListener,
      itemCount: 100,
      itemBuilder: (context, index) {
        return _buildListItemView(index);
      },
      separatorBuilder: (context, index) {
        return _buildSeparatorView();
      },
    );
    return resultWidget;
  }

  Container _buildSeparatorView() {
    return Container(
      color: Colors.green,
      height: 2,
    );
  }
}

class ListViewObserver extends StatefulWidget {
  /// 子组件
  final ScrollView child;

  /// SliverList 的 BuildContext
  final List<BuildContext> Function() sliverListContexts;

  /// 监听到
  final Function(Map<BuildContext, ListViewObserverModel>) onObserve;

  /// 计算偏移
  final double offset;

  /// 计算动态偏移（如果存在则以此为主）
  final double Function()? dynamicOffset;

  /// 自身显示的部分超过该百分比时，取下一个child
  final double toNextOverPercent;

  const ListViewObserver({
    Key? key,
    required this.child,
    required this.sliverListContexts,
    required this.onObserve,
    this.offset = 0,
    this.dynamicOffset,
    this.toNextOverPercent = 1,
  })  : assert(toNextOverPercent > 0 && toNextOverPercent <= 1),
        super(key: key);

  @override
  State<ListViewObserver> createState() => _ListViewObserverState();
}

class _ListViewObserverState extends State<ListViewObserver> {
  Map<BuildContext, ListViewObserverModel> lastResultMap = {};

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ListViewOnceObserveNotification>(
      onNotification: (_) {
        _handleContexts();
        return true;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleContexts();
          return false;
        },
        child: widget.child,
      ),
    );
  }

  /// 处理所有的 BuildContext
  _handleContexts() {
    final sliverListContexts = widget.sliverListContexts;
    final ctxs = sliverListContexts();
    Map<BuildContext, ListViewObserverModel> resultMap = {};
    Map<BuildContext, ListViewObserverModel> changeResultMap = {};
    for (var ctx in ctxs) {
      final targetObserveModel = _handleObserve(ctx);
      if (targetObserveModel == null) continue;
      resultMap[ctx] = targetObserveModel;

      final lastResultModel = lastResultMap[ctx];
      if (lastResultModel == null) {
        changeResultMap[ctx] = targetObserveModel;
      } else if (lastResultModel != targetObserveModel) {
        changeResultMap[ctx] = targetObserveModel;
      }

      lastResultMap = resultMap;
    }

    if (changeResultMap.isNotEmpty) {
      widget.onObserve(changeResultMap);
    }
  }

  /// 处理观察 - 主要代码
  ListViewObserverModel? _handleObserve(BuildContext ctx) {
    final _obj = ctx.findRenderObject();
    if (_obj is! RenderSliverList) return null;
    var firstChild = _obj.firstChild;
    if (firstChild == null) return null;

    var offset = widget.offset;
    if (widget.dynamicOffset != null) {
      offset = widget.dynamicOffset!();
    }

    final rawListViewOffset =
        _obj.constraints.scrollOffset + _obj.constraints.overlap;
    var listViewOffset = rawListViewOffset + offset;
    var parentData = firstChild.parentData as SliverMultiBoxAdaptorParentData;
    var index = parentData.index ?? 0;

    // 找出正在显示的第一个child
    var targetFirstChild = firstChild;
    var targetFistChildData =
        targetFirstChild.parentData as SliverMultiBoxAdaptorParentData;

    while (listViewOffset >
        targetFirstChild.size.height * widget.toNextOverPercent +
            (targetFistChildData.layoutOffset ?? 0)) {
      index = index + 1;
      var nextChild = _obj.childAfter(targetFirstChild);
      if (nextChild == null) break;

      if (nextChild is! RenderIndexedSemantics) {
        // it is separator
        nextChild = _obj.childAfter(nextChild);
      }
      if (nextChild == null) break;
      targetFirstChild = nextChild;
      targetFistChildData =
          targetFirstChild.parentData as SliverMultiBoxAdaptorParentData;
    }
    if (targetFirstChild is! RenderIndexedSemantics) return null;

    List<ListViewObserveShowingChildModel> showingChildModelList = [];
    showingChildModelList.add(ListViewObserveShowingChildModel(
      index: targetFirstChild.index,
      renderObject: targetFirstChild,
    ));

    // 找出正在显示的其余child
    var listViewBottomOffset =
        rawListViewOffset + _obj.constraints.remainingPaintExtent;
    var showingChild = _obj.childAfter(targetFirstChild);
    while (showingChild != null &&
        showingChild.parentData is SliverMultiBoxAdaptorParentData &&
        ((showingChild.parentData as SliverMultiBoxAdaptorParentData)
                    .layoutOffset ??
                0) <
            listViewBottomOffset) {
      if (showingChild is! RenderIndexedSemantics) {
        showingChild = _obj.childAfter(showingChild);
        continue;
      }
      showingChildModelList.add(ListViewObserveShowingChildModel(
        index: showingChild.index,
        renderObject: showingChild,
      ));
      showingChild = _obj.childAfter(showingChild);
    }

    return ListViewObserverModel(
      firstChild: ListViewObserveShowingChildModel(
        index: targetFirstChild.index,
        renderObject: targetFirstChild,
      ),
      showingChildModelList: showingChildModelList,
    );
  }
}

/// 通知触发一次观察
class ListViewOnceObserveNotification extends Notification {}

class ListViewObserverModel {
  /// 目标子组件的下标
  final ListViewObserveShowingChildModel firstChild;

  /// 正在显示的子组件的renderObject
  final List<ListViewObserveShowingChildModel> showingChildModelList;

  /// 正在显示的子组件的下标集
  List<int> get showingChildIndexList =>
      showingChildModelList.map((e) => e.index).toList();

  ListViewObserverModel({
    required this.firstChild,
    required this.showingChildModelList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is ListViewObserverModel) {
      return firstChild == other.firstChild &&
          listEquals(showingChildModelList, other.showingChildModelList);
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return firstChild.hashCode + showingChildModelList.hashCode;
  }
}

class ListViewObserveShowingChildModel {
  /// 下标
  final int index;

  /// Render对象
  final RenderBox renderObject;

  ListViewObserveShowingChildModel({
    required this.index,
    required this.renderObject,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is ListViewObserveShowingChildModel) {
      return index == other.index && renderObject == other.renderObject;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return index + renderObject.hashCode;
  }
}
