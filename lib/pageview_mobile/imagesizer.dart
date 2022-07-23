import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_size_getter/image_size_getter.dart';

class ImageSizer{
  int imgheight;
  int imgwidth;

  void getImagesize(Uint8List image){
    final memoryImageSize = ImageSizeGetter.getSize(MemoryInput(image));
    imgheight = memoryImageSize.height;
    imgwidth = memoryImageSize.width;
  }
}