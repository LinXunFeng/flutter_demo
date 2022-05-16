import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_demo/widgets/sliver_header_delegate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StickyMenuPage extends StatefulWidget {
  const StickyMenuPage({Key? key}) : super(key: key);

  @override
  State<StickyMenuPage> createState() => _StickyMenuPageState();
}

class _StickyMenuPageState extends State<StickyMenuPage> {
  /// 导航栏高度
  final double _navContentHeight = 44;

  /// 筛选菜单的高度
  final double _menuViewHeight = 44;

  /// banner的高度
  final double _bannerViewHeight = 200;

  double get _headerViewHeight => _menuViewHeight + _bannerViewHeight;

  double _navBgAlpha = 0;

  bool _isShowNavTitle = false;

  final ScrollController _pageController = ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  double _bottomPadding = 0;

  final _sliverListGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageDidScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.removeListener(_pageDidScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification.depth == 0) {
                var minScrollExtent = notification.metrics.minScrollExtent;
                var maxScrollExtent = notification.metrics.maxScrollExtent;
                var extentInside = notification.metrics.extentInside;
                var viewportDimension = notification.metrics.viewportDimension;
                var extentAfter = notification.metrics.extentAfter;

                print("minScrollExtent -- $minScrollExtent");
                print("maxScrollExtent -- $maxScrollExtent");
                print("extentInside -- $extentInside");
                print("viewportDimension -- $viewportDimension");
                print("extentAfter -- $extentAfter");
              }
              return false;
            },
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: false,
              enablePullUp: false,
              child: CustomScrollView(
                controller: _pageController,
                slivers: [
                  _buildSliverPersistentHeader(context),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: _bottomPadding),
                    sliver: _buildContentSliverList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(_navBgAlpha),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SafeArea(
                  bottom: false,
                  child: _buildNavContentWidget(context),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // final mq = MediaQuery.of(context);
          // _pageController.animateTo(
          //   _bannerViewHeight - mq.padding.top - _navContentHeight,
          //   duration: const Duration(milliseconds: 250),
          //   curve: Curves.easeIn,
          // );

          var renderObj = _sliverListGlobalKey.currentContext?.findRenderObject();
          if (renderObj == null) return;
          if (renderObj is! RenderSliverList) return;
          var constraints = renderObj.constraints;
          var geometry = renderObj.geometry;
          double contentSize = geometry?.scrollExtent ?? 0;
          double listViewHeight = geometry?.paintExtent ?? 0;
          contentSize - listViewHeight;
          final navAndMenuDistance = _getNavAndMenuDistance();
          if (contentSize > listViewHeight) {
            var padding = contentSize - listViewHeight;
            if (padding < navAndMenuDistance) {
              setState(() {
                _bottomPadding = navAndMenuDistance - padding;
              });
            } else {
              setState(() {
                _bottomPadding = 0;
              });
            }
          } else {
            final mq = MediaQuery.of(context);
            setState(() {
              _bottomPadding = mq.size.height -
                  constraints.precedingScrollExtent -
                  listViewHeight +
                  navAndMenuDistance;
            });
          }
        },
      ),
    );
  }

  /// 导航栏内容
  Widget _buildNavContentWidget(BuildContext context) {
    return Container(
      height: _navContentHeight,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: _isShowNavTitle ? Colors.black : Colors.white,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                "LinXunFeng",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54.withOpacity(
                    _isShowNavTitle ? 1 : 0,
                  ),
                ),
              ),
            ),
          ),
          Icon(
            Icons.share_rounded,
            color: _isShowNavTitle ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }

  /// header视图
  SliverPersistentHeader _buildSliverPersistentHeader(BuildContext context) {
    final mq = MediaQuery.of(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverHeaderDelegate(
        maxHeight: _headerViewHeight,
        minHeight: mq.padding.top + _navContentHeight + _menuViewHeight,
        child: SizedBox(
          height: _headerViewHeight,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: _bannerViewHeight,
                        color: Colors.purple,
                        child: const Center(
                          child: Text(
                            "I am banner",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: _menuViewHeight,
                color: Colors.blue,
                child: Row(
                  children: [
                    _buildMenuItem("AAA"),
                    _buildMenuItem("BBB"),
                    _buildMenuItem("CCC"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 内容列表
  SliverList _buildContentSliverList() {
    return SliverList(
      key: _sliverListGlobalKey,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(title: Text("index -- $index"));
        },
        childCount: 2,
      ),
    );
  }

  /// 菜单item
  Widget _buildMenuItem(String title) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          const Icon(Icons.arrow_drop_down),
          Container(
            height: double.infinity,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  double _getNavAndMenuDistance() {
    final mq = MediaQuery.of(context);
    return _bannerViewHeight - mq.padding.top - _navContentHeight;
  }

  void _pageDidScroll() {
    final offset = _pageController.offset;
    final _navAndMenuDistance = _getNavAndMenuDistance();
    double _newNavBgAlpha = 0;
    if (offset < 0) {
      // 到顶下拉
      _newNavBgAlpha = 0;
    } else if (offset >= _navAndMenuDistance) {
      // 已经上拉超过阈值
      _newNavBgAlpha = 1;
    } else {
      _newNavBgAlpha = offset / _navAndMenuDistance;
    }
    if (_navBgAlpha != _newNavBgAlpha) {
      setState(() {
        _navBgAlpha = _newNavBgAlpha;
        _isShowNavTitle = _navBgAlpha > .5;
      });
    }
  }
}
