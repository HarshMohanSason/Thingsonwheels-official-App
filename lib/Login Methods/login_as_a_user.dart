import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Login%20Methods/Apple/apple_login_service.dart';
import 'package:thingsonwheels/Login%20Methods/Google/google_login_service.dart';
import 'package:thingsonwheels/Reusable%20Widgets/create_a_button.dart';
import 'package:thingsonwheels/Reusable%20Widgets/divider_with_text_in_middle.dart';
import '../IconFiles/app_icons_icons.dart';
import '../Reusable Widgets/custom_text_form.dart';
import '../Reusable Widgets/text_form_validators.dart';
import '../Reusable Widgets/toast_widget.dart';
import '../home_screen.dart';
import '../main.dart';
import 'Apple/apple_button.dart';
import 'Email/email_service.dart';
import 'Google/google_button.dart';
import 'login_state.dart';

class LoginAsAUser extends StatefulWidget {
  const LoginAsAUser({super.key});

  @override
  State<StatefulWidget> createState() => _LoginAsAUserState();
}

class _LoginAsAUserState extends State<LoginAsAUser> {
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isShowingPassword = false;
  late EmailService emailProvider;
  late GoogleLoginService googleProvider;
  late AppleLoginService appleProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    emailProvider = context.watch<EmailService>();
    googleProvider = context.watch<GoogleLoginService>();
    appleProvider = context.watch<AppleLoginService>();
  }

  @override
  void dispose() {
    super.dispose();
    passWordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Login",
            style: TextStyle(fontSize: screenWidth / 20),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              AppIcons.keyboard_backspace,
              size: screenWidth / 24,
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign in to your Account",
                  style: TextStyle(
                      fontSize: screenWidth / 15,
                      color: const Color(0xFF505050),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Enter your email and password to login"),
                SizedBox(
                  height: screenWidth / 8,
                ),
                CustomTextForms(
                    controller: emailController,
                    keyBoardType: TextInputType.emailAddress,
                    labelText: "Email",
                    hintText: "",
                    hideText: false,
                    validator: TextFormValidators.validateEmail),
                const SizedBox(
                  height: 20,
                ),
                CustomTextForms(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  suffixIconWidget: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isShowingPassword = !_isShowingPassword;
                      });
                    },
                    child: _isShowingPassword
                        ? Icon(
                            Elusive.eye_off,
                            color: Colors.grey.withOpacity(0.4),
                          )
                        : Icon(
                            Elusive.eye,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                  ),
                  keyBoardType: TextInputType.visiblePassword,
                  maxLines: 1,
                  controller: passWordController,
                  labelText: "Password",
                  hintText: "",
                  hideText: !_isShowingPassword,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Forgot Password ?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.5,
                      color: Color(0xFF4D81E7),
                      // Custom color for "Login"
                      fontWeight: FontWeight.bold, // Optional: make it bold
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await emailProvider.startEmailLoginProcess(
                          emailController.text, passWordController.text);
                      if (context.mounted) {
                        emailProvider.handleEmailLoginState(
                            context,
                            emailProvider.state.state,
                            emailProvider.state.errorMessage,
                            const HomeScreen());
                      }
                    }
                  },
                  child: emailProvider.state.state == LoginStateEnum.loading
                      ? Center(
                          child: Image.asset(
                            'assets/GIFs/loading_indicator.gif',
                            scale: 13,
                          ),
                        )
                      : CreateAButton(
                          width: screenWidth - 40,
                          height: screenWidth / 8.5,
                          buttonColor: Colors.red,
                          buttonText: "Login",
                          textColor: Colors.white,
                          textSize: screenWidth / 24,
                          borderRadius: 30,
                          icon: Icons.arrow_forward,
                          iconColor: Colors.white,
                          iconSize: screenWidth / 18,
                        ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const DividerWithTextInMiddle(textInBetween: "OR"),
                const SizedBox(
                  height: 30,
                ),
                googleProvider.state.state == LoginStateEnum.loading
                    ? Center(
                        child: Image.asset(
                          'assets/GIFs/loading_indicator.gif',
                          scale: 13,
                        ),
                      )
                    : GoogleButton(
                        onTap: () async {
                          await googleProvider.startSignInWithGoogle();

                          switch (googleProvider.state.state) {
                            case LoginStateEnum.error:
                              if (googleProvider.state.errorMessage != null) {
                                showToast(googleProvider.state.errorMessage!,
                                    Colors.red, Colors.white, "SHORT");
                              }
                              break;

                            case LoginStateEnum.loggedIn:
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                              break;
                            default:
                              break;
                          }
                        },
                      ),
                const SizedBox(
                  height: 20,
                ),
                appleProvider.state.state == LoginStateEnum.loading
                    ? Center(
                        child: Image.asset(
                          'assets/GIFs/loading_indicator.gif',
                          scale: 13,
                        ),
                      )
                    : AppleButton(
                        onTap: () async {
                          await appleProvider.startSignInWithApple();
                          switch (appleProvider.state.state) {
                            case LoginStateEnum.error:
                              if (appleProvider.state.errorMessage != null) {
                                showToast(appleProvider.state.errorMessage!,
                                    Colors.red, Colors.white, "SHORT");
                              }
                              break;

                            case LoginStateEnum.loggedIn:
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                              break;
                            default:
                              break;
                          }
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
