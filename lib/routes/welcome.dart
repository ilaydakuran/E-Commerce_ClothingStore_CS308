import 'package:cs308_ecommerce/utils/dimension.dart';
import 'package:flutter/material.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:cs308_ecommerce/utils/styles.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bluebg.jpg"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),

                    child: Text(
                      'Welcome to ShoppingApp',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                Divider(height: 20.0, thickness: 3.0,),

                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 40.0, 5.0, 40.0),
                  child: CircleAvatar(backgroundImage: AssetImage('assets/fimage.png'), radius: 180, backgroundColor: Colors.grey[100],),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Signup',
                              style: kButtonDarkTextStyle,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        ),
                      ),

                      SizedBox(width: 8.0,),

                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Login',
                              style: kButtonLightTextStyle,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}