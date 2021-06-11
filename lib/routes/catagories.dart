import 'package:cs308_ecommerce/models/products.dart';
import 'package:cs308_ecommerce/routes/categorydisplay.dart';
import 'package:cs308_ecommerce/routes/profile.dart';
import 'package:cs308_ecommerce/routes/shoppingbag.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:cs308_ecommerce/utils/dimension.dart';
import 'package:cs308_ecommerce/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cs308_ecommerce/bottombar.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Duration duration = const Duration(milliseconds: 50);
  final double opacity = 0.5;

  TouchableOpacity({@required this.child, this.onTap});

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown;

  @override
  void initState() {
    super.initState();
    setState(() => isDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        child: widget.child,
        duration: widget.duration,
        opacity: isDown ? widget.opacity : 1,
      ),
    );
  }
}
class catcard extends StatelessWidget {
  final catagory catag;
  final Function go;
  catcard({ this.catag, this.go});


  String categoryname;
  Future<void> category() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/category');
    var body = {
      'call': 'catagories',
      // 'categoryname': categoryname,
    };

    final response = await http.get(
      Uri.http(url.authority, url.path),
      headers: <String, String> {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      //body: body,
      //encoding: Encoding.getByName("utf-8"),
    );

    if(response.statusCode >= 200 && response.statusCode < 300) {
      //Successful transmission
      List<dynamic> jsonMap = json.decode(response.body);

      for(var entry in jsonMap) {
        print("${entry.key} ==> ${entry.value}");
        print("ok");
      }

    }
    else if(response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> jsonMap = json.decode(response.body);

      for(var entry in jsonMap.entries) {
        print("${entry.key} ==> ${entry.value}");
      }

      showAlertDialog('WARNING', jsonMap['error_msg']);
    }
    else {
      print(response.body.toString());
      print(response.statusCode);
      showAlertDialog('WARNING', 'Response was not recognized');
    }
  }
  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
      //context: context,
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
    return TouchableOpacity(child: Card(
      //margin: EdgeInsets.symmetric(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Row(
              children: [
                Image(
                  image: AssetImage(catag.imageUrl),
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
                SizedBox(width: 20.0),
                //TouchableOpacity(child:
                Text( catag.name,
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
      onTap: (){
        // String value,
        //categoryname = value;
        category();

      },
    );
  }
}
List<catagory> cats = [
  catagory(name: "Tops", imageUrl: "assets/tshirt.jpg", categid: 1),
  catagory(name: "Accessory", imageUrl: "assets/pants.jpg", categid: 3),
  catagory(name: "Bottoms", imageUrl: "assets/shoes2.jpg", categid: 2),

];
class catsearch extends StatefulWidget {
  @override
  _catsearchState createState() => _catsearchState();
}
/*
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
              margin: EdgeInsets.only(top: 5),
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}*/
class _catsearchState extends State<catsearch> {

  TextEditingController controller = new TextEditingController();


  @override
  void initState() {
    super.initState();

    //getUserDetails();
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
              IconButton(icon: Icon(Icons.menu), iconSize: 30.0, color: AppColors.primary, onPressed: (){Navigator.pushNamed(context, '/catagories');} ),
              IconButton(icon: Icon(Icons.person), iconSize: 30.0, color: Colors.black87, onPressed: (){Navigator.pushNamed(context, '/profile');} ),
              IconButton(icon: Icon(Icons.shopping_bag_outlined), iconSize: 30.0, color: Colors.black87, onPressed: (){  Navigator.pushNamed(context, '/shoppingbag');}),
            ],
          ),
        ),
      ),

      appBar: new AppBar(
        title: Center(child: new Text('Catagories')),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[200],
      ),
      body: new Column(
        children: <Widget>[

          //Categories(),
          new Expanded(
            child: new ListView.builder(
              itemCount: cats.length,
              itemBuilder: (context, index) {
                return TouchableOpacity(
                  child: new Card(
                    child: new ListTile(
                      leading: SizedBox(width: 100,child: new Image.asset(cats[index].imageUrl,)),
                      title: new Text(cats[index].name),
                    ),
                    margin: const EdgeInsets.all(5.0),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(context)=>catDisplay(cats[index].categid))),
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => categDisplay(
                          categid: cats[index].categid,
                        ),
                      )),*/
                );
              },

            ),
          ),
          /*   Column(
            children: cats.map((catag) =>
                catcard(
                  catag: catag,
                  go: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => categDisplay(
                          categid: cats[1].categid,
                        ),
                      )),

                )).toList(),),*/
          // new Scaffold(
          // bottomNavigationBar: BottomAppBar(color: Colors.grey[350], child:

          //),
          // ),
        ],
      ),
    );
  }
}

class Categid {
  final int category_id;
  final String name;

  Categid({this.category_id, this.name});

}









