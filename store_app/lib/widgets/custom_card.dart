import 'package:flutter/material.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/pages/update_product_page.dart';
import 'package:store_app/widgets/product_details.dart';
import 'package:store_app/widgets/product_image.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.onProductTap,
  });

  final ProductModel product;
  final VoidCallback onAddToCart;
  final VoidCallback? onProductTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    final title = product.title.trim().isEmpty
        ? 'Unnamed product'
        : product.title.trim();

    final imageUrl = product.image.trim();
    final price = product.price.toString();

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.none,
        child: InkWell(
          onTap: onProductTap ?? () => _openUpdatePage(context),
          borderRadius: BorderRadius.circular(15),
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: colorScheme.primary.withValues(alpha: 0.04),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ProductDetails(
                  title: title,
                  price: price,
                  onAddToCart: onAddToCart,
                ),
              ),
              Positioned(
                top: -48,
                left: 0,
                right: 0,
                child: Center(
                  child: ProductImage(
                    imageUrl: imageUrl,
                    cacheWidth: (130 * devicePixelRatio).round(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openUpdatePage(BuildContext context) {
    Navigator.pushNamed(
      context, 
      UpdateProductPage.id,
      arguments: product, 
    );
  }
}