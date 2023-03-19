import 'package:flutter/material.dart';
import 'package:flutter_demo/features/chat_list/chat_list_page.dart';
import 'package:flutter_demo/features/column_gap/column_gap_page.dart';
import 'package:flutter_demo/features/inner_shadow/inner_shadow_page.dart';
import 'package:flutter_demo/features/list_cover_bg/list_cover_bg_page.dart';
import 'package:flutter_demo/features/mask/mask_page.dart';
import 'package:flutter_demo/features/nested_scrollview/nested_scrollview_page.dart';
import 'package:flutter_demo/features/photo_browser/photo_page.dart';
import 'package:flutter_demo/features/sticky_menu/sticky_menu_page.dart';
import 'package:flutter_demo/features/chat_text_field/chat_text_field_page.dart';
import 'package:flutter_demo/features/vertical_flip/vertical_flip_page.dart';
import 'package:flutter_demo/features/video_auto_play_list/video_auto_play_list_page.dart';

enum HomeListRowType {
  // 遮罩
  mask,
  // 大图游览
  photoBrowse,
  // 上下翻页
  verticalFlip,
  // 吸顶菜单
  stickyMenu,
  // 视频自动播放列表
  videoAutoPlayList,
  // 嵌套滚动视图
  nestedScrollView,
  // 内阴影
  innetShadow,
  // 列表视图中的背景覆盖
  listCoverBg,
  // 聊天列表
  chatList,
  // 聊天输入框
  chatTextField,
  // Column缝隙
  columnGap,
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<HomeListRowType> rowTypeArr = [
    HomeListRowType.columnGap,
    HomeListRowType.mask,
    HomeListRowType.photoBrowse,
    HomeListRowType.verticalFlip,
    HomeListRowType.stickyMenu,
    HomeListRowType.videoAutoPlayList,
    HomeListRowType.nestedScrollView,
    HomeListRowType.innetShadow,
    HomeListRowType.listCoverBg,
    HomeListRowType.chatList,
    HomeListRowType.chatTextField,
  ];

  @override
  Widget build(BuildContext context) {
    var rowDataArr = _buildListViewRows(context);
    return Scaffold(
      appBar: AppBar(title: const Text("LXF Flutter Demo")),
      body: ListView.separated(
        itemCount: rowDataArr.length,
        itemBuilder: (context, index) {
          return rowDataArr[index];
        },
        separatorBuilder: (context, index) {
          return Container(color: Colors.grey, height: 0.5);
        },
      ),
    );
  }

  List<Widget> _buildListViewRows(
    BuildContext context,
  ) {
    return rowTypeArr.map((type) {
      String title = '';
      Widget page;
      switch (type) {
        case HomeListRowType.columnGap:
          title = 'Column缝隙';
          page = const ColumnGapPage();
          break;
        case HomeListRowType.mask:
          title = '遮罩';
          page = const MaskPage();
          break;
        case HomeListRowType.photoBrowse:
          title = '大图浏览';
          page = PhotoPage();
          break;
        case HomeListRowType.verticalFlip:
          title = '上下翻页';
          page = VerticalFlipPage();
          break;
        case HomeListRowType.stickyMenu:
          title = '吸顶菜单';
          page = const StickyMenuPage();
          break;
        case HomeListRowType.videoAutoPlayList:
          title = '视频自动播放列表';
          page = const VideoAutoPlayListPage();
          break;
        case HomeListRowType.nestedScrollView:
          title = 'NestedScrollView';
          page = const NestedScrollViewPage();
          break;
        case HomeListRowType.innetShadow:
          title = '内阴影';
          page = const InnerShadowPage();
          break;
        case HomeListRowType.listCoverBg:
          title = '列表视图中的背景覆盖';
          page = const ListCoverBgPage();
          break;
        case HomeListRowType.chatList:
          title = '聊天列表页';
          page = ChatListPage();
          break;
        case HomeListRowType.chatTextField:
          title = '聊天输入框';
          page = const ChatTextFieldPage();
          break;
      }
      return ListTile(
        title: Text(title),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return page;
              },
            ),
          );
        },
      );
    }).toList();
  }
}
