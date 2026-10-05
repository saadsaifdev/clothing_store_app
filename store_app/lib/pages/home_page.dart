import 'package:flutter/material.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/Get_All_Products_Services.dart';
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
  int _cartItemCount = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            cartItemCount: _cartItemCount,
            onCartPressed: () {
            },
            onAddToCart: () {
              setState(() {
                _cartItemCount++; 
              });
            },
          );
        },
      ),
    );
  }
}
