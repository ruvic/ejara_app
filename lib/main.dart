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
  String error;
  String success;

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
                (this.error != null)?
                Text(this.error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),)
                : SizedBox(height: 0,),
                (this.success != null)?
                Text(this.success,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
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
    Map<String,dynamic>  params = {
      "username" : this.username != null ? this.username.trim() : null,
      "email_address" : this.email != null ? this.email.trim() : null,
      "phone_number" : '${this.phonePrefix}${this.phone.trim()}',
      "countryCode" : this.countryCode.trim()
    };
    setState(() {
      this.loading = true;
      this.error = null;
      this.success = null;
    });
    (APIRequest()).post(url: APIRoutes.CHECK_CREDENTIALS, params: params)
        .timeout(const Duration(seconds: APIRequest.TIMEOUT ))
        .then((res) async{
          print(res.statusCode);
      var error;
      var success;
      switch(res.statusCode){
        case 200 :
          success = "Everything is Ok!";
          break;
        default :
          error = res.headers["x-exit-description"] != null ? res.headers["x-exit-description"]
              : "Ooops An error occur";
          break;
      }
      setState(() {
        this.error = error;
        this.success = success;
      });
    })
        .catchError((error){
        print(error);
    })
    .then((resv){
      setState(() {
        this.loading = false;
      });
    });
  }

}
