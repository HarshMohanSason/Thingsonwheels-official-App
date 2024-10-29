import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Login%20Methods/Email/email_service.dart';
import 'package:thingsonwheels/Login%20Methods/login_as_a_user.dart';
import 'package:thingsonwheels/Login%20Methods/login_state.dart';
import 'package:thingsonwheels/Reusable%20Widgets/create_a_button.dart';
import 'package:thingsonwheels/Reusable%20Widgets/custom_text_form.dart';
import 'package:thingsonwheels/Reusable%20Widgets/text_form_validators.dart';
import 'package:thingsonwheels/main.dart';
import '../IconFiles/app_icons_icons.dart';
import '../home_screen.dart';

class SignUpAsAUser extends StatefulWidget {
  const SignUpAsAUser({super.key});

  @override
  State<SignUpAsAUser> createState() => _SignUpAsAUserState();
}

class _SignUpAsAUserState extends State<SignUpAsAUser> {
  bool _isShowingPassword = false;
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late EmailService emailProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    emailProvider = context.watch<EmailService>();
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
            "Sign Up",
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
                  "Sign Up",
                  style: TextStyle(
                      fontSize: screenWidth / 15,
                      color: const Color(0xFF505050),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Create an account"),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextForms(
                    initialValue: emailProvider.fullName,
                    maxLength: 30,
                    keyBoardType: TextInputType.name,
                    labelText: "Full Name",
                    hintText: "",
                    hideText: false,
                    validator: TextFormValidators.validateName),
                const SizedBox(
                  height: 15,
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
                    initialValue: emailProvider.phoneNumber,
                    maxLength: 10,
                    keyBoardType: TextInputType.phone,
                    labelText: "Phone Number",
                    hintText: "",
                    hideText: false,
                    validator: TextFormValidators.validatePhoneNumber),
                const SizedBox(
                  height: 15,
                ),
                CustomTextForms(
                  suffixIconWidget: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isShowingPassword = !_isShowingPassword;
                        });
                      },
                      child: _isShowingPassword == false
                          ? Icon(
                              Elusive.eye,
                              color: Colors.grey.withOpacity(0.4),
                            )
                          : Icon(Elusive.eye_off,
                              color: Colors.grey.withOpacity(0.4))),
                  keyBoardType: TextInputType.visiblePassword,
                  maxLines: 1,
                  controller: passWordController,
                  labelText: "Set Password",
                  hintText: "",
                  hideText: _isShowingPassword,
                  validator: TextFormValidators.validatePassword,
                ),
                const SizedBox(
                  height: 30,
                ),
                emailProvider.state.state == LoginStateEnum.loading
                    ? Center(
                        child: Image.asset(
                          'assets/GIFs/loading_indicator.gif',
                          scale: 13,
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await emailProvider.startSigningUpProcess(
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
                        child: CreateAButton(
                          width: screenWidth - 40,
                          height: screenWidth / 8.5,
                          buttonColor: Colors.red,
                          buttonText: "Register",
                          textColor: Colors.white,
                          textSize: screenWidth / 24,
                          borderRadius: 30,
                          icon: Icons.arrow_forward,
                          iconColor: Colors.white,
                          iconSize: screenWidth / 18,
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginAsAUser())),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            // Default color for the first part of the text
                            fontSize: 14.5),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.5,
                              color: Color(0xFF4D81E7),
                              // Custom color for "Login"
                              fontWeight:
                                  FontWeight.bold, // Optional: make it bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
