class Product {
  int id;
  String name;
  String model;
  int number;
  String description;
  int quantity_in_stocks;
  int price;
  String warranty_status;
  String distributor_info;
  int category_id;
  String image;
  //Date created_at;
  //updated_at;
  Product(int id, String name, String model, int number, String description, int quantity_in_stocks,int price, String warranty_status, String distributor_info, int category_id,String image ) {
    this.id = id;
    this.name = name;
    this.model = model;
    this.number = number;
    this.description = description;
    this.quantity_in_stocks = quantity_in_stocks;
    this.price = price;
    this.warranty_status = warranty_status;
    this.distributor_info = distributor_info;
    this.category_id = category_id;
    this.image = image;
  }
 /* factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
        name : json['name'] as String,
        model : json['model'],
        number: json['number'],
        description: json['description'],
        quantity_in_stocks: json['quantity_in_stocks'],
        price: json['price'],
        warranty_status: json['warranty_status'],
        distributor_info: json['distributor_info'],
        category_id: json['category_id'],
        image: json['image'],
    );
  }*/
  /*
  Product.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        model = json['model'],
        number= json['number'],
        description= json['description'],
        quantity_in_stocks= json['quantity_in_stocks'],
        price= json['price'],
        warranty_status= json['warranty_status'],
        distributor_info= json['distributor_info'],
        category_id= json['category_id'],
        image= json['image'];


  Map toJson() {
    return {'id': id, 'name': name, 'model': model, 'number': number,'description': description,'quantity_in_stocks': quantity_in_stocks,'price': price,'warranty_status': warranty_status, 'distributor_info': distributor_info,'category_id': category_id, 'image': image };
  }*/
}