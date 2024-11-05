import 'package:flutter/material.dart';
import 'package:news_app/core/colors/colors.dart';
import 'package:news_app/core/image/image_constants.dart';
import 'package:news_app/src/login/view_model/login_view_model.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(children: [
          Column(
            children: [
              buildIcon(),
              emailTextField(),
              passwordTextField(),
              loginButton(loginViewModel,themeProvider),
              forgotPassword(),
              const Spacer(),
            ],
          ),
          Positioned(left: 0, bottom: 10, right: 0, child: dontHaveAccount(loginViewModel,themeProvider))
        ]));
  }

  Widget buildIcon() {
    return Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.instance.splashIcon),
           const SizedBox(
              width: 20,
            ),
           const Text(
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
        const Padding(
            padding: EdgeInsets.only(right: 300, top: 100),
            child: Text(
              "Email",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "example@example.com",
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
    );
  }

  Widget passwordTextField() {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.only(right: 275, top: 10),
            child: Text(
              "Password",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 50,
              width: 350,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Password",
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
    );
  }

  Widget loginButton(LoginViewModel viewModel,ThemeProvider themeProvider) {
    return Padding(
        padding: const EdgeInsets.only(top: 25),
        child: SizedBox(
          width: 350,
          height: 50,
          child: FloatingActionButton(
            onPressed: () {
              viewModel.navigatetoHome(context, themeProvider);
            },
            backgroundColor: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: const Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Widget forgotPassword() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GestureDetector(
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
        ));
  }

  Widget dontHaveAccount(LoginViewModel viewModel,ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text(
          "Don't Have Account?  ",
          style: TextStyle(fontFamily: "Montserrat", fontSize: 13),
        ),
        GestureDetector(
          onTap: (){
            viewModel.navigateToRegister(context, themeProvider);
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
        )
      ],
    );
  }
}
