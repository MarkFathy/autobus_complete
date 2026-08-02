// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str) as Map<String, dynamic>);

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  final String url;
  final String thumbnail;
  final String preview;

  ImageModel({required this.url, required this.thumbnail, required this.preview});

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        url: json['url'] as String,
        thumbnail: json['thumbnail'] as String,
        preview: json['preview'] as String,
      );

  Map<String, dynamic> toJson() => {'url': url, 'thumbnail': thumbnail, 'preview': preview};
}
