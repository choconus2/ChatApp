import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/base_statefulWidget/base_statefulWidget.dart';
import 'package:chats_app/ui/login/login.dart';
import 'package:chats_app/ui/register/register_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widget_common/text_field.dart';

class Register extends BaseStatefulWidget<RegisterBloc> {
   Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign Up",style: TextStyle(
              fontSize: 40,
            ),),
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
                bloc.signUp(context);
              },
              style: OutlinedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 25,
                ),
              ),
              child: const Text("Sign up"),
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
                  text: "Sign in",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
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
  RegisterBloc create() => RegisterBloc();

  @override
  void onStateChange(BuildContext context, BaseState baseState) {
    // TODO: implement onStateChange
  }
}
