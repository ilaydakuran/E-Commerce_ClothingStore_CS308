import 'dart:io';

import 'package:cs308_ecommerce/models/products.dart';
import 'package:cs308_ecommerce/routes/catagories.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:cs308_ecommerce/utils/dimension.dart';
import 'package:cs308_ecommerce/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cs308_ecommerce/productzoom.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/products.dart';
import '../productzoom.dart';
import 'search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'search.dart';


final String urle = "http://10.0.2.2:8000/api/cart/";
final String url_total = "http://10.0.2.2:8000/api/total";
final String urldel= "http://10.0.2.2:8000/api/cart/";

//final String url2 = "http://10.0.2.2:8000/api/cart/2/edit";
//final String url3 = "http://10.0.2.2:8000/api/cart/3/edit";
int total;
class Bag extends StatelessWidget {
  final ProductDetails product;
  final Function delete;
  static int adet;

  List<Bag> _cartList = List<Bag>();
  Bag({
    Key key,
    this.product,
    this.delete,

  }) : super(key: key);
  // String catid =${product.category_id;};
  // String lasturl= url +  + "/edit";
  @override
  Widget build(BuildContext context) {
    Bag bag;
    return Card(
      child: Column(
        children: [
          SizedBox(height: 50.0,),
          ListTile(
            leading: Image.asset(product.image,scale: 0.5,) ,
            title: Text(product.name,style: TextStyle(fontSize: 25.0),),
            subtitle: Text("\$${product.price}",style: TextStyle(fontSize: 15.0),),

          ),

        ],
      ),
    );
  }
}

class ShopCard extends StatefulWidget {
  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {

  double total;
  double subtotal;
  double realsubtot;
  int i=0;
  Future<void> _additem(Productcat prod) async {

    final String durl= urldel + prod.rowId;
    final url = Uri.parse(durl);
    setState(() {
      prod.qty++;

    });
    if(i==0){
      subtotal = double.parse(prod.price);
    }
    setState(() {
      prod.price = (subtotal* prod.qty).toString();
    });

    final body = {
      //  'call': 'shoppingbag',
      'qty': prod.qty,

    };
    Map<String, String> headers = {"Content-type": "application/json"};
    //String json = '{"title": "shoppingbag", "body": "quantity"}';
    // make PUT request
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    Response response = await patch(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
      body: jsonEncode(body),
    );
   // Response response = await patch(url, headers: headers, body:jsonEncode(body));
    setState(() {
      checkouttot();
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    // print(total);


  }

  Future<Null> checkouttot() async {
    final url= Uri.parse(url_total);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    final response = await http.get(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
    );
   /* final response = await http.get(Uri.parse(url_total));*/
    final responseJson = json.decode(response.body);
    print(responseJson);
    //print(entry.value["name"]);
    setState(() {
      /*for (var comment in responseJson) {
            // print(comment["comment"].toString());
            //_comments.add(comment["comment"].toString());

          }*/
      total=double.parse(responseJson);
      print(total);
    });
  }
  @override
  void initState() {
    super.initState();
    checkouttot();

  }

  Future<void> _removeitem(Productcat prod) async {
    final String durl= urldel + prod.rowId;
    final url = Uri.parse(durl);

    setState(() {
      if(prod.qty>1){
        prod.qty--;
      }
    });

    final body = {
      //'call': 'shoppingbag',
      'qty': prod.qty,

    };

    Map<String, String> headers = {"Content-type": "application/json"};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    Response response = await patch(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
      body: jsonEncode(body),
    );
    // make patch request
    //Response response = await patch(url, headers: headers, body: jsonEncode(body));
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    setState(() {
      checkouttot();
    });

  }

  Future<Null> _deletefunc(String a) async {
    /*final String durl= urldel + a;
    final url = Uri.parse(durl);*/
    final url= Uri.parse(urldel + a);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    Response response = await delete(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
    );
    // make DELETE request
    //Response response = await delete(url);
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    setState(() {
      checkouttot();
    });
  }

  @override
  Widget build(BuildContext context) {

    //final Product prod;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your shopping bag',
          style: kAppBarTitleTextStyle,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: [

            SizedBox(height: 30.0),
            Expanded(child:_Prods.length != 0
                ? new ListView.builder(
              itemCount: _Prods.length,
              itemBuilder: (context, i) {
                return TouchableOpacity(
                  child: new Card(
                    child: new ListTile(
                      //leading: //new Image.network(_Prods[i].image,), /*new CircleAvatar(backgroundImage: new NetworkImage(
                      // _searchResult[i].image,),),*/
                      title: new Text(_Prods[i].name, style: TextStyle(color: Colors.black),),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            width: 100,

                            child: Text("price: \$" + _Prods[i].subtotal,
                              style: TextStyle(fontWeight: FontWeight.bold),),
                          ),

                          new Container(
                            child: new IconButton(
                              icon: new Icon(Icons.remove),
                              highlightColor: Colors.green,
                              onPressed: (){
                                _removeitem(_Prods[i]);
                                setState(() {
                                }
                                );

                              },
                            ),
                          ),
                          new Container(
                              child: new Text('${_Prods[i].qty}',
                                style: TextStyle(fontSize: 20 ,),)
                          ),
                          new Container(
                            child: new IconButton(
                              icon: new Icon(Icons.add),
                              highlightColor: Colors.green,
                              onPressed: (){
                                _additem(_Prods[i]);
                                /* setState(() {
                                    Prods[i].subtotal = _Prods[i].price * _Prods[i].qty;
                                  });*/
                              },

                            ),
                          ),

                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                _deletefunc(_Prods[i].rowId);
                                setState(() {
                                  _Prods.removeWhere((item) => item.rowId == _Prods[i].rowId);
                                });
                              }),
                          //Text(_Prods[i].model,style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    margin: const EdgeInsets.all(0.0),
                  ),
                  onTap: (){}//()  => Navigator.of(context).push(MaterialPageRoute(builder:(context)=>productScreen(_Prods[i],))),
                );
              },
            )
                : new Text("-Your basket is empty-", style: TextStyle(fontSize: 25.0,),),
            ),
            Text('Total amount: ' + "${total}", style: TextStyle(fontSize: 25.0,),), 

            OutlinedButton(
              child: Text(
                "Checkout",
                style: TextStyle(color: AppColors.primary, fontSize: 30.0),

              ),
              onPressed: (){
                Navigator.pushNamed(context, '/payment');
              },
            ),

            BottomAppBar(
              color: Colors.white,
              child:  Container(
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: Icon(Icons.home), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/search');}),
                    IconButton(icon: Icon(Icons.menu), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/catagories');} ),
                    IconButton(icon: Icon(Icons.person), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/profile');} ),
                    IconButton(icon: Icon(Icons.shopping_bag_outlined), iconSize: 30.0, color: AppColors.primary, onPressed: (){  Navigator.pushNamed(context, '/shoppingbag');}),
                    IconButton(icon: Icon(Icons.payment), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/payment');}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Shoppingbag extends StatefulWidget {
  //final String value;
  //ProductDetails prod;
  //Shoppingbag(this.prod);
  int catid;
  Shoppingbag(this.catid);
  /*State<StatefulWidget> createState() {
    return _shopbagState(this.catid);
    // return _shopbagState(this.prod);
  }*/
  @override
  _shopbagState createState() => _shopbagState();
}

class amount {
  int total;
  amount({this.total});
  factory amount.fromJson(Map<String, dynamic> json) {
    return new amount(
      total: json['total'],
    );
  }
}
List<amount> amountlist = [];

class _shopbagState extends State<Shoppingbag> {
  // String _isInit = "false";

  // ProductDetails prod;
  //_shopbagState(this.prod);
  //TextEditingController controller = new TextEditingController();
  //var _textController = new TextEditingController();
  Future<Null> getproduct() async {
    int i =widget.catid;
    final url= Uri.parse(urle + i.toString() + "/edit");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    final response = await http.get(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
    );
   // print(url);
   // final response = await http.get(Uri.parse(furl));
    Map<String, dynamic> jsonMap = json.decode(response.body);
    setState(() {
      for (var entry in jsonMap.entries) {
        _Prods.add(Productcat.fromJson(entry.value));
        /* String pname=entry.value["name"];
      _Prods.add(pname);*/
        //print(entry.value["name"]);
        print("${entry.key} ==> ${entry.value}");
        print("ok");
      }
    });
  }

  Future<Null> _deletefunc(String a) async {
    // int i =widget.catid;
   // final String durl= urldel + a;
    //final url = Uri.parse(durl);
    final url= Uri.parse(urldel + a);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    Response response = await delete(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
    );
   // Response response = await delete(url);
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
  }
  /* Future<int> checkouttotal()  async {
    final response = await http.get(Uri.parse(url_total));
    final responseJson = json.decode(response.body);

    print(response.body);
    setState(() {
      for (Map entry in responseJson) {
        amountlist.add(amount.fromJson(entry));
      }
      return amountlist;
    });
  }*/

  @override
  void initState() {
    super.initState();
    _Prods.clear();
    getproduct();
    amountlist.clear();
    //checkouttotal();

  }


  @override
  Widget build(BuildContext context) {

    //final Product prod;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your shopping bag',
          style: kAppBarTitleTextStyle,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
              child: //_Prods.length != 0
              new ListView.builder(
                itemCount: _Prods.length,
                itemBuilder: (context, i) {
                  return new Card(
                    child: new ListTile(
                      //leading: //new Image.network(_Prods[i].image,), /*new CircleAvatar(backgroundImage: new NetworkImage(
                      // _searchResult[i].image,),),*/
                      title: new Text(_Prods[i].name, style: TextStyle(color: Colors.black),),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            width: 300,
                            child: Text("price: \$" + _Prods[i].price,
                              style: TextStyle(fontWeight: FontWeight.bold),),
                          ),

                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                _deletefunc(_Prods[i].rowId);
                                setState(() {
                                  _Prods.removeWhere((item) => item.rowId == _Prods[i].rowId);
                                });
                              }),
                          //Text(_Prods[i].model,style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    margin: const EdgeInsets.all(0.0),
                  );
                },
              )
          ),

          SizedBox(height: 10.0,),
          BottomAppBar(
            color: Colors.white,
            child:  Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: Icon(Icons.home), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/search');}),
                  IconButton(icon: Icon(Icons.menu), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/catagories');} ),
                  IconButton(icon: Icon(Icons.person), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/profile');} ),
                  IconButton(icon: Icon(Icons.shopping_bag_outlined), iconSize: 30.0, color: AppColors.primary, onPressed: (){  Navigator.pushNamed(context, '/shoppingbag');}),
                  IconButton(icon: Icon(Icons.payment), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/payment');}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Productcat> _Prods = [];