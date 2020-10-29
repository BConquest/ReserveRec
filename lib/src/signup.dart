import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/src/login_page.dart';
import 'package:reservrec/src/user_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/repository/dataRepository.dart';
import 'package:reservrec/src/hashing.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPController = TextEditingController();
  final emailController = TextEditingController();
  final DataRepository repository = DataRepository();

  _clearInputs() {
    usernameController.clear();
    passwordController.clear();
    confirmPController.clear();
    emailController.clear();
  }

  _displaySnackBar(BuildContext context, s) {
    final snackBar = SnackBar(content: Text(s));
    print(snackBar);
    //Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // TODO Change To be custom profile picture
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: Image.asset('assets/defaultuser.png'),
          )
      ),
    );

    final inputUsername = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.name,
        controller: usernameController,
        decoration: InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final inputConfirmPassword = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: confirmPController,
        decoration: InputDecoration(
            hintText: 'Confirm Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final inputEmail = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final buttonSignUp = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Sign-Up', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            final User user = await signUpWithEmailAndPassword(usernameController.text, passwordController.text, confirmPController.text, emailController.text);

            //if (user == Null as User) {
              _displaySnackBar(context, createUserMessage);
              return;
            //}
            user.sendEmailVerification();
            //need to somehow increment also idk why my constructor is stupid
            UserC linkUser = new UserC(0);

            linkUser.setUsername(usernameController.text);
            linkUser.setPassword(Sha256(passwordController.text));
            linkUser.setEmail(emailController.text);
            linkUser.setSchool("University of Alabama");
            linkUser.setVerified(false);

            repository.addUserC(linkUser); //hope this works

            _clearInputs();
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ),
    );

    final buttonBack = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Back', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            _clearInputs();
            _displaySnackBar(context, "hey");
            Navigator.pop(context);
          },
        ),
      ),
    );

    final key = new GlobalKey<ScaffoldState>();
    return new Scaffold(
      key: key,
          body: new Builder(
              builder: (BuildContext cont) {
                 return Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: <Widget>[
                      logo,
                      inputUsername,
                      inputPassword,
                      inputConfirmPassword,
                      inputEmail,
                      new ButtonBar(
                          alignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          buttonMinWidth: 1000,
                          children: <Widget>[
                            buttonSignUp,
                            buttonBack,
                          ]
                      ),
                    ],
                  ),
                );
              }
          ),
    );
  }
}