import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/data/repository/media_repository.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:path/path.dart' as path;

Future<AssetEntity?> pickFromCamera(BuildContext context) {
  return CameraPicker.pickFromCamera(
    context,
    pickerConfig: CameraPickerConfig(
        enableRecording: false,
        preferredLensDirection: CameraLensDirection.front,
        enableSetExposure: false,
        enableExposureControlOnPoint: false,
        foregroundBuilder: (build, controller) {
          return Container();
        }),
  );
}

Future<List<AssetEntity>?> pickVideos(
    {required BuildContext context,
    int maxCount = 1,
    List<AssetEntity>? selectedAssets}) async {
  final PermissionState ps = await AssetPicker.permissionCheck();
  final provider = DefaultAssetPickerProvider(
      filterOptions: GetPlatform.isAndroid
          ? FilterOptionGroup(
              containsLivePhotos: false,
              videoOption: FilterOption(
                  durationConstraint: DurationConstraint(
                      allowNullable: true,
                      min: Duration(seconds: 5),
                      max: Duration(seconds: 30))))
          : null,
      requestType: RequestType.video,
      maxAssets: maxCount,
      selectedAssets: selectedAssets);
  final builder = HeyyaVideoPickerBuilder(
    provider: provider,
    initialPermission: ps,
    pickerTheme: AssetPicker.themeData(Colors.white).copyWith(
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme()
            .copyWith(systemOverlayStyle: SystemUiOverlayStyle.dark)),
    specialItemPosition: SpecialItemPosition.none, //选择时不允许拍摄
  );
  return AssetPicker.pickAssetsWithDelegate(
    context,
    delegate: builder,
  );
}

Future<List<AssetEntity>?> pickAssets(
    {required BuildContext context,
    int maxCount = 3,
    List<AssetEntity>? selectedAssets}) async {
  final PermissionState ps = await AssetPicker.permissionCheck();
  final provider = DefaultAssetPickerProvider(
      requestType: RequestType.image,
      maxAssets: maxCount,
      selectedAssets: selectedAssets);
  final builder = HeyyaAssetPickerBuilder(
    provider: provider,
    initialPermission: ps,
    pickerTheme: AssetPicker.themeData(Colors.white).copyWith(
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme()
            .copyWith(systemOverlayStyle: SystemUiOverlayStyle.dark)),
    specialItemBuilder: (context, path, length) {
      if (path?.isAll != true) {
        return null;
      }
      return GestureDetector(
        onTap: () async {
          final AssetEntity? result = await pickFromCamera(context);
          if (result == null) {
            return;
          }
          final AssetPicker<AssetEntity, AssetPathEntity> picker =
              context.findAncestorWidgetOfExactType()!;
          final DefaultAssetPickerBuilderDelegate builder =
              picker.builder as DefaultAssetPickerBuilderDelegate;
          final DefaultAssetPickerProvider p = builder.provider;
          await p.switchPath(
            p.currentPath!,
          );
          p.selectAsset(result);
        },
        child: ExtendedImage.asset(
          Assets.photosCamera,
          fit: BoxFit.fill,
        ),
      );
    },
    specialItemPosition: SpecialItemPosition.none, //选择照片时不允许拍照
  );
  return AssetPicker.pickAssetsWithDelegate(
    context,
    delegate: builder,
  );
}

class HeyyaVideoPickerBuilder extends DefaultAssetPickerBuilderDelegate {
  HeyyaVideoPickerBuilder({
    required super.provider,
    required super.initialPermission,
    super.gridCount = 3,
    super.specialItemBuilder,
    super.specialItemPosition = SpecialItemPosition.none,
    super.pickerTheme,
  }) : super(shouldRevertGrid: false);

  @override
  Widget selectedBackdrop(BuildContext context, int index, AssetEntity asset) {
    return Selector<DefaultAssetPickerProvider, String>(
      selector: (_, DefaultAssetPickerProvider p) => p.selectedDescriptions,
      builder: (BuildContext context, String descriptions, __) {
        final bool selected = descriptions.contains(asset.toString());
        final Widget innerSelector = selected
            ? ExtendedImage.asset(Assets.photosChooseSelect)
            : ExtendedImage.asset(Assets.photosChooseNormal);
        return Positioned.fill(
            child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => selectAsset(context, asset, selected),
          child: Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: innerSelector,
          ),
        ));
      },
    );
  }

  @override
  Widget selectIndicator(BuildContext context, int index, AssetEntity asset) {
    return const SizedBox.shrink();
  }

  Widget _selectNextButton(BuildContext context, DefaultAssetPickerProvider p) {
    return SizedBox(
      width: 200.0,
      height: 56.0,
      child: Stack(
        children: [
          p.isSelectedNotEmpty
              ? ExtendedImage.asset(Assets.buttonSelect)
              : ExtendedImage.asset(Assets.buttonNormal),
          Align(
            child: Text(
              p.isSelectedNotEmpty
                  ? 'Next(${p.selectedAssets.length}/${p.maxAssets})'
                  : 'Next',
              style: textStyle(
                type: TextType.bold,
                fontSize: 20.0,
                color: p.isSelectedNotEmpty
                    ? ThemeColors.c272b00
                    : ThemeColors.cb5b5ac,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 294.0,
        height: 137.0,
        child: Stack(
          children: [
            IgnorePointer(child: ExtendedImage.asset(Assets.buttonShadow)),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 24.0),
                child: Consumer<DefaultAssetPickerProvider>(
                    builder: (_, DefaultAssetPickerProvider p, __) {
                  return GestureDetector(
                    onTap: p.isSelectedNotEmpty
                        ? () => Navigator.of(context).maybePop(p.selectedAssets)
                        : null,
                    child: _selectNextButton(context, p),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.hasAssetsToDisplay,
      builder: (_, bool hasAssetsToDisplay, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasAssetsToDisplay
              ? Stack(
                  children: [
                    assetsGridBuilder(context),
                    _confirmButton(context),
                  ],
                )
              : loadingIndicator(context),
        );
      },
    );
  }

  @override
  Widget androidLayout(BuildContext context) {
    return AssetPickerAppBarWrapper(
      appBar: appBar(context),
      body: _buildGrid(context),
    );
  }

  @override
  Widget appleOSLayout(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ChangeNotifierProvider.value(
            value: provider,
            builder: (context, _) => _buildGrid(context),
          ),
        ),
        appBar(context),
      ],
    );
  }

  @override
  AssetPickerAppBar appBar(BuildContext context) {
    return AssetPickerAppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ExtendedImage.asset(Assets.cancelAll),
      ),
      title: Text(
        "Videos",
        style: textStyle(
            type: TextType.bold, fontSize: 20.0, color: ThemeColors.c1f2320),
      ),
    );
  }
}

class HeyyaAssetPickerBuilder extends DefaultAssetPickerBuilderDelegate {
  HeyyaAssetPickerBuilder({
    required super.provider,
    required super.initialPermission,
    super.gridCount = 3,
    super.specialItemBuilder,
    super.specialItemPosition = SpecialItemPosition.prepend,
    super.pickerTheme,
  }) : super(shouldRevertGrid: false);

  @override
  Widget selectedBackdrop(BuildContext context, int index, AssetEntity asset) {
    return Selector<DefaultAssetPickerProvider, String>(
      selector: (_, DefaultAssetPickerProvider p) => p.selectedDescriptions,
      builder: (BuildContext context, String descriptions, __) {
        final bool selected = descriptions.contains(asset.toString());
        final Widget innerSelector = selected
            ? ExtendedImage.asset(Assets.photosChooseSelect)
            : ExtendedImage.asset(Assets.photosChooseNormal);
        return Positioned.fill(
            child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => selectAsset(context, asset, selected),
          child: Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: innerSelector,
          ),
        ));
      },
    );
  }

  @override
  Widget selectIndicator(BuildContext context, int index, AssetEntity asset) {
    return const SizedBox.shrink();
  }

  Widget _selectNextButton(BuildContext context, DefaultAssetPickerProvider p) {
    return SizedBox(
      width: 200.0,
      height: 56.0,
      child: Stack(
        children: [
          p.isSelectedNotEmpty
              ? ExtendedImage.asset(Assets.buttonSelect)
              : ExtendedImage.asset(Assets.buttonNormal),
          Align(
            child: Text(
              p.isSelectedNotEmpty
                  ? 'Next(${p.selectedAssets.length}/${p.maxAssets})'
                  : 'Next',
              style: textStyle(
                type: TextType.bold,
                fontSize: 20.0,
                color: p.isSelectedNotEmpty
                    ? ThemeColors.c272b00
                    : ThemeColors.cb5b5ac,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 294.0,
        height: 137.0,
        child: Stack(
          children: [
            IgnorePointer(child: ExtendedImage.asset(Assets.buttonShadow)),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 24.0),
                child: Consumer<DefaultAssetPickerProvider>(
                    builder: (_, DefaultAssetPickerProvider p, __) {
                  return GestureDetector(
                    onTap: p.isSelectedNotEmpty
                        ? () => Navigator.of(context).maybePop(p.selectedAssets)
                        : null,
                    child: _selectNextButton(context, p),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.hasAssetsToDisplay,
      builder: (_, bool hasAssetsToDisplay, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasAssetsToDisplay
              ? Stack(
                  children: [
                    assetsGridBuilder(context),
                    _confirmButton(context),
                  ],
                )
              : loadingIndicator(context),
        );
      },
    );
  }

  @override
  Widget androidLayout(BuildContext context) {
    return AssetPickerAppBarWrapper(
      appBar: appBar(context),
      body: _buildGrid(context),
    );
  }

  @override
  Widget appleOSLayout(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ChangeNotifierProvider.value(
            value: provider,
            builder: (context, _) => _buildGrid(context),
          ),
        ),
        appBar(context),
      ],
    );
  }

  @override
  AssetPickerAppBar appBar(BuildContext context) {
    return AssetPickerAppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ExtendedImage.asset(Assets.cancelAll),
      ),
      title: Text(
        "Photos",
        style: textStyle(
            type: TextType.bold, fontSize: 20.0, color: ThemeColors.c1f2320),
      ),
    );
  }
}

class HeyyaAssetsPickerController extends GetxController {
  final photos = RxList<String>();
  final List<AssetEntity> selectedAssets = [];

  @override
  void onClose() {
    super.onClose();
  }

  pickAssetsWith({
    required BuildContext context,
    int maxCount = 9,
  }) async {
    final assets = await pickAssets(
            context: context,
            maxCount: maxCount,
            selectedAssets: selectedAssets) ??
        [];
    await _addAssets(assets);
  }

  _addAssets(List<AssetEntity> assets) async {
    if (assets.length > 0) {
      selectedAssets.clear();
      photos.clear();
    }
    selectedAssets.addAll(assets.where((a) => !selectedAssets.contains(a)));
    final files = await Future.wait(selectedAssets.map((a) async {
      return await a.file;
    }));
    photos.replaceRange(0, photos.length, files.map((f) => f!.path));
  }

  deletePhoto(String path) async {
    final index = (await Future.wait(selectedAssets.map((a) async {
      return await a.file;
    }).toList()))
        .indexWhere((f) => f?.path == path);
    if (index >= 0) {
      selectedAssets.removeAt(index);
      photos.removeAt(index);
    }
  }

  Future<List<String>> uploadAssets() async {
    final mediaRepository = MediaRepository();
    final context = path.Context(style: path.Style.url);
    final files = await Future.wait(photos.map((p) async {
      final distPath =
          context.withoutExtension(p) + '_compressed' + context.extension(p);
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        p,
        distPath,
        minWidth: 1080,
        format: CompressFormat.jpeg,
      );
      if (compressedFile == null) {
        return XFile(p);
      }
      return XFile(compressedFile.path);
    }));
    final results =
        await mediaRepository.uploadMedias(files, MediaType.PICTURE);
    return results;
  }

  static Future<List<String>> uploadAsset(List<AssetEntity> assets) async {
    final mediaRepository = MediaRepository();
    final context = path.Context(style: path.Style.url);
    final paths = await Future.wait(assets.map((a) async {
      final file = await a.file;
      return file!.path;
    }));
    final files = await Future.wait(paths.map((p) async {
      final distPath =
          context.withoutExtension(p) + '_compressed' + context.extension(p);
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        p,
        distPath,
        minWidth: 1080,
        format: CompressFormat.jpeg,
      );
      if (compressedFile == null) {
        return XFile(p);
      }
      return XFile(compressedFile.path);
    }));
    final results =
        await mediaRepository.uploadMedias(files, MediaType.PICTURE);
    return results;
  }
}
