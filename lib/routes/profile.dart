import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:cs308_ecommerce/routes/catagories.dart';
import 'package:cs308_ecommerce/routes/welcome.dart';
import 'package:flutter/material.dart';
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
    _getprofile();
    _orders();
  }
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
        }
      }
    }
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
        title: Center(child: new Text('username')),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[200],
      ),
      body: Center(

        child:Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
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
                SizedBox(height: 40.0,),
                TextFormField(
                  obscureText: true,
                  autocorrect: true,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Enter your card number",
                    errorStyle: TextStyle(
                      fontSize: 13.0,
                    ),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  onChanged: (value){
                    setState(() {
                    });
                  },
                ),
                Container(

                ),



              ]),
        ),
      ),
    );
  }


}