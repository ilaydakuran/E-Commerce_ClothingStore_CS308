import 'dart:convert';
import 'package:cs308_ecommerce/routes/search.dart';
import 'package:cs308_ecommerce/utils/dimension.dart';
import 'package:cs308_ecommerce/utils/styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  int attemptCount = 0;
  String mail;
  String pass;
  String pass2;
  String userName;
  final _formKey = GlobalKey<FormState>();



  Future<void> signUpUser() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/register');
    var body = {
      'call': 'signup',
      'email': mail,
      'password': pass,
      'password_confirmation': pass2,
      'name': userName,
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
      Map<String, dynamic> jsonMap = json.decode(response.body);

      for(var entry in jsonMap.entries) {
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
    /*
    else {
      print(response.body.toString());
      print(response.statusCode);
      showAlertDialog('WARNING', 'Response was not recognized');
    }*/
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(200),
                  bottomLeft: Radius.circular(200),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                      topRight: Radius.circular(200),
                    ),
                  ),
                ),
              ],
            ),



            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Center(
                  child: Text('Sign up',
                      style: kHeadingTextStyle),
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 550.0,
                              width: 340.0,
                              decoration: BoxDecoration(
                                color:  Colors.white70,
                              ),
                              child:Form(
                                key: _formKey,
                                child: ListView(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                                  children: <Widget>[

                                    SizedBox(height: 40.0,),
                                    TextFormField(
                                      autocorrect: true,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Type your username",
                                        errorStyle: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Username is required";
                                        }
                                        else if(value.length < 4) {
                                          return 'Username is too short';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value){

                                        userName = value;

                                      },
                                    ),

                                    SizedBox(height: 20.0,),
                                    TextFormField(
                                      autocorrect: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: "Type your e-mail",
                                        errorStyle: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                        prefixIcon: Icon(Icons.mail),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "E-mail is required";
                                        } else if (!value.contains('@')) {
                                          return "Please enter valid e-mail";
                                        }
                                        return null;
                                      },
                                      onSaved: (String value){

                                        mail = value;

                                      },
                                    ),
                                    SizedBox(height: 20.0,),

                                    TextFormField(
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: "Type your password",
                                        errorStyle: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                        prefixIcon: Icon(Icons.lock),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Password is required";
                                        } else if (value.length < 8) {
                                          return "Password is too short.";
                                        }
                                        return null;
                                      },
                                      onSaved: (String value){

                                        pass = value;

                                      },

                                    ),
                                    SizedBox(height: 20.0,),
                                    TextFormField(
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: "Repeat your password",
                                        errorStyle: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                        prefixIcon: Icon(Icons.lock),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Password is required";
                                        } else if (value.length < 8) {
                                          return "Password is too short.";
                                        }
                                        return null;
                                      },
                                      onSaved: (String value){

                                        pass2 = value;

                                      },

                                    ),



                                    SizedBox(height: 20.0,),
                                    Row(children: <Widget>[
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if(_formKey.currentState.validate()) {
                                              _formKey.currentState.save();

                                              if(pass != pass2) {
                                                showAlertDialog("Error", 'Passwords must match');
                                              }
                                              else {
                                                signUpUser();
                                              }
                                              //
                                              setState(() {
                                                attemptCount += 1;
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text('Signing up')));
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => search()),
                                              );
                                            }

                                          },
                                          child: Text(
                                            "Sign up",
                                            style: TextStyle(color: Colors.grey[700], fontSize: 18.0),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.grey[200],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                    ],
                                    ),



                                    Row(
                                      children: [
                                        Padding(padding: EdgeInsets.fromLTRB(20.0, 50.0, 40.0, 20.0)) ,
                                        Text("Have an account?", style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),),
                                        TextButton(onPressed: (){Navigator.pushNamed(context, "/login");}, child:
                                        Text("Log in", style: TextStyle(color: AppColors.primary, decoration: TextDecoration.underline,
                                          decorationColor: AppColors.primary,
                                          decorationThickness: 2.0,
                                          decorationStyle: TextDecorationStyle.solid,),

                                        ),),
                                      ],
                                    ),


                                  ],
                                ),
                              )
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),

    );
  }

}