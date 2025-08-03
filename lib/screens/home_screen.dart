import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchCategories();
    productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Shop'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'All') {
                productProvider.fetchProducts();
              } else {
                productProvider.fetchProducts(category: value);
              }
            },
            icon: const Icon(Icons.category),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'All', child: Text('All Categories')),
              ...productProvider.categories
                  .map((c) => PopupMenuItem(value: c, child: Text(c.capitalize()))),
            ],
          ),
          PopupMenuButton<SortOption>(
            onSelected: productProvider.sortBy,
            icon: const Icon(Icons.sort),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: SortOption.priceLowToHigh,
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem(
                value: SortOption.priceHighToLow,
                child: Text('Price: High to Low'),
              ),
              const PopupMenuItem(
                value: SortOption.rating,
                child: Text('Rating'),
              ),
              const PopupMenuItem(
                value: null,
                child: Text('Clear Sorting'),
              ),
            ],
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => productProvider.fetchProducts(
          category: productProvider.selectedCategory,
        ),
        child: products.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 300),
            Center(child: Text('No Products Found')),
          ],
        )
            : GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.62,
          ),
          itemCount: products.length,
          itemBuilder: (ctx, i) => ProductCard(product: products[i]),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
