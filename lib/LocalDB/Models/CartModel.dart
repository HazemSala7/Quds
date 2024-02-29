class CartItem {
  final int? id;
  final String productId;
  final String notes;
  final int ponus1;
  final int ponus2;
  final String name;
  final String image;
  final String color;
  final double price;
  final List<String> colorsNames;
  final double discount;
  int quantity;

  CartItem(
      {this.id,
      required this.productId,
      required this.notes,
      required this.color,
      required this.ponus1,
      required this.ponus2,
      required this.discount,
      required this.name,
      required this.colorsNames,
      required this.image,
      required this.price,
      this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'notes': notes,
      'color': color,
      'name': name,
      'image': image,
      'colorsNames': colorsNames.join(','),
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
      notes: json['notes'],
      name: json['name'],
      color: json['color'],
      colorsNames: (json['colorsNames'] as String).split(','),
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
    String? productId,
    String? notes,
    String? name,
    String? image,
    String? color,
    double? price,
    double? discount,
    List<String>? colorsNames,
    int? quantity,
    int? ponus1,
    int? ponus2,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      colorsNames: colorsNames ?? this.colorsNames,
      ponus1: ponus1 ?? this.ponus1,
      ponus2: ponus2 ?? this.ponus2,
      discount: discount ?? this.discount,
    );
  }
}
