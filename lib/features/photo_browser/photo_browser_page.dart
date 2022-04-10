import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PhotoBrowserPage extends StatelessWidget {
  final List<String> urlStrArr;

  int initialIndex = 0;

  PhotoBrowserPage(
    this.urlStrArr, {
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.vertical,
      slideType: SlideType.onlyImage,
      child: ExtendedImageGesturePageView.builder(
        controller: ExtendedPageController(
          initialPage: initialIndex,
          pageSpacing: 50,
        ),
        itemBuilder: (context, index) {
          var urlStr = urlStrArr[index];
          return ExtendedImage.network(
            urlStr,
            enableSlideOutPage: true,
            heroBuilderForSlidingPage: (widget) {
              return Hero(
                tag: urlStr,
                child: widget,
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  // 作用：hero动画回去的时候，使用源widget
                  final Hero hero = (flightDirection == HeroFlightDirection.pop
                      ? fromHeroContext.widget
                      : toHeroContext.widget) as Hero;
                  return hero;
                },
              );
            },
          );
        },
      ),
    );
  }
}
