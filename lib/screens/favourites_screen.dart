import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/drawer_widget.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      drawer: const DrawerWidget(),
      body: favProvider.favourites.isEmpty
          ? const Center(child: Text('No favourite products'))
          : SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: favProvider.favourites.length,
          itemBuilder: (ctx, i) => ProductCard(product: favProvider.favourites[i]),
        ),
      ),
    );
  }
}
