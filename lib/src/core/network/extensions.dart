import 'dart:io';

import 'package:autobus_complete/src/core/network/network_request.dart';
import 'package:dio/dio.dart';

extension NetworkRequestExtension on NetworkRequest<dynamic> {
  bool get _canBeConvertedToFormData =>
      hasBodyAndProgress() && body != null && body!.entries.isNotEmpty;

  bool hasBodyAndProgress() =>
      method == RequestMethod.post ||
      method == RequestMethod.put ||
      method == RequestMethod.patch ||
      method == RequestMethod.delete;

  String asString() => method.toString().split('.').last.toUpperCase();

  Future<void> prepareRequestData() async {
    if (_canBeConvertedToFormData) {
      final entries = body!.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final value = entries[i].value;
        if (value is File) {
          isFormData = true;
          body![entries[i].key] = value.toMultiPart();
        } else if (value is List<File>) {
          isFormData = true;
          body![entries[i].key] = value.toMultiPart();
        }
      }
    }
  }
}

extension MultiPartFileConverter on File {
  MultipartFile toMultiPart() => MultipartFile.fromFileSync(path);
}

extension MultiPartFileListConverter on List<File> {
  List<MultipartFile> toMultiPart() {
    final multipartFiles = <MultipartFile>[];
    for (final file in this) {
      multipartFiles.add(file.toMultiPart());
    }
    return multipartFiles;
  }
}
