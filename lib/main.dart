import 'package:ejara_app/api_manager/APIRequest.dart';
import 'package:ejara_app/api_manager/APIRoutes.dart';
import 'package:ejara_app/constants/AppColor.dart';
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
        primaryColor : Colors.red,
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
  String phone_prefix = "237";
  String country_code = "CM";
  bool loading = false;
  String error = null;
  String success = null;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                      SizedBox(height: 20,),
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
                      SizedBox(height: 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            onChanged: (String string){
                              this.phone = string;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              contentPadding: EdgeInsets.only(left : 10),
                              prefixIcon: Text(
                                "+237",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("A confirmation code will be send to you."),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: width - 40,
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
                      )
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
      "username" : this.username,
      "email_address" : this.email,
      "phone_number" : '${this.phone_prefix}${this.phone}',
      "country_code" : this.country_code
    };
    setState(() {
      this.loading = true;
      this.error = null;
      this.success = null;
    });
    (APIRequest()).post(url: APIRoutes.CHECK_CREDENTIALS, params: params)
        //.timeout(const Duration(seconds: APIRequest.TIMEOUT ))
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
