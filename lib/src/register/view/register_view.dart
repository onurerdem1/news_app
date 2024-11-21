import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up",style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold,fontSize: 20.sp),),
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
              SizedBox(height: 125.h,),
              emailTextField(),
              SizedBox(height: 10.h,),
              passwordTextField1(),
              SizedBox(height: 10.h,),
              passwordTextField2(),
              SizedBox(height: 10.h,),
              passwordText(),
              SizedBox(height: screenHeight*0.3.h,),
              agreeText(),
              SizedBox(height: 5.h,),
              registerButton(registerViewModel, themeProvider),
              SizedBox(height: 10.h,),
            ],
          ),
          //Positioned(child:  registerButton(registerViewModel,themeProvider),bottom: 30,left: 30,)
        ])));
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
            SizedBox(height: 5.h,),
         SizedBox(
                height: 50.h,
                width: 350.w,
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "example@example.com",
                      hintStyle: TextStyle(fontFamily: "Montserrat"),
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        30.0.r,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0.r),
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2.w))),
                ))
      ],
    );
  }

  Widget passwordTextField1() {
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
            SizedBox(height: 5.h,),
         SizedBox(
              height: 50.h,
              width: 350.w,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                controller: passwordController1,
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(fontFamily: "Montserrat"),
                    contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                        borderSide: BorderSide(
                            color: AppColors.primaryColor, width: 2.w))),
              ),
            )
      ],
    );
  }
  Widget passwordTextField2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
              "Confirm Password",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp),
            ),
            SizedBox(height: 10.h,),
         SizedBox(
              height: 50.h,
              width: 350.w,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                controller: passwordController2,
                decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(fontFamily: "Montserrat"),
                    contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                        borderSide:  BorderSide(
                            color: AppColors.primaryColor, width: 2.w))),
              ),
            )
      ],
    );
  }

  Widget agreeText(){
    return SizedBox(
      width: 370.w,
      child:Text.rich(
      TextSpan(
        text: "By click the agree and continue button, you're agree to News App's ",
        style: TextStyle(fontFamily: "Montserrat",fontSize: 13.sp),
      children: [
        TextSpan(
          text: "Terms and Service ",
          style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold,fontSize: 13.sp)
        ),
        TextSpan(
          text: "and acknowledge the ",
          style: TextStyle(fontFamily: "Montserrat",fontSize: 13.sp)
        ),
        TextSpan(
          text: "Privacy and Policy",
          style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold,fontSize: 13.sp)
        )
      ] 
      )));
  }

  Widget passwordText(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
          size: 18.sp,
        ),
        Column(
          children: [
            Text("Password must be at least 8 characters,uppercase",style: TextStyle(fontFamily: "Montserrat",fontSize: 13.sp,),),
            Text("lowercase,and unique code like #%!",style: TextStyle(fontFamily: "Montserrat",fontSize: 13.sp),)
          ],
    ),
      ],
    );
  } 

  Widget registerButton(RegisterViewModel viewModel,ThemeProvider themeProvider) {
    return SizedBox(
          width: 350.w,
          height: 50.h,
          child: FloatingActionButton(
            onPressed: () {
              
            },
            backgroundColor: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                child:  Text(
              "Agree And Continue",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ),
          ),
        );
  }
}