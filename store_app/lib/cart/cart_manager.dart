import 'package:flutter/foundation.dart';
import 'package:store_app/models/cart_item_model.dart';
import 'package:store_app/models/product_model.dart';

class CartManager extends ChangeNotifier {
  CartManager._();

  static final CartManager instance = CartManager._();

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List<CartItemModel>.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalPrice =>
      _items.fold(
        0.0,
        (total, item) => total + item.product.price * item.quantity,
      );

  void add(ProductModel product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _items.add(CartItemModel(product: product));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    if (index < 0 || index >= _items.length) return;
    _items[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (index < 0 || index >= _items.length) return;
    if (--_items[index].quantity == 0) {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
