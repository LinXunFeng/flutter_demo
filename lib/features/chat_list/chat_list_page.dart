import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_demo/features/chat_list/model/chat_list_model.dart';

BuildContext? listViewContext;

bool isAdd = false;

class ChatListPage extends StatefulWidget {
  ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  ScrollController scrollController = ScrollController();
  double screenWidth = 0;
  final random = Random();

  List<String> chatContents = [
    'My name is LinXunFeng',
    'Twitter: https://twitter.com/xunfenghellolo'
        'Github: https://github.com/LinXunFeng',
    'Blog: https://fullstackaction.com/',
    'Juejin: https://juejin.cn/user/1820446984512392/posts',
    'Artile: Flutter-获取ListView当前正在显示的Widget信息\nhttps://juejin.cn/post/7103058155692621837',
    'Artile: Flutter-列表滚动定位超强辅助库，墙裂推荐！🔥\nhttps://juejin.cn/post/7129888644290068487',
    'A widget for observing data related to the child widgets being displayed in a scrollview.\nhttps://github.com/LinXunFeng/flutter_scrollview_observer',
    '📱 Swifty screen adaptation solution (Support Objective-C and Swift)\nhttps://github.com/LinXunFeng/SwiftyFitsize'
  ];

  List<ChatModel> chatModels = [];

  GlobalKey centerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    chatModels = createChatModels();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 7, 7),
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        actions: [
          IconButton(
            onPressed: () {
              final aaa = listViewContext;
              final obj = (aaa?.findRenderObject() as RenderSliverList);
              final firstChild = obj.firstChild!;
              isAdd = true;
              setState(() {
                chatModels.insert(0, createChatModel());
              });
            },
            icon: const Icon(Icons.add_comment),
          )
        ],
      ),
      body: SafeArea(child: _buildListView()),
    );
  }

  Widget _buildListView() {
    Widget resultWidget = ListView.builder(
      physics: const AllwaysScrollableFixedPositionScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      // reverse: true,
      controller: scrollController,
      itemBuilder: ((context, index) {
        listViewContext = context;
        return _buildChatRow(index);
      }),
      itemCount: chatModels.length,
    );
    resultWidget = NotificationListener<ScrollNotification>(
      child: resultWidget,
      onNotification: (notification) {
        return false;
      },
    );
    return resultWidget;
  }

  Widget _buildChatRow(int index) {
    final chatModel = chatModels[index];
    final isOwn = chatModel.isOwn;
    final nickName = isOwn ? 'LXF' : 'LQR';
    Widget resultWidget = Row(
      textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Text(nickName, style: const TextStyle(color: Colors.white)),
          backgroundColor: isOwn ? Colors.blue : Colors.white30,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isOwn
                  ? const Color.fromARGB(255, 21, 125, 200)
                  : const Color.fromARGB(255, 39, 39, 38),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '------------ $index ------------ \n ${chatModel.content}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 50),
      ],
    );
    resultWidget = Column(
      children: [resultWidget, const SizedBox(height: 15)],
    );
    return resultWidget;
  }

  List<ChatModel> createChatModels({int num = 30}) {
    return Iterable<int>.generate(num).map((e) => createChatModel()).toList();
  }

  ChatModel createChatModel() {
    final content = chatContents[random.nextInt(chatContents.length)];
    return ChatModel(isOwn: random.nextBool(), content: content);
  }
}

class AllwaysScrollableFixedPositionScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that always lets the user scroll.
  const AllwaysScrollableFixedPositionScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  AllwaysScrollableFixedPositionScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AllwaysScrollableFixedPositionScrollPhysics(
        parent: buildParent(ancestor));
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    final value = super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );

    if (isAdd) {
      isAdd = false;

      final aaa = listViewContext;
      final obj = (aaa?.findRenderObject() as RenderSliverList);
      final secondChild = obj.childAfter(obj.firstChild!);
      final offset =
          (secondChild?.parentData as SliverMultiBoxAdaptorParentData)
                  .layoutOffset ??
              0;
      print('value -- $value -- $offset');
      return value + offset;
    }

    print('value -- $value');
    return value;

    if (newPosition.extentBefore == 0) {
      return super.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: isScrolling,
        velocity: velocity,
      );
    }
    return newPosition.maxScrollExtent - oldPosition.extentAfter;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}
