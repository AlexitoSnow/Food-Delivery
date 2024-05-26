class FoodCart {
  final String name;
  final int quantity;
  final double totalPrice;
  final String image;

  FoodCart({
    required this.name,
    required this.quantity,
    required this.totalPrice,
    required this.image,
  });

  factory FoodCart.fromJson(Map<String, dynamic> json) {
    return FoodCart(
      name: json['name'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'image': image,
    };
  }
}
