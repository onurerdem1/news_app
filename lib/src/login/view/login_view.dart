import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/core/colors/colors.dart';
import 'package:news_app/core/image/image_constants.dart';
import 'package:news_app/src/login/view_model/login_view_model.dart';
import 'package:news_app/src/news/view/news_home_view.dart';
import 'package:news_app/src/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = LoginViewModel();
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(children: [Column(
        children: [
          buildIcon(),
          emailTextField(),
          passwordTextField(),
          loginButton(loginViewModel),
          forgotPassword(),
          Spacer(),
        ],
      ),
      Positioned(left:0,bottom: 10,right: 0, child:dontHaveAccount())
      ]
      )
    );
  }

  Widget buildIcon() {
    return Padding(
        padding: EdgeInsets.only(top: 150),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.instance.splashIcon),
            SizedBox(
              width: 20,
            ),
            Text(
              "News App",
              style: TextStyle(
                fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontSize: 30),
            )
          ],
        ));
  }

  Widget emailTextField() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(right: 300, top: 100),
            child: Text("Email",style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold,fontSize: 13),)),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "example@example.com",
                      contentPadding: EdgeInsets.only(left: 30),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        30.0,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2))),
                )))
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(right: 275, top: 10),
            child: Text("Password",style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold,fontSize: 13),)),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 50,
              width: 350,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                            color: AppColors.primaryColor, width: 2))),
              ),
            ))
      ],
    );
  }

  Widget loginButton(LoginViewModel viewModel) {
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return Padding(
            padding: EdgeInsets.only(top: 25),
            child: SizedBox(
              width: 350,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {viewModel.navigatetoHome(context, themeProvider);},
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white,fontFamily: "Montserrat",fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ));
  }

  Widget forgotPassword(){
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: GestureDetector(child:Text("Forgot Password?",style: TextStyle(fontFamily:"Montserrat",color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),),
      )
    );
  }

  Widget dontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't Have Account?  ",style: TextStyle(fontFamily: "Montserrat",fontSize: 13),),
        GestureDetector(child: Text("Sign Up",style: TextStyle(fontFamily:"Montserrat",color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),),)
      ],
    );
  }
}
