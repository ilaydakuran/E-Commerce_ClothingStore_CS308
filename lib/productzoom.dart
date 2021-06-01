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
import 'package:http/http.dart' as http;
//final String url = "http://10.0.2.2:8000/api/review";
import 'dart:convert';
TextEditingController controller = new TextEditingController();
class productScreen extends StatefulWidget {
  ProductDetails product;
  productScreen(this.product);
  @override
  State<StatefulWidget> createState() {
    return  _productScreenState(this.product);
  }
  /*@override
  _productScreenState createState() => _productScreenState();*/
}

class _productScreenState extends State<productScreen> {
  ProductDetails product;
  _productScreenState(this.product);
  //String comment;
  //int prodid;
  String comment;
  double rate= 3.00;
  final _formKey = GlobalKey<FormState>();

  final url= "http://10.0.2.2:8000/api/reviews/";


  Future<Null> getComments() async {
    final url2= url + "${product.id}";
    print(product.id);
    final response = await http.get(Uri.parse(url2));
    final responseJson = json.decode(response.body);
    print(responseJson);
    //print(entry.value["name"]);
    setState(() {
      for (var comment in responseJson) {
       // print(comment["comment"].toString());
        _comments.add(comment["comment"].toString());

      }
    });
   /* Map<String, dynamic> jsonMap = json.decode(response.body);
    setState(() {
      for (var entry in jsonMap.entries) {
        _comments.add(comments.fromJson(entry.value));
        /* String pname=entry.value["name"];
      _Prods.add(pname);*/
        //print(entry.value["name"]);
        print("${entry.key} ==> ${entry.value}");
        print("ok");
      }
    });*/
   // final jsonMap = json.decode(response.body);
   // List<dynamic> jsonMap = json.decode(response.body);
    /*setState(() {
      for (var comment in jsonMap) {
        _comments.add(comment);
      }
    });*/
  }
  double avgrate;
  final urlrate= "http://10.0.2.2:8000/api/average/";
  Future<Null> getrate() async {
    final url2= urlrate + "${product.id}";
    print(product.id);
    final response = await http.get(Uri.parse(url2));
    final responseJson = json.decode(response.body);
    print(responseJson);
    //print(entry.value["name"]);
    setState(() {
      /*for (var comment in responseJson) {
        // print(comment["comment"].toString());
        //_comments.add(comment["comment"].toString());

      }*/
      avgrate=double.parse(responseJson);
      print(avgrate);
    });
  }
  @override
  void initState() {
    super.initState();
    _comments.clear();
    getComments();
    getrate();
  }
  Future<void> _addcomment() async {
    final url = Uri.parse("http://10.0.2.2:8000/api/review");
    print(comment);
    print(product.id);
    print(rate);
    //int id =product.id.toInt();
    var body = {
      //'call': 'productzoom',
      'product_id': product.id.toString(),
      'comment': comment,
      'rating': rate.toString(),
    };

    final response = await http.post(
      Uri.http(url.authority, url.path),
      headers: <String, String> {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),
    );

    if(response.statusCode >= 200 && response.statusCode < 300) {
      //Successful transmission
      //Map<String, dynamic> jsonMap = json.decode(response.body);
      final responseJson = json.decode(response.body);
      print(response.body);
     /* for(var entry in jsonMap.entries) {
        print("${entry.key} ==> ${entry.value}");
       /* if (entry.value=="Invalid Credentials"){
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Login failed, try again')));
          //Navigator.pushNamed(context, '/search');


        }*/
        print("ok");
      }*/

    }
    else if(response.statusCode >= 400 && response.statusCode < 500) {
     /* Map<String, dynamic> jsonMap = json.decode(response.body);

      for(var entry in jsonMap.entries) {
        print("${entry.key} ==> ${entry.value}");
      }*/
      final responseJson = json.decode(response.body);
      print(response.body);

    //  showAlertDialog('WARNING', jsonMap['error_msg']);
    }

  }

  Widget _buildcomment(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Add comment"),
      validator: (String value){
        if(value.isEmpty){
          return "Cannot add empty comment";
        }
        return null;
      },
      onSaved: (String value){
        setState(() {
          comment=value;
        });
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
              /*RatingBar.readOnly(
                initialRating: avgrate,
                isHalfAllowed: true,
                itemSize: 30,
                halfFilledIcon: Icons.star_half,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
              ),*/

             /* RatingBarIndicator(
                rating: avgrate,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 30.0,
                direction: Axis.horizontal,
              ),*/
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
                  setState(() {
                    rate=rating;
                  });

                },

              ),
              Form(
                key: _formKey,
              child:
              Column(
                children: [
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
                    setState(() {
                      rate=rating;
                    });

                  },

                ),
                SizedBox(width: 30),
                OutlinedButton(onPressed: (){
                  if(_formKey.currentState.validate()) {
                  // _formKey.currentState.validate()
                    _formKey.currentState.save();
                    _addcomment();

                  }
                  }, child: Icon(Icons.check)),
              ],),
                ],
              ),
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                  child: Text(
                      "Add to Cart".toUpperCase(),
                      style: TextStyle(fontSize: 25)
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
                Container(
                    height: 200,
                    child: new ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                         return new Card(
                            child: new ListTile(
                              //leading: SizedBox(width: 100,child: new Image.asset(cats[index].imageUrl,)),
                              title: new Text(_comments[index]),
                            ),
                            margin: const EdgeInsets.all(1.0),
                          );

                      },

                    ),
                  ),

            ],
          ),
          ],
        ),
      ),
    );


  }
}
/*class comments {
  //final int id, price;
  final String comment;

  comments({this.comment});

  factory comments.fromJson(String json) {
    return new comments(
      comment: json['comment'],
    );
  }
}*/
class comments {
  //final int id, price;
  final String comment;

  comments({this.comment});

  factory comments.fromJson(Map<String, dynamic> json) {
    return new comments(
      comment: json['comment'],
    );
  }
}
List<String> _comments = [];
//var _textController = new TextEditingController();
/*
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
}*/