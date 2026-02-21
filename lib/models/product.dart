class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;  // Sèlman non fichye imaj la (asset)

  Product({
    String? id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,  // Ex: 'produit1.jpg', 'tshirt_bleu.png'
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, image: $image}';
  }

  // Konvèsyon pou Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  // Kreye Product depi Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }

  // Metòd pou jwenn chemen imaj la nan assets
  String get assetPath => 'products/$image';
}// class Product {
//   final String id;
//   final String name;
//   final double price;
//   final String description;
//   final String image;
//
//   Product({
//     String? id,
//     required this.name,
//     required this.price,
//     required this.description,
//     required this.image, required String imageUrl,
//   }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is Product &&
//               runtimeType == other.runtimeType &&
//               id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
//
//   @override
//   String toString() {
//     return 'Product{id: $id, name: $name, price: $price}';
//   }
//
//   // Pour faciliter la conversion si nécessaire
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//       'description': description,
//       'image': image,
//     };
//   }
//
//   // Pour créer un Product depuis une Map
//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       id: map['id'] as String?,
//       name: map['name'] as String,
//       price: (map['price'] as num).toDouble(),
//       description: map['description'] as String,
//       image: map['image'] as String, imageUrl: '',
//     );
//   }
//
//   String? get imageUrl => null;
// }