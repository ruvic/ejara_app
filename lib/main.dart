import 'dart:convert';

import 'package:ejara_app/api_manager/APIRequest.dart';
import 'package:ejara_app/api_manager/APIRoutes.dart';
import 'package:ejara_app/constants/AppColor.dart';
import 'package:ejara_app/widgets/CustomCountryPicker.dart';
import 'package:ejara_app/widgets/CustomHeader.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ejara Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  String username;
  String email;
  String phone;
  String phonePrefix = "+237";
  String countryCode = "CM";
  bool loading = false;
  Map<String, String> errors = {
    "username" : null,
    "email_address" : null,
    "phone_number" : null,
    "others" : null,
  };

  String success;

  @override
  void initState() {
    super.initState();
    this.init();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double padding = 20;
    double lineSpace = 20;
    double flagWidth = 60;
    return Scaffold(
      body: SingleChildScrollView(
        child:  Container(
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                CustomHeader(title: "Create an Account"),
                (this.loading)?
                Text("Processing...",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),)
                : SizedBox(height: 0,),
                (this.errors["others"] != null)?
                Text(this.errors["others"],
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),)
                : SizedBox(height: 0,),
                (this.success != null)?
                Text(this.success,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),)
                : SizedBox(height: 0,),
                Padding(
                  padding: EdgeInsets.only(left: padding, right: padding),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (String string){
                          this.username = string;
                        },
                        decoration: InputDecoration(
                          hintText: "Username",
                          errorText: this.errors["username"],
                          contentPadding: EdgeInsets.only(left : 10)
                        ),
                      ),
                      SizedBox(height: lineSpace,),
                      TextField(
                        onChanged: (String string){
                          this.email = string;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorText: this.errors["email_address"],
                          contentPadding: EdgeInsets.only(left : 10)
                        ),
                      ),
                      SizedBox(height: lineSpace,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CustomCountryPicker(
                                width: flagWidth,
                                onChanged: (dialCode,code){
                                  setState(() {
                                    this.phonePrefix = dialCode;
                                    this.countryCode = code;
                                  });
                                },
                              ),
                              Container(
                                width: width-2*padding - 100,
                                child: TextField(
                                  onChanged: (String string){
                                    this.phone = string;
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Phone Number",
                                    errorText: this.errors["phone_number"],
                                    contentPadding: EdgeInsets.only(left : 10),
                                    prefixText: this.phonePrefix,
                                    prefixStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text("A confirmation code will be send to you."),
                        ],
                      ),
                      SizedBox(height: lineSpace,),
                      Container(
                        width: width - padding*2,
                        height: 45,
                        child: FlatButton(
                            onPressed: (){
                              this.check(context);
                            },
                            shape : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: AppColor.primary_color,
                            textColor: Colors.white,
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
              ],
            )
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void check (context) {

    setState(() {
      this.init();
    });

    //check if fields are not empty
    bool flag = false;
    if(isEmptyField(this.username)){
      flag = true;
      this.errors["username"] = "Username is required";
    }
    if(isEmptyField(this.email)){
      flag = true;
      this.errors["email_address"] = "Email is required";
    }
    if(isEmptyField(this.phone)){
      flag = true;
      this.errors["phone_number"] = "Phone number is required";
    }

    if(flag){
      setState(() {
        this.loading = false;
      });
      return;
    }

    Map<String,dynamic>  params = {
      "username" : this.username.trim(),
      "email_address" : this.email.trim(),
      "phone_number" : this.phone.trim(),
      "countryCode" : this.countryCode
    };

    print(params);

    (APIRequest()).post(url: APIRoutes.CHECK_CREDENTIALS, params: params)
        .timeout(const Duration(seconds: APIRequest.TIMEOUT ))
        .then((res) async{
          print(res.body);
          var body = jsonDecode(res.body);
          var message = body["message"];
          switch(res.statusCode){
            case 200 :
              this.success = message;
              break;
            case 404 :
              switch(res.headers["x-exit"]){
                case "invalidEmail":
                  this.errors["email_address"] = message;
                  break;
                case "usernameAlreadyInUse":
                  this.errors["username"] = message;
                  break;
              }
              break;
            case 409 :
              switch(res.headers["x-exit"]){
                case "emailAlreadyInUse":
                  this.errors["email_address"] = message;
                  break;
                case "phoneAlreadyInUse":
                  this.errors["phone_number"] = message;
                  break;
                case "usernameUnavailable":
                  this.errors["username"] = message;
                  break;
              }
              break;
            case 400 :
              switch(res.headers["x-exit"]){
                case "invalidPhoneNumber":
                  this.errors["phone_number"] = message;
                  break;
                case "invalidEmail":
                  this.errors["email_address"] = message;
                  break;
              }
              break;
            case 500 :
              switch(res.headers["x-exit"]){
                case "serverError":
                  this.errors["others"] = message;
                  break;
              }
              break;
            default :
              this.errors["others"] = res.body;
              break;
          }
          setState(() {});
    })
        .catchError((error){
        print(error);
        setState(() {
          this.errors["others"] = error;
        });
    })
    .then((resv){
      setState(() {
        this.loading = false;
      });
    });
  }

  bool isEmptyField(String value) => value == null || value.isEmpty;

  void init(){
    this.errors = {
      "username" : null,
      "email" : null,
      "phone_number" : null,
      "others" : null,
    };
    this.loading = true;
    this.success = null;
  }

}
