import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/base_statefulWidget/base_statefulWidget.dart';
import 'package:chats_app/ui/home/home.dart';
import 'package:chats_app/ui/login/login_bloc.dart';
import 'package:chats_app/ui/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widget_common/text_field.dart';

class LoginScreen extends BaseStatefulWidget<LoginBloc> {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InputCommon(
              txtController: bloc.email,
              labelText: "Email",
              errorText: bloc.errorEmail,
              inputBorder: OutlineInputBorder(),
              textOnChange: (textChange) {
                if(textChange.isNotEmpty){
                  bloc.call(() => null);
                  bloc.errorEmail=null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            InputCommon(
              txtController: bloc.password,
              labelText: "Password",
              errorText: bloc.errorPassword,
              inputBorder: OutlineInputBorder(),
              obscureText: true,
              textOnChange: (textChange) {
                if(textChange.isNotEmpty){
                  bloc.call(() => null);
                  bloc.errorPassword=null;
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
              onPressed: () {
                bloc.login();
              },
              style: OutlinedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 25,
                ),
              ),
              child: const Text("Login"),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Do not have an account: ",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "Sign Up",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginBloc create() => LoginBloc();

  @override
  void onStateChange(BuildContext context, BaseState baseState) {
    if (baseState.sign == LoginState.loginSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
      );
      return;
    }
  }
}
