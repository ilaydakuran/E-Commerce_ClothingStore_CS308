import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:cs308_ecommerce/routes/catagories.dart';
import 'package:cs308_ecommerce/routes/welcome.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class profile {
  String name;

  profile({ this.name });
}

class profCard extends StatelessWidget {
  /*int cardnum;
  String username;
  String address;*/

  final profile myprof;
  final Function press;
  const profCard({
    Key key,
    this.myprof,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      child: Card(
        //margin: EdgeInsets.symmetric(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Row(
                children: [
                  SizedBox(width: 20.0),
                  //TouchableOpacity(child:
                  Text( myprof.name,
                    style: TextStyle(
                      fontFamily: 'BrandonText',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  // onTap: (){},
                  //),
                  SizedBox(width: 100.0),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: (){},
    );
  }
}

List<profile> profiles = [
  profile(name: "Orders"),
  profile(name: "Your card"),
  profile(name: "Address"),
  profile(name: "Your info"),

];


class Profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();


}
class _profileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  //String name='';
  Future<Null> _getprofile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    print("denemeeeeeeeeeeeeee");
    print(access);
    if(access== null){
      Navigator.pushNamed(context, '/welcome');
    }
    else{
      Profile();
    }
  }
  void initState() {
    super.initState();
    _orderslist.clear();
    liste.clear();
    _getprofile();
    _orders();
  }
  List<pivot> _pivotinf=[];
  Future<void> _orders() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/order');
    /* var body = {
      'call': 'catagories',
      // 'categoryname': categoryname,
    };*/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    final response = await http.get(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
      /* headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        'Authorization': 'Bearer $access',
      },*/
      //body: body,
      // encoding: Encoding.getByName("utf-8"),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      //Successful transmission
      List<dynamic> jsonMap=json.decode(response.body);

      //List<dynamic> jsonMap = json.decode(response.body);
      for (var entry in jsonMap)
      {
        int i=0;
        for (var entry2 in entry) {

          print("${entry2}");

                print("ok");
                setState(() {
                  _orderslist.add(Productorder.fromJson(entry2));

                });

        }
      }
    }
  }
 /* List<String> parray=[];
   _pivot(Map pivot) {

    for(var v in pivot.entries){
      setState(() {
        parray.add(v.toString());
      });
    }

  }*/
  Future logout() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/logout');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    final response = await http.get(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
    );
     prefs.setString('accesstoken', null);
    Navigator.pushNamed(context, '/search');
    print(response.statusCode);
  }
  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child:  Container(
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: Icon(Icons.home), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/search');}),
              IconButton(icon: Icon(Icons.menu), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/catagories');} ),
              IconButton(icon: Icon(Icons.person), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/profile');} ),
              IconButton(icon: Icon(Icons.shopping_bag_outlined), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/shoppingbag');}),
            ],
          ),
        ),
      ),

      appBar: new AppBar(
        title: Padding(
            padding: EdgeInsets.fromLTRB(150, 0, 50, 0), child: new Text('Profile')),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[200],
        actions: [
          TextButton.icon(
            onPressed: () async {
              await logout();
            },
            icon: Icon(Icons.person, size: 20.0, color: Colors.deepPurple,),
            label: Text('Logout', style: TextStyle(fontSize: 20, color: Colors.deepPurple),),
          ),
        ],
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Expanded(

              child: Column(
                // shrinkWrap: true,
                //  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  children: <Widget>[

                    SizedBox(height: 60.0,),
                    TextFormField(
                      autocorrect: true,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        hintText: "Write your name and surname",
                        errorStyle: TextStyle(
                          fontSize: 13.0,
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value){
                        setState(() {

                        });
                      },
                    ),
                    SizedBox(height: 40.0,),
                    TextFormField(
                      autocorrect: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Write your address...",
                        errorStyle: TextStyle(
                          fontSize: 13.0,
                        ),
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                      onChanged: (value){
                        setState(() {

                        });
                      },
                    ),




                  ]),
            ),
          ),
          Text("My Orders: ", style: TextStyle(fontSize: 25.0, )),
          Expanded(

            child: new ListView.builder(
              itemCount: _orderslist.length,
              itemBuilder: (context, i) {
                print(_orderslist[i].pivot,);

                return new Card(
                  child: Column(
                    children: [
                      new ListTile(
                        leading: new Image.network(_orderslist[i].image,), /*new CircleAvatar(backgroundImage: new NetworkImage(
                                      // _searchResult[i].image,),),*/
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(_orderslist[i].name, style: TextStyle(color: Colors.black),),
                            //Text(_orderslist[i].pivot.toString(),style: TextStyle(color: Colors.black),),
                        // yetti(_orderslist[i].pivot.toString()),
                         FutureBuilder(
                           future: yetti(_orderslist[i].pivot.toString()),
                             builder: (context, snapshot){
                           return //Column(children: [Text(liste[4],style: TextStyle(color: Colors.black),),
                             Wrap(
                               direction: Axis.horizontal,
                               alignment: WrapAlignment.start,
                               spacing: 5,
                               runSpacing: 5,
                               children: [
                                 Text(liste[4],style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,),),
                                 Text(liste[2],style: TextStyle(color: Colors.black, fontSize: 15.0),),
                                // Text(liste[3],style: TextStyle(color: Colors.black, fontSize: 13.0)),
                                 Text(liste[5],style: TextStyle(color: Colors.black, fontSize: 13.0)),
                               ],
                             );

                           })
                           // yetti(_orderslist[i].pivot.toString())[4],
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text("price: \$" + "${_orderslist[i].price}",
                                style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: (){
                                  showAlertDialog("Action", 'Cancel the order');
                                  _cancelitem(liste[0].substring(11, liste[0].length-1));
                                  print("nummmmmmmmmmmmm");
                                  print(liste[0].substring(11, liste[0].length-1));
                                  _orderslist.clear();
                                  _orders();

                                }),
                            //Text(_Prods[i].model,style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    // ListTile(title: Text(_orderslist[i].pivot),),
                     /* _pivot(_orderslist[i].pivot),
                ListTile(
                title: Text("status: "+ parray[4]),
                subtitle: Wrap(children: [Text("qty: "+ parray[2]+ "total: " + parray[3])]),
                ),*/

                    ],
                  ),
                  margin: const EdgeInsets.all(0.0),
                );


              },
            ),

          )
        ],
      ),

    );
  }
  Future<void> _cancelitem(String orderid) async {
    final String urla= 'http://10.0.2.2:8000/api/order/' + orderid;
    final url = Uri.parse(urla);
    //Map<String, String> headers = {"Content-type": "application/json"};
    //String json = '{"title": "shoppingbag", "body": "quantity"}';
    // make PUT request
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    Response response = await put(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
     // body: jsonEncode(body),
    );
    // Response response = await patch(url, headers: headers, body:jsonEncode(body));

    // check the status code for the result
    int statusCode = response.statusCode;
    print("our func");
    print(statusCode);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Product canceled')));
    // print(total);
  }
  Future<List> flist;
  Future<List> yetti(String a)async{
  setState(() {
    liste= a.split(",");
  });
  print(liste[4]);
  return flist;//Text(liste[4], style: TextStyle(fontSize: 12),);
  }
  List<String> liste=[];
 /* Future<String> FutureListView(String a) async{
    setState(() {
      liste= a.split(",");
    });
    return await ;
  }*/

}

class pivot {
  String address, status;
  int total, qty;
  pivot({this.address, this.status, this.total, this.qty});
  factory pivot.fromJson(Map<String, dynamic> json) {
    return new pivot(
      address: json['address'],
      status: json['status'],
      total: json['total'],
      qty: json['qty'],
    );
  }
}
List<Productorder> _orderslist=[];
class Productorder {
  final int id, category_id, price, quantity_in_stocks; //qty
  final String name, model, description, image; //address, status, total;
  final Map pivot;
  Productorder({this.id, this.name, this.model, this.description, this.image, this.price, this.category_id, this.quantity_in_stocks,
  this.pivot});

  factory Productorder.fromJson(Map<String, dynamic> json) {
    return new Productorder(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      category_id: json['category_id'],
      quantity_in_stocks: json['quantity_in_stocks'],
      pivot: json['pivot'],
     /* address: json['address'],
      status: json['status'],
      total: json['total'],
      qty: json['qty'],*/
    );
  }
}
/*
class orders extends StatefulWidget {
  @override
  _ordersState createState() => _ordersState();
}

class _ordersState extends State<orders> {
  Future<void> _orders() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/order');
    /* var body = {
      'call': 'catagories',
      // 'categoryname': categoryname,
    };*/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String access= prefs.getString('accesstoken');
    final response = await http.get(
      Uri.http(url.authority, url.path),
      headers:{HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $access"},
      /* headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        'Authorization': 'Bearer $access',
      },*/
      //body: body,
      // encoding: Encoding.getByName("utf-8"),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      //Successful transmission
      List<dynamic> jsonMap = json.decode(response.body);
      for (var entry in jsonMap)
      {
        for (var entry2 in entry) {
          print("${entry2}");
          print("ok");
          setState(() {
            _orderslist.add(Productorder.fromJson(entry2));

          });
        }
      }
    }
  }
  void initState() {
    super.initState();
  //  _getprofile();
    _orders();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: new AppBar(title: const Text("Orders"),backgroundColor: AppColors.primary,),
        body:  Expanded(
          child: SizedBox(
            height: 1000,
            child: new ListView.builder(
              itemCount: _orderslist.length,
              itemBuilder: (context, i) {
                print(_orderslist[i].status,);
                return new Card(
                  child: Column(
                    children: [
                      new ListTile(
                        leading: new Image.network(_orderslist[i].image,), /*new CircleAvatar(backgroundImage: new NetworkImage(
                                  // _searchResult[i].image,),),*/
                        title: new Text(_orderslist[i].name, style: TextStyle(color: Colors.black),),
                        subtitle: Row(
                          children: [
                            SizedBox(
                              width: 300,
                              child: Text("price: \$" + "${_orderslist[i].price}",
                                style: TextStyle(fontWeight: FontWeight.bold),),
                            ),

                            //Text(_Prods[i].model,style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),

                    ],
                  ),
                  margin: const EdgeInsets.all(0.0),
                );

              },
            ),
          ),
        )
    );
  }
}
*/