import 'package:flutter/material.dart';
import 'package:flutter_demo/features/mask/mask_page.dart';
import 'package:tuple/tuple.dart';

enum HomeListRowType {
  mask,
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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
                  return MaskPage();
                },
              ),
            );
          },
        ),
      )
    ];
  }
}
