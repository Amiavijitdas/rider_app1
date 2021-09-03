import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/RegisterScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/main.dart';

class LoginScreen extends StatelessWidget
{
  static const String idScreen = "login";
  //const LoginScreen({Key? key}) : super(key: key);
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35.0,
              ),
              Image(
                image: AssetImage("images/ill_art_login.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Login",
                style: TextStyle(fontSize: 24.0, fontFamily: ""),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.only(left: 50.0, right: 50.0))),
                      onPressed: () {
                        if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email Address is not Valid.", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Password is mandatory.", context);
                        }
                        else
                        {
                          loginAndAuthenticateUser(context);
                        }
                      },
                      child: Text("Login"),
                    ),
                    TextButton(
                      onPressed: ()
                      {
                        Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                      },
                      child: Text("Do not have an Account? Register Here."),

                      //for formate the code just press alt+shift+f OK   now whenever you save the code it will auto formate got it ok sir      SAVE NOE done sir okay THAnks again sir okay dear no issue ok i am going ok sir
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async
  {
    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;


    if(firebaseUser != null)
    {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value!=null)
        {
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Your are loged in.", context);
        }
        else
        {
          _firebaseAuth.signOut();
          displayToastMessage("Error! Please creat new Account.", context);
        }
      });
    }
    else
    {
      //error occured - display error msg
      displayToastMessage("Error occured, can not sign in.", context);

    }
  }
}

