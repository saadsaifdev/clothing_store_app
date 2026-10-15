import 'package:flutter/material.dart';
import 'package:store_app/cart/cart_manager.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/pages/cart_view.dart';
import 'package:store_app/pages/post_add_product_page.dart';
import 'package:store_app/pages/product_details_page.dart';
import 'package:store_app/pages/search_page.dart';
import 'package:store_app/services/get_all_products_services.dart';
import 'package:store_app/widgets/empty_view.dart';
import 'package:store_app/widgets/error_view.dart';
import 'package:store_app/widgets/loading_view.dart';
import 'package:store_app/widgets/products_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CartManager _cart = CartManager.instance;

  final GetAllProductsServices _productsService = GetAllProductsServices();

  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<ProductModel>> _loadProducts() {
    return _productsService.getAllProducts();
  }

  Future<void> _refreshProducts() async {
    final refreshedProducts = _loadProducts();

    setState(() {
      _productsFuture = refreshedProducts;
    });

    try {
      await refreshedProducts;
    } catch (_) {}
  }

  Future<void> _openAddProductPage() async {
    final result = await Navigator.pushNamed(context, PostAddProductPage.id);

    if (!mounted) return;

    if (result != null) {
      await _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProductPage,
        tooltip: 'Add product',
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }

          if (snapshot.hasError) {
            return ErrorView(onRetry: _refreshProducts);
          }

          final products = snapshot.data ?? const <ProductModel>[];

          if (products.isEmpty) {
            return EmptyView(onRefresh: _refreshProducts);
          }

          return ProductsView(
            products: products,
            onRefresh: _refreshProducts,
            onCartPressed: () => Navigator.pushNamed(context, CartView.id),
            onAddToCart: _cart.add,
            onProductTap: (product) => Navigator.pushNamed(
              context,
              ProductDetailsView.id,
              arguments: product,
            ),
            onSearchPressed: () {
              Navigator.pushNamed(context, SearchView.id);
            },
          );
        },
      ),
    );
  }
}
