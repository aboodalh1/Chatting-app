import 'package:firebase/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('passwords do not match')));
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Icon(Icons.message, size: 100,
                    color: Colors.grey[800],),
                  SizedBox(height: 50),
                  Text('Let\'s create an account for you!', style: TextStyle(
                      fontSize: 16
                  ),),
                  SizedBox(height: 25),
                  MyTextField(controller: emailController,
                      hintText: 'Email',
                      obsecureText: false),
                  SizedBox(height: 10),
                  MyTextField(controller: passwordController,
                      hintText: 'Password',
                      obsecureText: true),
                  SizedBox(height: 10),
                  MyTextField(controller: confirmPasswordController,
                      hintText: 'Confirm your password',
                      obsecureText: true),
                  SizedBox(height: 25),
                  TextButton(onPressed: signUp, child: Text("GG")),
                  MyButton(onTap: signUp, text: 'Sign up'),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Alrady a member?'),
                      SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Login now', style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ],)
                ],
              ),
            ),
          ),
        )
    );
  }
}
