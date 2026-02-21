import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';

class CataloguePage extends StatefulWidget {
  final List<Product> products;

  const CataloguePage({super.key, required this.products});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  bool _isGridView = true;

  Widget _buildProductImage(String imagePath, {BoxFit fit = BoxFit.cover}) {
    final isLocalFile = imagePath.startsWith('/');
    return isLocalFile
        ? Image.file(File(imagePath), fit: fit, errorBuilder: _errorBuilder)
        : Image.asset(imagePath, fit: fit, errorBuilder: _errorBuilder);
  }

  Widget _errorBuilder(BuildContext ctx, Object err, StackTrace? st) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 36, color: Colors.grey[400]),
          const SizedBox(height: 4),
          Text('Image\nindisponible',
              style: TextStyle(fontSize: 10, color: Colors.grey[400]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // FONKSYON POU LOUVRI NOUVO FENÈT AK DETAY PWODWI
  void _openProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Catalogue', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (widget.products.isNotEmpty)
            IconButton(
              icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
              onPressed: () => setState(() => _isGridView = !_isGridView),
              tooltip: _isGridView ? 'Voir en liste' : 'Voir en grille',
            ),
        ],
      ),
      body: widget.products.isEmpty
          ? _buildEmptyState()
          : (_isGridView ? _buildProductGrid() : _buildProductList()),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.6,
        crossAxisSpacing: 8, mainAxisSpacing: 8,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) =>
          GestureDetector(
            onTap: () => _openProductDetails(widget.products[index]),
            child: _buildProductCard(widget.products[index], isGrid: true),
          ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.products.length,
      itemBuilder: (context, index) =>
          GestureDetector(
            onTap: () => _openProductDetails(widget.products[index]),
            child: _buildProductCard(widget.products[index], isGrid: false),
          ),
    );
  }

  Widget _buildProductCard(Product product, {required bool isGrid}) {
    if (isGrid) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: SizedBox(width: double.infinity,
                    child: _buildProductImage(product.image)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(product.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${product.price.toStringAsFixed(2)} €',
                        style: const TextStyle(fontSize: 11, color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
              child: SizedBox(width: 100, height: 100,
                  child: _buildProductImage(product.image)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(product.description,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${product.price.toStringAsFixed(2)} €',
                            style: const TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold, color: Colors.blue)),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart, size: 20),
                          color: Colors.blue,
                          onPressed: () {
                            // Anpeche propagation pou pa deklanche GestureDetector
                            // epi ajoute fonksyonalite panye si ou vle
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text('Catalogue vide', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          const SizedBox(height: 10),
          Text('Appuyez sur "Ajouter" pour créer votre premier produit',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// NOUVO PAGE POU DETAY PWODWI
class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  Widget _buildProductImage(String imagePath, {BoxFit fit = BoxFit.cover}) {
    final isLocalFile = imagePath.startsWith('/');
    return isLocalFile
        ? Image.file(File(imagePath), fit: fit, errorBuilder: _errorBuilder)
        : Image.asset(imagePath, fit: fit, errorBuilder: _errorBuilder);
  }

  Widget _errorBuilder(BuildContext ctx, Object err, StackTrace? st) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 36, color: Colors.grey[400]),
          const SizedBox(height: 4),
          Text('Image\nindisponible',
              style: TextStyle(fontSize: 10, color: Colors.grey[400]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAJ LA AN GWO
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: _buildProductImage(product.image, fit: BoxFit.cover),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NON PWODWI
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // PRIX
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${product.price.toStringAsFixed(2)} €',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TIT SEKSYON DESKRIPSYON
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // DESKRIPSYON PWODWI
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BOUTON AJOUTE NAN PANYE
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Ajoute lojik panye isit la si ou vle
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} ajouté au panier'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(
                        'AJOUTER AU PANIER',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}