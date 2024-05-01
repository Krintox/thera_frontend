import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override 
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPressed = false;
  String _email = ''; // Change username to email
  String _password = '';
  bool _rememberMe = false;
  bool _isHovered = true;

  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse('http://localhost:8900/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _email, // Change username to email
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse response body to get JWT token
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String jwtToken = responseData['token'];

      // Save JWT token (you can use shared preferences or any other method)
      // For example:
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwtToken', jwtToken);

      // Navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to login'),
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
              _buildEmailField(context), // Change to email field
              SizedBox(height: 20.0),
              _buildPasswordField(context),
              SizedBox(height: 20.0),
              _buildRememberMeCheckBox(context),
              SizedBox(height: 20.0),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) { // Change method name and label
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email', // Change label to "Email"
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green[200]!),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _email = value; // Change variable name
        });
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true, // Hide the password input
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green[200]!),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _password = value;
        });
      },
    );
  }

  Widget _buildRememberMeCheckBox(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // Align elements to the left and right
      children: [
        Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white),
        ),
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all<Color>(Colors.green[200]!),
            ),
            Text(
              'Remember Me',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: _isPressed
            ? null
            : Border.all(
                color: Colors.green[200]!,
                width: 2.0,
              ),
        boxShadow: _isPressed
            ? [
                BoxShadow(
                  color: Colors.green[200]!.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
        color: _isHovered
            ? Colors.green[200]!
            : (_email.isNotEmpty &&
                    _password.isNotEmpty &&
                    _isPressed
                ? Colors.green[200]!
                : Colors.transparent),
      ),
      child: InkWell(
        onTap: () {
          if (_email.isNotEmpty && _password.isNotEmpty) { // Change variable name
            if (_rememberMe) {
              // Implement logic to save login state for "Remember Me"
            }
            setState(() {
              _isPressed = !_isPressed;
            });
            loginUser(); // Call login function
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter both email and password.'), // Change message
              ),
            );
          }
        },
        onHover: (isHovered) {
          setState(() {
            _isHovered = isHovered;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: _isPressed
                ? null
                : Border.all(
                    color: Colors.green[200]!,
                    width: 2.0,
                  ),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: Colors.green[200]!.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
            color: _isHovered
                ? Colors.green[200]!
                : (_email.isNotEmpty &&
                        _password.isNotEmpty &&
                        _isPressed
                    ? Colors.green[200]!
                    : Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  color: _isPressed ? Colors.white : Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(width: 10.0),
              if (_isPressed)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
