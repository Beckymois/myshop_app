import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'catalogue_page.dart';
import 'add_product_page.dart';
import '../models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Lis pwodwi yo
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Chaje pwodwi yo lè aplikasyon an ouvri
  }

  // FONKSYON POU CHAJE PWODWI DEPI SHARED PREFERENCES
  Future<void> _loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> productsJson = prefs.getStringList('products') ?? [];

      setState(() {
        _products = productsJson.map((json) {
          try {
            return Product.fromMap(jsonDecode(json));
          } catch (e) {
            print('Erè nan dekode yon pwodwi: $e');
            return null;
          }
        }).whereType<Product>().toList();
      });

      print('${_products.length} pwodwi chaje avèk siksè!');
    } catch (e) {
      print('Erè nan chajman pwodwi: $e');
    }
  }

  // FONKSYON POU AJOUTE YON PWODWI
  Future<void> _onProductAdded(Product newProduct) async {
    try {
      // Ajoute nan lis la
      setState(() {
        _products.add(newProduct);
      });

      // Sove nan SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> productsJson = _products.map((p) => jsonEncode(p.toMap())).toList();
      await prefs.setStringList('products', productsJson);

      // Redireksyon nan Catalogue
      setState(() {
        _currentIndex = 1;
      });

      // Mesaj konfimasyon
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newProduct.name} ajouté avec succès!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // FONKSYON POU EFAZE TOUT PWODWI (SI OU BEZWEN)
  Future<void> _clearAllProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('products');
      setState(() {
        _products.clear();
      });
    } catch (e) {
      print('Erè nan efasman: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // AJOUTE ValueKey POU FÒSE CataloguePage REBUILD
    final List<Widget> pages = [
      const AccueilPage(),
      CataloguePage(
        products: _products,
        key: ValueKey(_products.length), // ← AJOUTE SA POU RAFRECHI OTOMATIKMAN
      ),
      AddProductPage(onProductAdded: _onProductAdded),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          // BOUTON POU EFAZE (SI OU BEZWEN POU TEST)
          // IconButton(
          //   icon: const Icon(Icons.delete_sweep),
          //   onPressed: _clearAllProducts,
          //   tooltip: 'Efaze tout pwodwi',
          // ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Catalogue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Ajouter',
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.lightBlue.shade600, size: 28),
              const SizedBox(width: 10),
              const Text('Déconnexion',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('ANNULER',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade600,
                foregroundColor: Colors.white,
                elevation: 2,
              ),
              child: const Text('DÉCONNECTER',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Déconnexion réussie'),
            ],
          ),
          backgroundColor: Colors.lightBlue.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

// PAGE ACCUEIL
class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final homeState = context.findAncestorStateOfType<_HomePageState>();
        homeState?.setState(() => homeState._currentIndex = 0);
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo_jk.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Votre boutique en ligne de confiance pour des produits de qualité au meilleur prix.\n\n'
                      'Chez JK Store, nous vous proposons une sélection moderne et soignée de produits adaptés à vos besoins quotidiens.',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                          blurRadius: 8,
                          color: Colors.black45,
                          offset: Offset(1, 1)
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}