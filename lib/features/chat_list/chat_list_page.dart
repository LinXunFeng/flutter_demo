import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({Key? key}) : super(key: key);
  final GlobalKey centerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView(
      //   reverse: true,
      //   children: [
      //     ListTile(title: Text('0')),
      //     ListTile(title: Text('1')),
      //     ListTile(title: Text('2')),
      //     ListTile(title: Text('3')),
      //     ListTile(title: Text('4')),
      //     ListTile(title: Text('5')),
      //     ListTile(title: Text('6')),
      //     ListTile(title: Text('7')),
      //     ListTile(title: Text('8')),
      //     ListTile(title: Text('9')),
      //     ListTile(title: Text('11')),
      //     ListTile(title: Text('12')),
      //     ListTile(title: Text('13')),
      //     ListTile(title: Text('14')),
      //     ListTile(title: Text('15')),
      //     ListTile(title: Text('16')),
      //     ListTile(title: Text('17')),
      //     ListTile(title: Text('18')),
      //     ListTile(title: Text('19')),
      //   ],
      // ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(), //The bouncing could be removed
        center: centerKey,
        slivers: [
          _buildSliver(20),
          SliverPadding(padding: EdgeInsets.zero, key: centerKey),
          _buildSliver(0),
        ],
      ),
    );
  }

  SliverList _buildSliver(int childCount) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, index) {
          return Container(
            height: 80,
            color: Colors.red,
            child: Center(
              child: Text(
                "index -- $index",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        childCount: childCount,
      ),
    );
  }
}
