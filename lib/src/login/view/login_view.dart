import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(children: [
          Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            ImageConstants.instance.wavePng,
            height: 300.h,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
          Column(
            children: [
              SizedBox(height: 175.h,),
              buildIcon(),
              SizedBox(height: 100.h,),
              emailTextField(),
              SizedBox(height: 10.h,),
              passwordTextField(),
              SizedBox(height: 20.h,),
              loginButton(loginViewModel,themeProvider),
              SizedBox(height: 10.h,),
              forgotPassword(),
              SizedBox(height: screenHeight*0.08.h,),
              dontHaveAccount(loginViewModel, themeProvider)
            ],
          ),
        ]));
  }

  Widget buildIcon() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.instance.splashIcon),
            SizedBox(
              width: 20.w,
            ),
            Text(
              "News App",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontSize: 30.sp),
            )
          ],
        );
  }

  Widget emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
              "Email",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp),
            ),
            SizedBox(height: 5.h),
            SizedBox(
                height: 50.h,
                width: 350.w,
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "example@example.com",
                      contentPadding:  EdgeInsets.symmetric(horizontal: 25.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        30.0.r,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0.r),
                          borderSide:  BorderSide(
                              color: AppColors.primaryColor, width: 2.w))),
                ))
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
              "Password",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp),
            ),
         SizedBox(
              height: 50.h,
              width: 350.w,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding:  EdgeInsets.symmetric(horizontal: 24.w),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                        borderSide:  BorderSide(
                            color: AppColors.primaryColor, width: 2.w))),
              
            ))
      ],
    );
  }

  Widget loginButton(LoginViewModel viewModel,ThemeProvider themeProvider) {
    return SizedBox(
          width: 350.w,
          height: 50.h,
          child: FloatingActionButton(
            onPressed: () {
              viewModel.navigatetoHome(context, themeProvider);
            },
            backgroundColor: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                child: const Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
  }

  Widget forgotPassword() {
    return GestureDetector(
          child:  Text(
            "Forgot Password?",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp),
          ),
        );
  }

  Widget dontHaveAccount(LoginViewModel viewModel,ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't Have Account?  ",
          style: TextStyle(fontFamily: "Montserrat", fontSize: 13.sp),
        ),
        GestureDetector(
          onTap: (){
            viewModel.navigateToRegister(context, themeProvider);
          },
          child:  Text(
            "Sign Up",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp),
          ),
        )
      ],
    );
  }
}
