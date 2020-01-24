import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _hospitalname;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create A New Account"),
      ),
      body: Container(
        //decoration: BoxDecoration(image: _buildBackgroundImage()),
        child: Center(
          child: Container(
            width: targetWidth,
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      AvatarGlow(
                        endRadius: 90,
                        duration: Duration(seconds: 2),
                        glowColor: Colors.white24,
                        repeat: true,
                        repeatPauseDuration: Duration(seconds: 2),
                        startDelay: Duration(seconds: 1),
                        child: Material(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              //backgroundImage: Image.asset("assets/images/logo.png"),
                              child: Image.asset("assets/images/logoz.png"),
                              radius: 70.0,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildHospitalName(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 60,
                        width: 270,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Colors.red,
                        ),
                        child: FlatButton(
                          onPressed: signUp,
                          child: Center(
                            child: Text(
                              ' Sign Up ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String emailz = _email.replaceAll('.', ',');
      String jsonUrlz = "https://ambu-lights.firebaseio.com/users/" +
          emailz +
          "/hospitalname.json";
      http.put(jsonUrlz, body: json.encode(_hospitalname));
      print("This is Hospital Name " + _hospitalname);
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((_) {});

        Navigator.pushReplacementNamed(context, '/');
      } catch (e) {
        print(e.message);
      }
    }
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail',
          filled: true,
          fillColor: Colors.white70,
          border: new OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0)))),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildHospitalName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Hospital Name',
          filled: true,
          fillColor: Colors.white70,
          border: new OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0)))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Enter a valid hospital name';
        }
      },
      onSaved: (String value) {
        _hospitalname = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white70,
          border: new OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0)))),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/images/ambulance.png'),
    );
  }
}
