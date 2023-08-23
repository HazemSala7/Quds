class CartItem {
  final int? id;
  final int productId; // Unique identifier for the product
  final int ponus1;
  final int ponus2;
  final String name;
  final double price;
  int quantity;

  CartItem(
      {this.id,
      required this.productId,
      required this.ponus1,
      required this.ponus2,
      required this.name,
      required this.price,
      this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'ponus1': ponus1,
      'ponus2': ponus2,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      ponus1: json['ponus1'],
      ponus2: json['ponus2'],
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    String? name,
    double? price,
    int? quantity,
    int? ponus1,
    int? ponus2,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      ponus1: ponus1 ?? this.ponus1,
      ponus2: ponus2 ?? this.ponus2,
    );
  }
}
