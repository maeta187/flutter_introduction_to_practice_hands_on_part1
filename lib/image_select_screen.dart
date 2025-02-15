// 画像データとしてUint8List型を使用するためにインポート
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// 画像を扱うためのパッケージ
import 'package:image_picker/image_picker.dart';
// Imageウィジェットと名前が重複するためasキーワードを名前を変更
import 'package:image/image.dart' as image_lib;

class ImageSelectScreen extends StatefulWidget {
  const ImageSelectScreen({super.key});

  @override
  State<ImageSelectScreen> createState() => _ImageSelectScreenState();
}

class _ImageSelectScreenState extends State<ImageSelectScreen> {
  /*
  ImagePicker
  image_pickerパッケージが提供するクラス
  画像ライブラリやカメラにアクセスする機能を持つ
  */
  /// ImagePickerをインスタンス化
  /// 画像ライブラリやカメラにアクセスする機能を持つ
  final ImagePicker _picker = ImagePicker();

  /*
  Uint8List
  8bit 符号なし整数リスト
  */
  Uint8List? _imageBitmap;

  /// 画像処理のメソッド
  Future<void> _selectImage() async {
    /*
    XFile
    ファイル抽象化クラス
    */
    /// ImagePickerクラスにて画像を取得すると、画像データはXFileと言うファイルを抽象化したクラスで返される
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    // ファイルオブジェクトから画像データを取得する
    /// XFileクラスから画像のバイト列を取得する
    final imageBitmap = await imageFile?.readAsBytes();
    assert(imageBitmap != null);
    if (imageBitmap == null) return;

    // 画像データをデコードする
    /// imageパッケージのdecodeImageメソッドで画像データをデコードする
    final image = image_lib.decodeImage(imageBitmap);
    assert(image != null);
    if (image == null) return;

    /*
    Image
    画像データとメタデータを内包したクラス
    */
    /// 画像が大きいと表示に時間がかかるのでリサイズする
    final image_lib.Image resizeImage;
    if (image.width > image.height) {
      // 横長の画像なら横幅を500pxにリサイズする
      resizeImage = image_lib.copyResize(image, width: 500);
    } else {
      // 縦長の画像なら縦幅を500pxにリサイズする
      resizeImage = image_lib.copyResize(image, height: 500);
    }

    // 画像をエンコードして状態を更新する
    setState(() {
      _imageBitmap = image_lib.encodeBmp(resizeImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final imageBitmap = _imageBitmap;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n?.imageSelectScreenTitle ?? ''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageBitmap != null) Image.memory(imageBitmap),
            ElevatedButton(
              // 画像が選択されると画像を表示
              onPressed: () => _selectImage(),
              child: Text(l10n?.imageSelect ?? ''),
            ),
            // 画像が選択されると「画像を編集する」ボタンを表示
            if (imageBitmap != null)
              ElevatedButton(
                onPressed: () {},
                child: Text(l10n?.imageEdit ?? ''),
              ),
          ],
        ),
      ),
    );
  }
}
