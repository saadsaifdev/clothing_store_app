import 'package:flutter/material.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/widgets/custom_card.dart';
import 'package:store_app/widgets/home_app_bar.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({
    super.key,
    required this.products,
    required this.onRefresh,
    required this.cartItemCount,
    required this.onCartPressed,
    required this.onAddToCart, // 1. أضفنا استلام دالة إضافة المنتج للسلة هنا
  });

  final List<ProductModel> products;
  final Future<void> Function() onRefresh;
  final int cartItemCount;
  final VoidCallback onCartPressed;
  final VoidCallback onAddToCart; // 2. عرفنا نوع الدالة

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          HomeAppBar(
            cartItemCount: cartItemCount,
            onCartPressed: onCartPressed,
            onSearchPressed: () {},
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
                  onAddToCart: onAddToCart, // 3. مررنا الدالة لكل كارت منتج بنجاح!
                );
              }, childCount: products.length),
            ),
          ),
        ],
      ),
    );
  }
}