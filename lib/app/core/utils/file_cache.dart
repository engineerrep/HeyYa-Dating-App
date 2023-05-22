import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EMFileType {
  video,
  picture,
  other,
}

class EMFileStatus {
  static const init = 'init';
  static const downloading = 'downloading';
  static const donwloaded = 'donwloaded';
  static const unknown = 'unknown';
}

const String emCacheName = 'em_cache';
const String emFilename = 'em_filename';
const String emSavePath = 'em_savePath';
const String emUrl = 'em_url';
const String emFileStatus = 'em_fileStatus';

/// 调用初始化方法
/// EMCache.shared.initialization();
/// 开启下载队列
/// startDownloadQueue();
/// 保存文件，包括网络及本地文件
/// saveFile(EMFileType.video, url: '');
///
class EMCache {
  static final EMCache shared = EMCache();

  late Dio _dio;

  /// 文件状态
  late Map<String, dynamic> fileStatus;

  /// 下载队列
  late Queue<Map<String, dynamic>> downloadQueue;

  /// 是否允许开启下载队列, ture 能够调用 startDownloadQueue, false调用无效
  bool shouldStartQueue = true;

  /// 最大异步下载线程数
  int maxDownloadCount = 5;

  /// 当前异步下载线程数
  int currentDownloadCount = 0;

  /// 应用内文档路径
  String documentPath = '';

  Future<void> createDir() async {
    final dir = await getApplicationDocumentsDirectory();
    documentPath = dir.path;
    print(documentPath);

    String cachePath = '${dir.path}/cache';
    String videosPath = getDirectoryPath(EMFileType.video);
    String picturesPath = getDirectoryPath(EMFileType.picture);
    String othersPath = getDirectoryPath(EMFileType.other);

    await emCreateApplicationDocumentsDirectory(cachePath);
    await emCreateApplicationDocumentsDirectory(videosPath, isAllPath: false);
    await emCreateApplicationDocumentsDirectory(picturesPath, isAllPath: false);
    await emCreateApplicationDocumentsDirectory(othersPath, isAllPath: false);
  }

  /// 初始化方法（使用前必须调用的方法）
  void initialization() async {
    await createDir();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cacheJson = preferences.getString(emCacheName);
    if (cacheJson == null) {
      fileStatus = {};
    } else {
      fileStatus = jsonDecode(cacheJson);
    }

    BaseOptions baseOptions = BaseOptions(connectTimeout: 15000);
    _dio = Dio(baseOptions);

    downloadQueue = Queue();

    clearUncompleteFile();

    startDownloadQueue();
  }

  /// 开启下载文件队列
  void startDownloadQueue() async {
    if (downloadQueue.isNotEmpty && currentDownloadCount <= maxDownloadCount) {
      final fileInfo = downloadQueue.removeFirst();
      String filename = fileInfo[emFilename];
      String url = fileInfo[emUrl];
      String savePath = fileInfo[emSavePath];
      currentDownloadCount += 1;
      downloadFile(url, savePath, filename);
    }
  }

  /// 删除非下载成功的文件
  void clearUncompleteFile() async {
    fileStatus.forEach((key, value) {
      String status = value[emFileStatus];
      String filePath = value[emSavePath];
      if (status != EMFileStatus.donwloaded) {
        File file = File(filePath);
        if (file.existsSync()) {
          file.delete();
        }
      }
    });

    fileStatus = {};

    saveFileStatus();
  }

  /// 删除所有缓存或指定文件类型目录
  Future<void> clearCache(EMFileType? fileType) async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (fileType == null) {
      Directory file = Directory('${directory.path}/cache');
      if (await file.exists()) {
        file.deleteSync(recursive: true);
      }
    } else {
      String filePath = getDirectoryPath(fileType);
      Directory file = Directory(filePath);
      if (await file.exists()) {
        file.deleteSync(recursive: true);
      }
    }
  }

  /// 获取临时文档目录
  Future<Directory> emGetTemporaryDirectory() async => getTemporaryDirectory();

  /// 获取应用内文档目录
  Future<Directory> emGetApplicationDocumentsDirectory() async => getApplicationDocumentsDirectory();

  /// 创建应用内文档文件夹
  ///
  Future<Directory> emCreateApplicationDocumentsDirectory(String directoryPath, {bool isAllPath = true}) async {
    Directory directory = await emGetApplicationDocumentsDirectory();
    String appDocPath = directory.path;
    appDocPath += directoryPath;

    if (isAllPath) appDocPath = directoryPath;

    final tempDirectory = Directory(appDocPath);

    if (await tempDirectory.exists()) {
      return Future.value(tempDirectory);
    }
    await tempDirectory.create();

    return Future.value(tempDirectory);
  }

  /// 保存文件状态
  Future<bool> saveFileStatus() async {
    String jsonString = json.encode(fileStatus);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(emCacheName, jsonString);
  }

  /// 保存文件
  /// url: 网络文件路径（如果传入data, 忽略url, 优先data数据）
  /// data: 文件数据
  /// filename: 文件名（如果不传，默认使用url作为文件名）
  void saveFile(EMFileType fileType, {String? url, Uint8List? data, String? filename}) async {
    try {
      // 获取文件名更新文件状态
      String cacheFilename = getFilename(filename ?? url!);

      if (fileStatus[cacheFilename] != null) {
        String status = fileStatus[cacheFilename][emFileStatus];
        if (status == EMFileStatus.downloading || status == EMFileStatus.donwloaded) {
          return;
        }
      }

      // 获取文件路径，创建文件
      String filePath = await getFilePath(fileType, filename ?? url!);
      File file = File(filePath);
      bool exist = file.existsSync();

      if (!exist && data != null) {
        file = await file.create();
      } else if (exist) {
        return;
      }

      fileStatus[cacheFilename] = {emFileStatus: EMFileStatus.init, emSavePath: filePath};

      if (data != null) {
        // 保存文件
        await file.writeAsBytes(data);
        // 更新文件状态为完成
        fileStatus[cacheFilename] = {emFileStatus: EMFileStatus.donwloaded, emSavePath: filePath};
      } else {
        // 更新文件状态为下载中
        fileStatus[cacheFilename] = {emFileStatus: EMFileStatus.downloading, emSavePath: filePath};
        // 添加url文件信息到下载队列中
        downloadQueue.addLast({emFilename: cacheFilename, emSavePath: filePath, emUrl: url});

        startDownloadQueue();
      }
    } on Exception catch (e) {
      Exception exception = e;
      throw exception;
    }
  }

  /// 根据文件类型获取文件夹路径
  String getDirectoryPath(EMFileType fileType) {
    String filePath = '';
    if (fileType == EMFileType.video) {
      filePath = '/cache/videos';
    } else if (fileType == EMFileType.picture) {
      filePath = '/cache/pictures';
    } else {
      filePath = '/cache/others';
    }
    return filePath;
  }

  /// 根据保存文件类型获取文件存储路径
  Future<String> getFilePath(EMFileType fileType, String filename) async {
    String filePath = getDirectoryPath(fileType);

    String cacheFilename = getFilename(filename);
    filePath = '$filePath/$cacheFilename';
    Directory directory = await emGetApplicationDocumentsDirectory();
    return Future.value(directory.path + filePath);
  }

  /// 根据原始文件名获取存储文件名称
  String getFilename(String filename) {
    String cacheFilename = filename;
    Uint8List content = const Utf8Encoder().convert(cacheFilename);
    Digest digest = md5.convert(content);
    cacheFilename = digest.toString().toLowerCase();
    return "$cacheFilename.mp4";
  }

  /// 根据文件名获取文件
  Future<File?> getFile(String filename, EMFileType fileType) async {
    String filePath = await getFilePath(fileType, filename);
    File file = File(filePath);
    if (await file.exists()) {
      return Future.value(file);
    }
    return null;
  }

  /// 根据文件名获取文件
  File? getFileSync(String filename, EMFileType fileType) {
    String filePath = '$documentPath${getDirectoryPath(fileType)}/${getFilename(filename)}';
    File file = File(filePath);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  /// 下载文件
  Future<File?> downloadFile(String url, String savePath, String filename) async {
    try {
      final response = await _dio.download(url, savePath);
      currentDownloadCount -= 1;
      if (response.statusCode == 200) {
        File file = File(savePath);
        if (file.existsSync()) {
          fileStatus[filename] = {emFileStatus: EMFileStatus.donwloaded, emSavePath: savePath};
          saveFileStatus();
          return Future.value(file);
        }
      }
      fileStatus[filename] = {emFileStatus: EMFileStatus.unknown, emSavePath: savePath};
      saveFileStatus();

      startDownloadQueue();
      return null;
    } on Exception catch (e) {
      print('download file error $e');
    }
    return null;
  }

  Future<int> getCacheSize() async {
    final dir = await getApplicationDocumentsDirectory();
    documentPath = dir.path;

    String cachePath = '${dir.path}/cache';

    Directory directory = Directory(cachePath);
    int totalSize = 0;
    try {
      if (directory.existsSync()) {
        directory.listSync(recursive: true, followLinks: false).forEach((FileSystemEntity entity) {
          if (entity is File) {
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
    return totalSize;
  }
}
