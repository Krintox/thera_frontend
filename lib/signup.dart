import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'questions.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPressed = false;
  bool _rememberMe = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('https://occ-therapy-backend.onrender.com/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
        'username': _usernameController.text,
        'phone': _phoneNumberController.text,
      }),
    );

    if (response.statusCode == 201) {
      // User registered successfully, navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Questions()),
      );
    } else {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register user'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUsernameField(context),
              SizedBox(height: 20.0),
              _buildEmailField(context),
              SizedBox(height: 20.0),
              _buildPasswordField(context),
              SizedBox(height: 20.0),
              _buildPhoneNumberField(context),
              SizedBox(height: 20.0),
              _buildRememberMeCheckBox(context),
              SizedBox(height: 20.0),
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return TextFormField(
      controller: _usernameController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField(BuildContext context) {
    return TextFormField(
      controller: _phoneNumberController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckBox(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value!;
            });
          },
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.all<Color>(Colors.green[100]!),
        ),
        Text(
          'Remember me',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: _isPressed
            ? null
            : Border.all(
                color: Colors.green[100]!,
                width: 2.0,
              ),
        boxShadow: _isPressed
            ? [
                BoxShadow(
                  color: Colors.green[100]!.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ]
            : [],
      ),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _isPressed = !_isPressed;
          });
          if (_emailController.text.isEmpty ||
              _passwordController.text.isEmpty ||
              _usernameController.text.isEmpty ||
              _phoneNumberController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter all fields.'),
              ),
            );
          } else {
            if (_isPressed) {
              registerUser();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: _isPressed ? Colors.white : Colors.white!,
            ),
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: Colors.green[100]!, width: 2.0),
          ),
          backgroundColor: _isPressed
              ? MaterialStateProperty.all<Color>(Colors.green[100]!)
              : MaterialStateProperty.all<Color>(Colors.transparent),
          foregroundColor: MaterialStateProperty.all<Color>(
            _isPressed ? Colors.white : Colors.white,
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            Colors.transparent,
          ),
          mouseCursor: MaterialStateProperty.all<MouseCursor>(
            SystemMouseCursors.click,
          ),
        ),
      ),
    );
  }
}
