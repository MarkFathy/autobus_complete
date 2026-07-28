// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Montserrat-Light.ttf
  String get montserratLight => 'assets/fonts/Montserrat-Light.ttf';

  /// File path: assets/fonts/Montserrat-Regular.ttf
  String get montserratRegular => 'assets/fonts/Montserrat-Regular.ttf';

  /// File path: assets/fonts/Montserrat-SemiBold.ttf
  String get montserratSemiBold => 'assets/fonts/Montserrat-SemiBold.ttf';

  /// List of all assets
  List<String> get values => [
    montserratLight,
    montserratRegular,
    montserratSemiBold,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/avater.png
  AssetGenImage get avater => const AssetGenImage('assets/images/avater.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/place.png
  AssetGenImage get place => const AssetGenImage('assets/images/place.png');

  /// File path: assets/images/slide1.jpg
  AssetGenImage get slide1 => const AssetGenImage('assets/images/slide1.jpg');

  /// File path: assets/images/slide2.jpg
  AssetGenImage get slide2 => const AssetGenImage('assets/images/slide2.jpg');

  /// File path: assets/images/slide3.jpeg
  AssetGenImage get slide3 => const AssetGenImage('assets/images/slide3.jpeg');

  /// File path: assets/images/worker.png
  AssetGenImage get worker => const AssetGenImage('assets/images/worker.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    avater,
    logo,
    place,
    slide1,
    slide2,
    slide3,
    worker,
  ];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/alert.json
  String get alert => 'assets/lottie/alert.json';

  /// File path: assets/lottie/api_error.json
  String get apiError => 'assets/lottie/api_error.json';

  /// File path: assets/lottie/done.json
  String get done => 'assets/lottie/done.json';

  /// File path: assets/lottie/empty_box.json
  String get emptyBox => 'assets/lottie/empty_box.json';

  /// File path: assets/lottie/empty_cart.json
  String get emptyCart => 'assets/lottie/empty_cart.json';

  /// File path: assets/lottie/error.json
  String get error => 'assets/lottie/error.json';

  /// File path: assets/lottie/loading.json
  String get loading => 'assets/lottie/loading.json';

  /// File path: assets/lottie/logout.json
  String get logout => 'assets/lottie/logout.json';

  /// File path: assets/lottie/no_data.json
  String get noData => 'assets/lottie/no_data.json';

  /// File path: assets/lottie/no_internet.json
  String get noInternet => 'assets/lottie/no_internet.json';

  /// File path: assets/lottie/success.json
  String get success => 'assets/lottie/success.json';

  /// File path: assets/lottie/successfull_order.json
  String get successfullOrder => 'assets/lottie/successfull_order.json';

  /// List of all assets
  List<String> get values => [
    alert,
    apiError,
    done,
    emptyBox,
    emptyCart,
    error,
    loading,
    logout,
    noData,
    noInternet,
    success,
    successfullOrder,
  ];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ar.json
  String get ar => 'assets/translations/ar.json';

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class AppAssets {
  const AppAssets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
