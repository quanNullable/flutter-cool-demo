import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';

class DemoPage2A extends StatefulWidget {
  @override
  _DemoPage2AState createState() => _DemoPage2AState();
}

class _DemoPage2AState extends State<DemoPage2A> {
  final editorKey = GlobalKey<ExtendedImageEditorState>();

  ImageProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ExtendedExactAssetImageProvider('assets/image/test.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Use extended_image library"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: _pick,
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: crop,
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: buildImage(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildFunctions());
  }

  Widget buildImage() {
    return ExtendedImage(
      image: provider,
      height: 400,
      width: 400,
      extendedImageEditorKey: editorKey,
      mode: ExtendedImageMode.editor,
      fit: BoxFit.contain,
      initEditorConfigHandler: (state) {
        return EditorConfig(
          maxScale: 8.0,
          cropRectPadding: EdgeInsets.all(20.0),
          hitTestSize: 20.0,
          cropAspectRatio: 2 / 1,
        );
      },
    );
  }

  Widget _buildFunctions() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.flip),
          title: Text("Flip"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_left),
          title: Text("Rotate left"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_right),
          title: Text("Rotate right"),
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            flip();
            break;
          case 1:
            rotate(false);
            break;
          case 2:
            rotate(true);
            break;
        }
      },
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor,
    );
  }

  void crop() async {
    final state = editorKey.currentState;
    final rect = state.getCropRect();
    final action = state.editAction;
    final radian = action.rotateAngle;

    final flipHorizontal = action.flipY;
    final flipVertical = action.flipX;
    // final img = await getImageFromEditorKey(editorKey);
    final img = state.rawImageData;

    ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));
    option.addOption(FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.outputFormat = OutputFormat.png(88);

    print(json.encode(option.toJson()));

    final start = DateTime.now();
    final result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print("result.length = ${result.length}");

    final diff = DateTime.now().difference(start);

    print("image_editor time : $diff");

    showPreviewDialog(result);
  }

  void flip() {
    editorKey.currentState.flip();
  }

  static Future<Uint8List> getImageFromEditorKey(
      GlobalKey<ExtendedImageEditorState> editorKey) async {
    return editorKey.currentState.rawImageData;
  }

  rotate(bool right) {
    editorKey.currentState.rotate(right: right);
  }

  void showPreviewDialog(Uint8List image) {
    showDialog(
      context: context,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child: Center(
            child: SizedBox.fromSize(
              size: Size.square(200),
              child: Container(
                child: Image.memory(image),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pick() async {
    final result = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      print(result.absolute.path);
      provider = ExtendedFileImageProvider(result);
      setState(() {});
    }
  }
}
