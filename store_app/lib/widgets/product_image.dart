import 'package:flutter/material.dart';
import 'package:store_app/widgets/image_placeholder.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    required this.imageUrl,
    required this.cacheWidth,
  });

  final String imageUrl;
  final int cacheWidth;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const ImagePlaceholder();
    }

    return SizedBox(
      width: 130,
      height: 115,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        cacheWidth: cacheWidth,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'Product image',
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const ImagePlaceholder();
        },
      ),
    );
  }
}
