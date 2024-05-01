import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'signup.dart';

class BeginPage extends StatefulWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  _BeginPageState createState() => _BeginPageState();
}

class _BeginPageState extends State<BeginPage> {
  Color loginBorderColor = Colors.green[100]!;
  Color signUpBorderColor = Colors.green[100]!;
  Color selectedColor = Colors.green;
  double buttonWidth = 200.0; // Set the width for both buttons

  void selectOption(bool isLogin) {
    setState(() {
      loginBorderColor = isLogin ? selectedColor : Colors.green[100]!;
      signUpBorderColor = isLogin ? Colors.green[100]! : selectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/leafybg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Centered Column for Buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Container(
                    width: buttonWidth, // Set the width of the container
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: loginBorderColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.8), // Add background color with opacity
                    ),
                    child: Text(
                      'LogIn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: loginBorderColor == selectedColor
                            ? selectedColor
                            : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Container(
                    width: buttonWidth, // Set the width of the container
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: signUpBorderColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.8), // Add background color with opacity
                    ),
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: signUpBorderColor == selectedColor
                            ? selectedColor
                            : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

