extension AppLogicOnImageExtension on String {
  bool isVideo() {
    String extension = split(".").last;
    if (extension == 'mp4' ||
        extension == 'avi' ||
        extension == 'mov' ||
        extension == 'wmv' ||
        extension == 'mkv' ||
        extension == 'webm') {
      return true;
    } else {
      return false;
    }
  }
}
