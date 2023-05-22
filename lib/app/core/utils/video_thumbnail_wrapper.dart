import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailData {
  final File thumbnail;
  final int width;
  final int height;
  VideoThumbnailData(this.thumbnail, this.width, this.height);
}

abstract class VideoThumbnailWrapper {
  static const String thumbnailFolderName = "video_thumbnail";

  static Future<String> getVideoThumbnailFolderPath() async {
    final tempDir = await getTemporaryDirectory();
    return join(tempDir.path, thumbnailFolderName);
  }

  static Future<String> getVideoThumbnailFilePath(String url,
      {int maxWidth = 0, int maxHeight = 0}) async {
    final digest = sha1.convert(utf8.encode(url));

    final fileName = "${digest}_${maxWidth}_$maxHeight.png";
    final folderPath = await getVideoThumbnailFolderPath();
    return join(folderPath, fileName);
  }

  static Future<VideoThumbnailData?> getVideoThumbnailFile(String url,
      {int maxWidth = 0, int maxHeight = 0}) async {
    final videoThumbnailPath = await getVideoThumbnailFilePath(url,
        maxWidth: maxWidth, maxHeight: maxHeight);
    File videoThumbnailFile = File(videoThumbnailPath);
    Uint8List imageData;
    if (videoThumbnailFile.existsSync()) {
      imageData = videoThumbnailFile.readAsBytesSync();
    } else {
      videoThumbnailFile.createSync(recursive: true);
      final data = await VideoThumbnail.thumbnailData(
        video: url,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      if (data == null) {
        return null;
      }
      imageData = data;
      videoThumbnailFile = await videoThumbnailFile.writeAsBytes(data);
    }
    final decodedImage = await decodeImageFromList(imageData);
    return VideoThumbnailData(
        videoThumbnailFile, decodedImage.width, decodedImage.height);
  }

  static Future<int> getVideoThumbnailsTotalSize() async {
    int size = 0;
    final videoThumbnailsDir = Directory(await getVideoThumbnailFolderPath());
    if (videoThumbnailsDir.existsSync()) {
      await for (final FileSystemEntity file in videoThumbnailsDir.list()) {
        size += file.statSync().size;
      }
    }
    return size;
  }

  static Future<void> clearVideoThumbnails() async {
    final videoThumbnailsDirectory =
        Directory(await getVideoThumbnailFolderPath());
    if (videoThumbnailsDirectory.existsSync()) {
      videoThumbnailsDirectory.deleteSync(recursive: true);
    }
  }
}
