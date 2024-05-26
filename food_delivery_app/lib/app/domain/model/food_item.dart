class FoodItem {
  String image;
  String name;
  String description;
  String shortDescription;
  int deliveryTime;
  String category;
  double price;

  FoodItem({
    required this.image,
    required this.deliveryTime,
    required this.description,
    required this.shortDescription,
    required this.name,
    required this.price,
    required this.category,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      image: json['image'],
      deliveryTime: json['deliveryTime'],
      description: json['description'],
      shortDescription: json['shortDescription'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'deliveryTime': deliveryTime,
      'description': description,
      'shortDescription': shortDescription,
      'name': name,
      'price': price,
      'category': category,
    };
  }
}
