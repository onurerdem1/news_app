import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/core/colors/colors.dart';
import 'package:news_app/src/register/view_model/register_view_model.dart';
import 'package:news_app/src/theme_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final RegisterViewModel registerViewModel = RegisterViewModel();
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up",style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          registerViewModel.navigateToLogin(context);
        }, icon: const Icon(Icons.arrow_back)),
      ),
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(child : Stack(children:[
          Column(
            children: [
              emailTextField(),
              passwordTextField1(),
              passwordTextField2(),
              passwordText(),
              agreeText(),
              registerButton(registerViewModel, themeProvider)
            ],
          ),
          //Positioned(child:  registerButton(registerViewModel,themeProvider),bottom: 30,left: 30,)
        ])));
  }
  Widget emailTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 100,right: 20),
      child: Column(
      children: [
        const Padding(
            padding: EdgeInsets.only(right: 300),
            child: Text(
              "Email",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 10,left: 30),
            child: SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "example@example.com",
                      hintStyle: TextStyle(fontFamily: "Montserrat"),
                      contentPadding: const EdgeInsets.only(left: 30),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        30.0,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: AppColors.primaryColor, width: 2))),
                )))
      ],
    ));
  }

  Widget passwordTextField1() {
    return Padding(
      padding: EdgeInsets.only(top: 10,right: 20),
      child:Column(
      children: [
        const Padding(
            padding: EdgeInsets.only(right: 275),
            child: Text(
              "Password",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 10,left: 30),
            child: SizedBox(
              height: 50,
              width: 350,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                controller: passwordController1,
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(fontFamily: "Montserrat"),
                    contentPadding: const EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            color: AppColors.primaryColor, width: 2))),
              ),
            ))
      ],
    ));
  }
  Widget passwordTextField2() {
    return Padding(
      padding: EdgeInsets.only(top: 10,right: 20),
      child:Column(
      children: [
        const Padding(
            padding: EdgeInsets.only(right: 215),
            child: Text(
              "Confirm Password",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 10,left: 30),
            child: SizedBox(
              height: 50,
              width: 350,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                controller: passwordController2,
                decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(fontFamily: "Montserrat"),
                    contentPadding: const EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            color: AppColors.primaryColor, width: 2))),
              ),
            ))
      ],
    ));
  }

  Widget agreeText(){
    return Padding(
      padding: EdgeInsets.only(top: 180,left: 20,right: 20,bottom: 20),
      child: Text.rich(
      TextSpan(
        text: "By click the agree and continue button, you're agree to News App's ",
        style: TextStyle(fontFamily: "Montserrat",fontSize: 13),
      children: [
        TextSpan(
          text: "Terms and Service ",
          style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold)
        ),
        TextSpan(
          text: "and acknowledge the ",
          style: TextStyle(fontFamily: "Montserrat")
        ),
        TextSpan(
          text: "Privacy and Policy",
          style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold)
        )
      ] 
      )));
  }

  Widget passwordText(){
    return Padding(
      padding: EdgeInsets.only(top: 10,left: 30,),
    child: Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
          size: 18,
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          children: [
            Text("Password must be at least 8 characters,uppercase"),
            Padding(padding: EdgeInsets.only(right: 95),
            child:Text("lowercase,and unique code like #%!"))
          ],
        )
      ],
    ),);
  } 

  Widget registerButton(RegisterViewModel viewModel,ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child:SizedBox(
          width: 350,
          height: 50,
          child: FloatingActionButton(
            onPressed: () {
              
            },
            backgroundColor: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: const Text(
              "Agree And Continue",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}