import 'package:cs308_ecommerce/productzoom.dart';
import 'package:cs308_ecommerce/routes/catagories.dart';
import 'package:cs308_ecommerce/routes/productcard.dart';
import 'package:cs308_ecommerce/routes/search.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class catDisplay extends StatefulWidget {
  int id;
  catDisplay(this.id);
  @override
  State<StatefulWidget> createState() {
    return _cdisplayState(this.id);
  }
/*
  @override
  _cdisplayState createState() => _cdisplayState();*/
}
final String url = "http://10.0.2.2:8000/api/category/1";
final String url2 = "http://10.0.2.2:8000/api/category/2";
final String url3 = "http://10.0.2.2:8000/api/category/3";
class _cdisplayState extends State<catDisplay> {
  int id;
  _cdisplayState(this.id);

  TextEditingController controller = new TextEditingController();

  Future<Null> getProduct() async {
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map prod in responseJson) {
        _finalProds.add(ProductDetails.fromJson(prod));
      }
    });
  }
  Future<Null> getProduct2() async {
    final response = await http.get(Uri.parse(url2));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map prod in responseJson) {
        _finalProds.add(ProductDetails.fromJson(prod));
      }
    });
  }
  Future<Null> getProduct3() async {
    final response = await http.get(Uri.parse(url3));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map prod in responseJson) {
        _finalProds.add(ProductDetails.fromJson(prod));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _finalProds.clear();
    if(widget.id==1){
      getProduct() ;}
    else if(widget.id==2){
      getProduct2() ;}
    else if(widget.id==3){
      getProduct3() ;}
  }
  Widget categoryapp(){

    if(widget.id==1){return Row(children: [SizedBox(width:100,),new Text('T-shirt')]);}
    else if(widget.id==2){return Row(children: [SizedBox(width:100,),new Text('Shoes')]);}
    else if(widget.id==3){return Row(children: [SizedBox(width:100,),new Text('Trousers')]);}

  }
  String a;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: categoryapp(),
        elevation: 0.0,
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
          //Categories(),
          new Expanded(
            child: _searchresult.length != 0 || controller.text.isNotEmpty
                ? new GridView.builder(
                itemCount: _searchresult.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => ItemCard(
                  product: _searchresult[index],
                  press: ()  => Navigator.of(context).push(MaterialPageRoute(builder:(context)=>productScreen( _searchresult[index]))),
                 /* => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productScreen(
                          product: _searchresult[index],
                        ),
                      )),*/
                ))
                : new GridView.builder(
                itemCount: _finalProds.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, i) => ItemCard(
                  product: _finalProds[i],
                  press: () => Navigator.of(context).push(MaterialPageRoute(builder:(context)=>productScreen(_finalProds[i]))),
                  /*=> Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productScreen(
                          product: _finalProds[i],
                        ),
                      )),*/
                )),
          ),
        ],
      ),
    );
  }
  onSearchTextChanged(String text) async {
    _searchresult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _finalProds.forEach((prodDetail) {
      // if (prodDetail.firstName.contains(text) || userDetail.lastName.contains(text))
      if (prodDetail.name.toLowerCase().contains(text)|| prodDetail.name.contains(text)|| prodDetail.name.toUpperCase().contains(text))
        _searchresult.add(prodDetail);
    });

    setState(() {});
  }
}
List<ProductDetails> _searchresult = [];

//List<ProductDetails> _catProds= [];

List<ProductDetails> _finalProds= [];