import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store_app/pages/cart_view.dart';
import 'package:store_app/firebase_options.dart';
import 'package:store_app/pages/home_page.dart';
import 'package:store_app/pages/login_page.dart';
import 'package:store_app/pages/post_add_product_page.dart';
import 'package:store_app/pages/product_details_page.dart';
import 'package:store_app/pages/register_page.dart';
import 'package:store_app/pages/search_page.dart';
import 'package:store_app/pages/update_product_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Clothing Store',
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        HomePage.id: (context) => const HomePage(),
        UpdateProductPage.id: (context) => const UpdateProductPage(),
        PostAddProductPage.id: (context) => const PostAddProductPage(),
        SearchView.id: (context) => const SearchView(),
        CartView.id: (context) => const CartView(),
        ProductDetailsView.id: (context) {
          final product = ProductDetailsView.productFromRoute(
            ModalRoute.of(context)?.settings.arguments,
          );

          if (product == null) {
            return const Scaffold(
              body: Center(child: Text('Product details unavailable')),
            );
          }

          return ProductDetailsView(product: product);
        },
      },
    );
  }
}
