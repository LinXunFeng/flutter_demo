import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/features/photo_browser/photo_browser_page.dart';

class PhotoPage extends StatelessWidget {
  final List<String> urlStrArr = [
    "https://c-ssl.duitang.com/uploads/blog/202204/10/20220410145352_ca43a.thumb.1000_0.png",
    "https://c-ssl.duitang.com/uploads/blog/202204/10/20220410145354_b6324.thumb.1000_0.png_webp",
    "https://c-ssl.duitang.com/uploads/blog/202204/10/20220410145400_4e9aa.thumb.1000_0.jpeg_webp",
    "https://c-ssl.duitang.com/uploads/item/202003/30/20200330031611_CNm2c.thumb.1000_0.jpeg_webp",
    "https://c-ssl.duitang.com/uploads/blog/202202/17/20220217231635_91a48.thumb.1000_0.jpeg_webp",
    "https://c-ssl.duitang.com/uploads/blog/202202/17/20220217232307_14368.thumb.1000_0.jpeg_webp",
    "https://c-ssl.duitang.com/uploads/item/201807/19/20180719111258_sZQvJ.thumb.1000_0.jpeg_webp",
    "https://c-ssl.duitang.com/uploads/item/201602/05/20160205193647_ZutNJ.thumb.1000_0.jpeg_webp",
    "https://c-ssl.duitang.com/uploads/item/201512/13/20151213121543_iXYA2.thumb.1000_0.png_webp",
  ];

  PhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("大图浏览")),
      body: GridView.builder(
        padding: const EdgeInsets.only(left: 8, top: 30, right: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 3, // 3列
          childAspectRatio: 1.0, // 宽高比
        ),
        itemCount: urlStrArr.length,
        itemBuilder: (context, index) {
          var urlStr = urlStrArr[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: ((context, animation, secondaryAnimation) {
                    return PhotoBrowserPage(urlStrArr, initialIndex: index);
                  }),
                ),
              );
            },
            child: Hero(
              tag: urlStr,
              child: ExtendedImage.network(
                urlStr,
                fit: BoxFit.cover
              ),
            ),
          );
        },
      ),
    );
  }
}
