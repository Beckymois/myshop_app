import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key, required Future<void> Function(Product newProduct) onProductAdded});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (pickedFile != null) {
        setState(() => _selectedImageFile = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choisir une image',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageSourceButton(
                    icon: Icons.photo_library,
                    label: 'Galerie',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  _ImageSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Caméra',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // FONKSYON POU SOVE PWODWI AK SHARED PREFERENCES
  Future<void> _saveProduct(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Li lis pwodwi ki egziste deja
      List<String> productsJson = prefs.getStringList('products') ?? [];

      // Ajoute nouvo pwodwi a
      productsJson.add(jsonEncode(product.toMap()));

      // Sove lis la
      await prefs.setStringList('products', productsJson);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produit "${product.name}" ajouté avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Reinitialize fòm lan
      _formKey.currentState!.reset();
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() => _selectedImageFile = null);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une image pour le produit'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final newProduct = Product(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        image: _selectedImageFile!.path,
      );

      // Sove pwodwi a ak SharedPreferences
      _saveProduct(newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du produit',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Veuillez entrer le nom du produit'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Veuillez entrer la description'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Prix (€)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Veuillez entrer le prix';
                final parsed = double.tryParse(value);
                if (parsed == null) return 'Veuillez entrer un nombre valide';
                if (parsed <= 0) return 'Le prix doit être supérieur à 0';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Section image
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_selectedImageFile != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImageFile!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ] else
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text('Aucune image sélectionnée',
                                style: TextStyle(color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text(_selectedImageFile == null
                          ? 'Choisir une image'
                          : 'Changer l\'image'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: const Text(
                'AJOUTER LE PRODUIT',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  const _ImageSourceButton(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.blue.shade50, shape: BoxShape.circle),
            child: Icon(icon, size: 36, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}