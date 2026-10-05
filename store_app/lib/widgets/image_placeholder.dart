import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image_not_supported_outlined,
      size: 50,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}