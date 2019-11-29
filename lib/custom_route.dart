import 'package:flutter/material.dart';

/**
 * Author: Quan
 * Date: 2019-11-18 10:17
 */

class CustomRoute extends PageRouteBuilder {
  final Widget widget;
  final RouteType type;

  CustomRoute(this.widget, {this.type = RouteType.scale})
      : super(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              switch (type) {
                case RouteType.fade:
                  //淡出过渡路由
                  return FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                    child: child,
                  );
                  break;
                case RouteType.scale:
                  //比例转换路由
                  return ScaleTransition(
                    scale: Tween(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                    child: child,
                  );
                  break;
                case RouteType.slide:
                  //幻灯片路由
                  return SlideTransition(
                    position: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                        .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                    child: child,
                  );
                  break;
                case RouteType.rotate:
                  //旋转+比例转换路由
                  return RotationTransition(
                    turns: Tween(begin: -1.0, end: 1.0)
                        .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                    child: ScaleTransition(
                      scale: Tween(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                      child: child,
                    ),
                  );
                  break;
              }
              return null;
            });
}

enum RouteType { fade, scale, slide, rotate }
