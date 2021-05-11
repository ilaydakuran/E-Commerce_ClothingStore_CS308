import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  String description;
  int price;
  String imageUrl;
  String size;
  Color color;

  Product({ this.id, this.name, this.description, this.price, this.imageUrl, this.size, this.color });
}

class catagory {

  String name;
  String imageUrl;
  int categid;
  catagory({  this.name, this.imageUrl, this.categid });
}

