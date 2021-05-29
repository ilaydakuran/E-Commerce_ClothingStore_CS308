import 'package:cs308_ecommerce/bottombar.dart';
import 'package:cs308_ecommerce/routes/catagories.dart';
//import 'package:cs308_ecommerce/routes/payments.dart';
import 'package:cs308_ecommerce/routes/profile.dart';
import 'package:cs308_ecommerce/routes/shoppingbag.dart';
import 'package:flutter/material.dart';
import 'package:cs308_ecommerce/routes/welcome.dart';
import 'package:cs308_ecommerce/routes/login.dart';
import 'package:cs308_ecommerce/routes/signup.dart';
import 'package:cs308_ecommerce/routes/payment.dart';
import 'package:cs308_ecommerce/routes/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
  //home: Welcome(),
  initialRoute: '/search',
  routes: {
    '/welcome': (context) => Welcome(),
    '/login': (context) => Login(),
    '/signup': (context) => SignUp(),
    '/search': (context) => search(),
    '/shoppingbag': (context) => ShopCard(),
    '/catagories': (context) => catsearch(),
    '/profile': (context) => Profile(),
    '/bottombar': (context) => bottombar(),
    '/payment': (context) => payment(),
  },
));
/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isinited= prefs.getBool("initialized");
  if(isinited==null){
    prefs.setBool("initialized",true);
    runApp(routesinit());
  }
  else{
    runApp(routesinit2());
  }
}

class routesinit extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/search',
      routes: {
        '/': (context) => Welcome(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/search': (context) => search(),
        '/shoppingbag': (context) => Shoppingbag2(),
        '/catagories': (context) => catsearch(),
        '/profile': (context) => Welcome(),
        '/bottombar': (context) => bottombar(),
        //'/payment': (context) => payment(),
      },
    );
  }
}
class routesinit2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/search',
      routes: {
        //'/': (context) => Welcome(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/search': (context) => search(),
        '/shoppingbag': (context) => Shoppingbag2(),
        '/catagories': (context) => catsearch(),
        '/profile': (context) => Profile(),
        '/bottombar': (context) => bottombar(),
        //'/payment': (context) => payment(),
      },
    );
  }
}*/


