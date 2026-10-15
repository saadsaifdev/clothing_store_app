import 'package:flutter/material.dart';
import 'package:store_app/services/add_product_service.dart';
import 'package:store_app/widgets/custom_button.dart';
import 'package:store_app/widgets/custom_text_form_field.dart';

class PostAddProductPage extends StatefulWidget {
  const PostAddProductPage({super.key});

  static const String id = 'PostAddProductPage';

  @override
  State<PostAddProductPage> createState() => _PostAddProductPageState();
}

class _PostAddProductPageState extends State<PostAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();

  final _addProductService = AddProductService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newProduct = await _addProductService.addProduct(
        title: _nameController.text,
        price: _priceController.text,
        desc: _descriptionController.text,
        image: _imageController.text,
        category: _categoryController.text,
      );

      if (!mounted) return;
      _showMessage('Product added successfully!');
      Navigator.pop(context, newProduct);
    } on FormatException catch (e) {
      if (!mounted) return;
      _showMessage(e.message, isError: true);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Failed to add product. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _priceValidator(String? value) {
    final price = double.tryParse(value?.trim() ?? '');
    if (price == null || price <= 0) {
      return 'Enter a valid price greater than zero';
    }
    return null;
  }

  String? _imageValidator(String? value) {
    final image = value?.trim() ?? '';
    final uri = Uri.tryParse(image);

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return 'Enter a valid image URL';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Product name',
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _priceController,
                  hintText: 'Price',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _priceValidator,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _imageController,
                  hintText: 'Image URL',
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validator: _imageValidator,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _categoryController,
                  hintText: 'Category (e.g. mens-shirts)',
                  textInputAction: TextInputAction.done,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onTap: _isLoading ? null : _addProduct,
                  text: _isLoading ? 'Adding...' : 'Add Product',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
