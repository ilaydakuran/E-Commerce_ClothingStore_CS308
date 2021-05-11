import 'package:cs308_ecommerce/routes/search.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:flutter/material.dart';
import 'models/products.dart';
import 'models/products.dart';
import 'routes/shoppingbag.dart';
import 'package:cs308_ecommerce/models/products.dart';
import 'package:cs308_ecommerce/productzoom.dart';
import 'package:cs308_ecommerce/routes/productcard.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

TextEditingController controller = new TextEditingController();
//var _textController = new TextEditingController();
class productScreen extends StatelessWidget {
  final ProductDetails product;
  //final GlobalKey<FormState> _formKeyName= GlobalKey<FormState>();
  String comment;
  final _formKey = GlobalKey<FormState>();
  productScreen({Key key, this.product}) : super(key: key); //bastaki const silindi

  Widget _buildcomment(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Add comment"),
      validator: (String value){
        if(value.isEmpty){
          return "Cannot add empty comment";
        }
      },
      onSaved: (String value){
        comment=value;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      //backgroundColor: product.color,
      appBar: AppBar(
        title: Text(
          product.name,

        ),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child:ListView(
          children:[ Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(child: Column(
                children: [
                  Padding(padding: const EdgeInsets.all(10.0),
                    child: Container(width: 200, height: 200, child: Image.network(product.image)),

                  ),
                ],
              ),
              ),
              SizedBox(height: 20.0,),
              Card(

                child: Center(
                  child: Column(
                    children: [
                      Text(product.model,style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)),
                      Text(product.description,style: TextStyle(fontSize: 25.0)),
                    ],
                  ),
                ),

                color: AppColors.textColor,

              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),

              _buildcomment(),
              SizedBox(height: 20.0,),
              Row(children: [Text("Rate the product: "),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                SizedBox(width: 30),
                OutlinedButton(onPressed: (){}, child: Icon(Icons.check)),
              ],),

              SizedBox(height: 90.0,),
              ElevatedButton(
                  child: Text(
                      "Add to Cart".toUpperCase(),
                      style: TextStyle(fontSize: 30)
                  ),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[200]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.purple[200])
                          )
                      )
                  ),
                  onPressed: (){
                    //bag.addItem(product.id, product.name, product.price);
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Shoppingbag(product.id)));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('product is succesfully added to your bag'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            SnackBar();
                          },
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
          ],
        ),
      ),
    );


  }
}