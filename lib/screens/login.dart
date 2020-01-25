import './home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avatar_glow/avatar_glow.dart';

class LoginPage extends StatelessWidget {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      body: Container(
        //decoration: BoxDecoration(image: _buildBackgroundImage()),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    AvatarGlow(
                      endRadius: 100,
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
                            child: Container(
                              child: Image.asset("assets/images/logoz.png"),
                            ),
                            radius: 70.0,
                          )),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      child: _buildEmailTextField(),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(20.0))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 60,
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.red,
                      ),
                      child: FlatButton(
                        onPressed: () {
                          final FormState formState = _formKey.currentState;
                          if (formState.validate()) {
                            formState.save();
                            try {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _formData['email'],
                                      password: _formData['password'])
                                  .then((_) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                              email: _formData['email'],
                                            )));
                              });
                            } catch (e) {
                              print(e.message);
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            ' SignIn ',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300.0,
                    ),
                    Center(
                      child:Container(
                      child: Row(
                        children: <Widget>[
                          Text("Presented By "),
                          Text(
                            "Team Cicada",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
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
            borderRadius: const BorderRadius.all(const Radius.circular(20.0))),
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
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
