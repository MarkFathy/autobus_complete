// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
    final String url;
    final String thumbnail;
    final String preview;

    ImageModel({
        required this.url,
        required this.thumbnail,
        required this.preview,
    });

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        url: json["url"],
        thumbnail: json["thumbnail"],
        preview: json["preview"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "thumbnail": thumbnail,
        "preview": preview,
    };
}
