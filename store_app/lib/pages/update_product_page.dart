import 'package:flutter/material.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/update_product_service.dart';
import 'package:store_app/widgets/custom_button.dart';
import 'package:store_app/widgets/custom_text_form_field.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key});

  static const String id = 'update-product';

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _updateProductService = UpdateProductService();

  ProductModel? _product;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _hasInvalidArguments = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is! ProductModel) {
      _hasInvalidArguments = true;
      _isInitialized = true;
      return;
    }
    _product = arguments;
    _nameController.text = arguments.title;
    _descriptionController.text = arguments.description;
    _priceController.text = arguments.price.toString();
    _imageController.text = arguments.image;
    _isInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    final product = _product;
    if (product == null) {
      _showMessage('Product data is unavailable', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedProduct = await _updateProductService.updateProduct(
        id: product.id,
        title: _nameController.text,
        price: _priceController.text,
        description: _descriptionController.text,
        image: _imageController.text,
        category: product.category,
      );

      if (!mounted) return;
      Navigator.pop(context, updatedProduct);
    } on FormatException catch (e) {
      if (!mounted) return;
      _showMessage(e.message, isError: true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Failed to update product. Please try again.', isError: true);
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
          backgroundColor: isError ? Colors.red : null,
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
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_hasInvalidArguments) {
      return Scaffold(
        appBar: AppBar(title: const Text('Update Product')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go back'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Update Product'), centerTitle: true),
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
                  textInputAction: TextInputAction.done,
                  validator: _imageValidator,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onTap: _isLoading ? null : _updateProduct,
                  text: _isLoading ? 'Updating...' : 'Update',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
