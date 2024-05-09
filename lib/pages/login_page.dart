import 'package:firebase/components/my_button.dart';
import 'package:firebase/components/my_text_field.dart';
import 'package:firebase/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signIn() async{
    print('ggg');
    final authService = Provider.of<AuthService>(context,listen: false);
    try{
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    } catch (e){
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
                SizedBox( height:50),
                Icon(Icons.message, size: 100,
                color: Colors.grey[800],),
                SizedBox( height:50),
                Text('Welcome back you\'ve been missed',style: TextStyle(
                    fontSize: 16
                ),),
                SizedBox( height:25),
                MyTextField(controller: emailController, hintText: 'email', obsecureText:false),
                SizedBox( height:10),
                MyTextField(controller: passwordController, hintText: 'password', obsecureText:false),
                SizedBox( height:25),
                TextButton(onPressed: signIn, child: Text('ggg')),
                MyButton(onTap: signIn, text: 'Sign In'),
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('Not a member?'),
                  SizedBox(width: 4,),
                  GestureDetector(
                    onTap:widget.onTap,
                    child: Text('Register now',style: TextStyle(
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
