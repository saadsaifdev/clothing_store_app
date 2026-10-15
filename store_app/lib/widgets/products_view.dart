import 'package:flutter/material.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/widgets/custom_card.dart';
import 'package:store_app/widgets/home_app_bar.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({
    super.key,
    required this.products,
    required this.onRefresh,
    required this.onCartPressed,
    required this.onAddToCart,
    required this.onProductTap,
    required this.onSearchPressed,
  });

  final List<ProductModel> products;
  final Future<void> Function() onRefresh;
  final VoidCallback onCartPressed;
  final ValueChanged<ProductModel> onAddToCart;
  final Function(ProductModel) onProductTap;
  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          HomeAppBar(
            onCartPressed: onCartPressed,
            onSearchPressed: onSearchPressed,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 50),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.15,
                crossAxisSpacing: 12,
                mainAxisSpacing: 65,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return CustomCard(
                  product: products[index],
                  onAddToCart: () => onAddToCart(products[index]),
                  onProductTap: () => onProductTap(products[index]),
                );
              }, childCount: products.length),
            ),
          ),
        ],
      ),
    );
  }
}
