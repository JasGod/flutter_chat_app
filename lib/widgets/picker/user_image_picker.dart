import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(Uint8List pickedimg) pickedFn;
  const UserImagePicker(this.pickedFn, {Key? key}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  Uint8List? _imgByte;
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    final imageByte = await pickedImageFile!.readAsBytes();
    if (mounted) {
      setState(() {
        _imgByte = imageByte;
      });
    }
    widget.pickedFn(_imgByte!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _imgByte != null ? MemoryImage(_imgByte!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
