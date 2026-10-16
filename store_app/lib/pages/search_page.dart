import 'package:flutter/material.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/pages/product_details_page.dart';
import 'package:store_app/services/get_all_products_services.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String id = 'SearchView';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [];
  List<ProductModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  // These labels map to the clothing categories returned by ApiConfig.
  static const _trendingSearches = [
    'Dresses',
    'Tops',
    'Shirts',
    'Shoes',
    'Bags',
    'Watches',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _executeSearch([String? value]) async {
    final query = (value ?? _searchController.text).trim();
    if (query.isEmpty) return;

    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(offset: query.length);
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _recentSearches
        ..removeWhere((search) => search.toLowerCase() == query.toLowerCase())
        ..insert(0, query);
      if (_recentSearches.length > 6) _recentSearches.removeLast();
    });

    try {
      final allProducts = await GetAllProductsServices().getAllProducts();
      final results = allProducts.where((product) {
        final normalizedQuery = query.toLowerCase().trim();
        final title = product.title.toLowerCase();
        final category = product.category.toLowerCase().replaceAll('-', ' ');
        return title.contains(normalizedQuery) ||
            category.contains(normalizedQuery);
      }).toList();
      if (!mounted) return;
      setState(() => _searchResults = results);
    } catch (_) {
      if (!mounted) return;
      setState(() => _searchResults = []);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearSearch() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFAF9),
        title: Text(
          'Search',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: (_) {
                  if (_hasSearched) {
                    setState(() {
                      _hasSearched = false;
                      _searchResults = [];
                    });
                  }
                },
                onSubmitted: (_) => _executeSearch(),
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _executeSearch,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasSearched
                      ? _buildResults(theme)
                      : _buildDiscovery(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscovery(ThemeData theme) {
    final colors = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text('Recent searches', style: _sectionStyle(theme)),
              ),
              TextButton(onPressed: _clearSearch, child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: 6),
          ..._recentSearches.map(
            (search) => ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(Icons.history, color: colors.onSurfaceVariant),
              title: Text(search),
              onTap: () => _executeSearch(search),
            ),
          ),
          const SizedBox(height: 24),
        ],
        Text('Popular categories', style: _sectionStyle(theme)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _trendingSearches
              .map(
                (search) => ActionChip(
                  label: Text(search),
                  avatar: const Icon(Icons.north_east, size: 16),
                  onPressed: () => _executeSearch(search),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: colors.outlineVariant),
                  shape: const StadiumBorder(),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            'Find your next favorite piece',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(ThemeData theme) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 44, color: theme.colorScheme.outline),
              const SizedBox(height: 12),
              Text('No products found', style: _sectionStyle(theme)),
              const SizedBox(height: 6),
              Text(
                'Try another search or explore a trending category.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _searchResults.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return Card(
          color: Colors.white,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              ProductDetailsView.id,
              arguments: product,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              title: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            ),
          ),
        );
      },
    );
  }

  TextStyle? _sectionStyle(ThemeData theme) => theme.textTheme.titleMedium
      ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.1);
}
