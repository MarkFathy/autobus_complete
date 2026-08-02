part of 'imports_page_router.dart';

class MaterialPageRouterCreator implements PageRouterCreator {
  @override
  Route<T> create<T>(
    Widget page, {
    RouteSettings? settings,
    TransitionType? transition,
    AnimationOption? animationOptions,
  }) => MaterialPageRoute(
      builder: (context) => page,
      settings: settings,
    );
}
