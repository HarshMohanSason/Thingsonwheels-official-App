import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class ImageUploadSection extends StatefulWidget{

  final String title;

  const ImageUploadSection({Key? key, required this.title}) : super(key: key);

  @override
  ImageUploadSectionState createState() => ImageUploadSectionState();
}

class ImageUploadSectionState extends State<ImageUploadSection>{
  final ImagePicker _picker = ImagePicker();
  List<XFile> images = [];
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        images.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.title, style: Theme.of(context).textTheme.headline6),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + 1, // Add one for the 'Add' button
            itemBuilder: (BuildContext context, int index) {
              if (index == images.length) {
                // 'Add' button
                return IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: _pickImage,
                );
              }
              // Display picked images
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(File(images[index].path)),
              );
            },
          ),
        ),
      ],
    );
  }
}