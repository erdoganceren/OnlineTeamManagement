import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_team_management/controller/login_controller.dart';
import 'package:online_team_management/util/extension.dart';
import 'package:online_team_management/view/auth_view/signup_view.dart';
import 'package:online_team_management/view/home_view/home_view.dart';
import 'package:online_team_management/widget/fade_route.dart';
import 'package:online_team_management/widget/loading_view.dart';
import 'package:online_team_management/widget/submit_button.dart';
import 'package:online_team_management/widget/transparent_route.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  bool isTapButton = false;
  @override
  Widget build(BuildContext context) {
    //var loginValidate = Provider.of<LoginValidate>(context, listen: false);
    //var currentUser = Provider.of<CurrentUser>(context, listen: false);
    Provider.of<LoginController>(context, listen: false).formKey =
        new GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(parent: ClampingScrollPhysics()),
        child: Container(
          height: context.dynamicHeight(1),
          width: context.dynamicWidth(1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: Provider.of<LoginController>(context, listen: false).formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 8,
                  ),
                  Expanded(
                    flex: 6,
                    child: FittedBox(
                      child: Text(
                        "Log in",
                        style: context.themeData.textTheme.title
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Divider(
                      thickness: 4,
                      color: context.themeData.buttonColor,
                      endIndent: 280,
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            style: context.themeData.textTheme.subtitle1
                                .copyWith(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.7)),
                            text:
                                "Plesase log in to your account to continue with Online Team Management Tool."),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: TextFormField(
                      validator: (value) =>
                          Provider.of<LoginController>(context, listen: false)
                              .validateEmail(),
                      decoration: new InputDecoration(
                        hintText: "Email Address",
                      ),
                      onChanged: (String value) {
                        Provider.of<LoginController>(context, listen: false)
                            .email = value;
                      },
                    ),
                  ),
                  Expanded(
                      flex: 12,
                      child: TextFormField(
                          validator: (value) => Provider.of<LoginController>(
                                  context,
                                  listen: false)
                              .validatePassword(),
                          decoration: new InputDecoration(
                            hintText: "Password",
                          ),
                          onChanged: (String value) {
                            Provider.of<LoginController>(context, listen: false)
                                .password = value;
                          })),
                  Expanded(
                      flex: 14,
                      child: Center(
                          child: SubmitButton(
                        colors: [
                          context.themeData.buttonColor,
                          context.themeData.buttonColor
                        ],
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: context.dynamicWidth(0.035)),
                        ),
                        onTap: () async {
                          await onTapLogin(context);
                        },
                      ))),
                  Expanded(
                      flex: 12,
                      child: Center(
                        child: Text("Forgot password?",
                            style: context.themeData.textTheme.bodyText1
                                .copyWith(fontWeight: FontWeight.bold)),
                      )),
                  Expanded(
                    flex: 15,
                    child: Center(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupView()));
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "You dont't have an account\n",
                                style: context.themeData.textTheme.bodyText1
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Sign Up",
                                style: context.themeData.textTheme.bodyText1
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context.themeData.buttonColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future onTapLogin(context) async {
    Navigator.push(
        context, TransparentRoute(builder: (context) => LoadingView()));
    bool result =
        await Provider.of<LoginController>(context, listen: false).login();
    print("DEBUG: Auth result: $result");
    Navigator.pop(context);
    if (result == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeView(),
          ),
          (route) => false);
    } else {
      Flushbar(
        backgroundColor: Colors.red,
        title: "Oops..",
        message: "Invalid login",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
