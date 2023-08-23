class CartItem {
  final int? id;
  final int productId; // Unique identifier for the product
  final int ponus1;
  final int ponus2;
  final String name;
  final String image;
  final double price;
  final double discount;
  int quantity;

  CartItem(
      {this.id,
      required this.productId,
      required this.ponus1,
      required this.ponus2,
      required this.discount,
      required this.name,
      required this.image,
      required this.price,
      this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'ponus1': ponus1,
      'ponus2': ponus2,
      'discount': discount,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
      ponus1: json['ponus1'],
      ponus2: json['ponus2'],
      discount: json['discount'],
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    String? name,
    String? image,
    double? price,
    double? discount,
    int? quantity,
    int? ponus1,
    int? ponus2,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      ponus1: ponus1 ?? this.ponus1,
      ponus2: ponus2 ?? this.ponus2,
      discount: discount ?? this.discount,
    );
  }
}
