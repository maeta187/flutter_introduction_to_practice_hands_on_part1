import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_introduction_to_practice_hands_on_part1/gen/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as image_lib;

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({super.key, required this.imageBitmap});

  /// 画像はコンストラクタで受け取る
  final Uint8List imageBitmap;

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  /// 画像のバイト列を格納するための変数
  late Uint8List _imageBitmap;

  /// 画像のバイト列の初期化
  /// initStateはStatefulWidgetがのライフサイクルメソッドの１つ
  /// ウィジェットが生成された時に1度だけ呼ばれる
  @override
  void initState() {
    super.initState();
    _imageBitmap = widget.imageBitmap;
  }

  /// 画像を回転させるメソッド
  void _rotateImage() {
    // 画像データをデコードする
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;
    // 画像を時計回りに90度回転する
    final rotatedImage = image_lib.copyRotate(image, angle: 90);
    // 画像データをエンコードして状態を更新する
    setState(() {
      _imageBitmap = image_lib.encodePng(rotatedImage);
    });
  }

  /// 画像を反転させるメソッド
  void _flipImage() {
    // 画像データをデコードする
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;
    // 画像を水平方向に反転する
    final flipImage = image_lib.copyFlip(image,
        direction: image_lib.FlipDirection.horizontal);
    // 画像データをエンコードして状態を更新する
    setState(() {
      _imageBitmap = image_lib.encodePng(flipImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n?.imageEditScreenTitle ?? ''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 画像を表示するウィジェット
            Image.memory(_imageBitmap),
            /*
            IconButton
            アイコンを表示するボタン
            */
            IconButton(
                onPressed: () => _rotateImage(),
                icon: SvgPicture.asset(
                  Assets.rotateIcon,
                  width: 24,
                  height: 24,
                )),
            IconButton(
                onPressed: () => _flipImage(),
                icon: SvgPicture.asset(Assets.flipIcon, width: 24, height: 24)),
          ],
        ),
      ),
    );
  }
}
