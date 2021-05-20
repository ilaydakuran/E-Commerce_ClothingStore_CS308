import 'dart:convert';
import 'package:cs308_ecommerce/routes/search.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:cs308_ecommerce/utils/dimension.dart';
import 'package:cs308_ecommerce/utils/styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  int attemptCount;
  String mail;
  String pass;
  final _formKey = GlobalKey<FormState>();

  Future<void> loginUser() async {
    final url = Uri.parse('http://localhost:8000/api/login');
    var body = {
      'call': 'login',
      'email': mail,
      'password': pass,
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
        if (entry.value=="Invalid Credentials"){
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Login failed, try again')));
          //Navigator.pushNamed(context, '/search');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );

        }
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



  void getData() async {
    String name = await Future.delayed(Duration(seconds: 3), () {
      return 'cs308';
    });

    String uni = await Future.delayed(Duration(seconds: 1), () {
      return 'Sabancı University';
    });

    print('$name: $uni');
  }

  @override
  void initState() {
    super.initState();
    print('initState called');
    attemptCount = 0;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea( child:

    Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'LOGIN',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: Dimen.regularPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              /*Container(
            height: 300.0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(200),
                bottomLeft: Radius.circular(200),
              ),
            ),
          ),*/
              SizedBox(height: 60.0,),
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: 450.0,
                        width: 340.0,
                        decoration: BoxDecoration(
                          color:  Colors.white70,
                        ),
                        child:Form(
                          key: _formKey,
                          child: ListView(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                            children: <Widget>[

                              SizedBox(height: 60.0,),
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
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return "E-mail is required";
                                  } else if (!input.contains('@')) {
                                    return "Please enter valid e-mail";
                                  }
                                  return null;
                                },
                                onChanged: (value){
                                  setState(() {
                                    mail = value;
                                  });
                                },
                              ),
                              SizedBox(height: 30.0,),
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
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return "Password is required";
                                  } else if (input
                                      .trim()
                                      .length < 4) {
                                    return "Password is too short.";
                                  }
                                  return null;
                                },
                                onChanged: (value){
                                  setState(() {
                                    pass= value;
                                  });
                                },

                              ),
                              SizedBox(height: 15.0,),
                              Text('Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 30.0,),
                              Row(children: <Widget>[
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {

                                      if(_formKey.currentState.validate()) {
                                        _formKey.currentState.save();

                                        //showAlertDialog("Action", 'Button clicked');
                                        setState(() {
                                          attemptCount += 1;
                                        });
                                        loginUser();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text('Logging in')));
                                        // Navigator.pushNamed(context, '/search');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => search()),
                                        );
                                      }

                                    },

                                    child: Text(
                                        "Log in",
                                        style: TextStyle(color: Colors.grey[700], fontSize: 18.0)
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: AppColors.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                              ],
                              ),
                              SizedBox(height: 20.0,),

                            ],
                          ),
                        )
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    ),
    );
  }
}
