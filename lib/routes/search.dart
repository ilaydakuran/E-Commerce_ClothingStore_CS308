import 'package:cs308_ecommerce/models/products.dart';
import 'package:cs308_ecommerce/productzoom.dart';
import 'package:cs308_ecommerce/routes/productcard.dart';
import 'package:cs308_ecommerce/routes/product.dart';
import 'package:cs308_ecommerce/routes/catagories.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:cs308_ecommerce/utils/dimension.dart';
import 'package:cs308_ecommerce/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cs308_ecommerce/bottombar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = ["Woman", "Man"];
  // By default our first item will be selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? Colors.black87 :  Colors.black54,
                fontSize: 15.0,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0 / 4), //top padding 5
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
class _searchState extends State<search> {

  TextEditingController controller = new TextEditingController();
  bool isInitialized = false;

  Future<Null> getProduct() async {
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map prod in responseJson) {
        _prodDetails.add(ProductDetails.fromJson(prod));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _prodDetails.clear();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Center(child: new Text('Home')),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[200],
      ),
      body: new Column(
        children: <Widget>[
          new Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none,),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(
                icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ),
          ),
          Categories(),
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new GridView.builder(
                itemCount: _searchResult.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => ItemCard(
                  product: _searchResult[index],
                  press: ()=> Navigator.of(context).push(MaterialPageRoute(builder:(context)=>productScreen( _searchResult[index]))),

                  /* => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productScreen(
                          product: _searchResult[index],
                        ),
                      )),*/
                ))
                : new GridView.builder(
                itemCount: _prodDetails.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, i) => ItemCard(
                  product: _prodDetails[i],
                  press: ()  => Navigator.of(context).push(MaterialPageRoute(builder:(context)=>productScreen(_prodDetails[i],))),
                  /*=> Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productScreen(
                          product: _prodDetails[i],
                        ),
                      )),*/
                )),
          ),


          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(Icons.home),
                    iconSize: 30.0,
                    color: AppColors.primary,
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    }),
                IconButton(icon: Icon(Icons.menu),
                    iconSize: 30.0,
                    color: Colors.black87,
                    onPressed: () {
                      Navigator.pushNamed(context, '/catagories');
                    }),
                IconButton(icon: Icon(Icons.person),
                    iconSize: 30.0,
                    color: Colors.black87,
                    onPressed: () {
                      prof();
                      //Navigator.pushNamed(context, '/profile');
                    }),
                IconButton(icon: Icon(Icons.shopping_bag_outlined),
                    iconSize: 30.0,
                    color: Colors.black87,
                    onPressed: () {
                      Navigator.pushNamed(context, '/shoppingbag');
                    }),
              ],
            ),
          ),
          //),
          // ),
        ],
      ),
    );

  }
  Future<void> prof() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isinited= prefs.getBool("initialize11");
    if(isinited==null){
      prefs.setBool("initialize11",true);
      Navigator.pushNamed(context, '/welcome');
    }
    else{
      Navigator.pushNamed(context, '/profile');
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _prodDetails.forEach((prodDetail) {
      // if (prodDetail.firstName.contains(text) || userDetail.lastName.contains(text))
      if (prodDetail.name.toLowerCase().contains(text)|| prodDetail.name.contains(text)|| prodDetail.name.toUpperCase().contains(text))
        _searchResult.add(prodDetail);
    });

    setState(() {});
  }
}
List<ProductDetails> _searchResult = [];
List<ProductDetails> _prodDetails = [];

final String url = "http://localhost:8000/api/product";
class ProductDetails {
  final int id, category_id, price;
  final String name, model, description, image;

  ProductDetails({this.id, this.name, this.model, this.description, this.image, this.price, this.category_id});

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return new ProductDetails(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      category_id: json['category_id'],
    );
  }
}
class Productcat {
  //final int id, price;
  final String name, id, price, rowId,subtotal;
   int qty;

  Productcat({this.id, this.name, this.price, this.rowId,this.qty,this.subtotal});

  factory Productcat.fromJson(Map<String, dynamic> json) {
    return new Productcat(
      id: json['id'].toString(),
      name: json['name'],
      qty: json['qty'],
      subtotal: json['subtotal'].toString(),
      price: json['price'].toString(),
      rowId: json['rowId'],
    );
  }
}


