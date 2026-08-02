part of 'imports_page_router.dart';

class CupertinoPageRouterCreator implements PageRouterCreator {
  @override
  Route<T> create<T>(
    Widget page, {
    RouteSettings? settings,
    TransitionType? transition,
    AnimationOption? animationOptions,
  }) => CupertinoPageRoute(
      builder: (context) => page,
      settings: settings,
    );
}
