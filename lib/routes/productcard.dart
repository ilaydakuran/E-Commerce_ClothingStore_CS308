import 'package:cs308_ecommerce/models/products.dart';
import 'package:cs308_ecommerce/routes/search.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final ProductDetails product;
  final Function press;
  const ItemCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                //color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}",
                child: Image.network(product.image,),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0.0, 5, 0),
              child: Text(
                // products is out demo list
                product.name,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0.0, 5, 0),
            child: Text(
              "\$${product.price}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}