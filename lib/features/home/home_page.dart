import 'package:flutter/material.dart';
import 'package:flutter_demo/features/mask/mask_page.dart';
import 'package:flutter_demo/features/photo_browser/photo_page.dart';
import 'package:tuple/tuple.dart';

enum HomeListRowType {
  /// 遮罩
  mask,
  /// 大图游览
  photoBrowse
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rowDataArr = _buildListViewRows(context);
    return Scaffold(
      appBar: AppBar(title: const Text("LXF Flutter Demo")),
      body: ListView.separated(
        itemCount: rowDataArr.length,
        itemBuilder: (context, index) {
          return rowDataArr[index].item2;
        },
        separatorBuilder: (context, index) {
          return Container(color: Colors.grey, height: 0.5);
        },
      ),
    );
  }

  List<Tuple2<HomeListRowType, Widget>> _buildListViewRows(
    BuildContext context,
  ) {
    return [
      Tuple2<HomeListRowType, Widget>(
        HomeListRowType.mask,
        ListTile(
          title: const Text("遮罩"),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const MaskPage();
                },
              ),
            );
          },
        ),
      ),
      Tuple2<HomeListRowType, Widget>(
        HomeListRowType.photoBrowse,
        ListTile(
          title: const Text("大图浏览"),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return PhotoPage();
                },
              ),
            );
          },
        ),
      )
    ];
  }
}
