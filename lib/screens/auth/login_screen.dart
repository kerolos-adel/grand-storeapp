import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grand_store_app/screens/auth/signup_screen.dart';
import 'package:grand_store_app/screens/btm_bar_screen.dart';
import 'package:grand_store_app/screens/loading_manager.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/auth_button_widget.dart';
import 'package:grand_store_app/widets/google_butt.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:grand_store_app/widets/textformfield_widget.dart';

import '../../consts/conss.dart';
import '../../consts/firebase_const.dart';
import '../../fetch_screen.dart';
import '../../sevices/global_methods.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void _submitFromOnLogin() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase(),
            password: _passTextController.text);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
      } on FirebaseException catch (e) {
        // ignore: use_build_context_synchronously
        GlobalMethods.errorDialog(context: context, subtitle: "${e.message}");
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        GlobalMethods.errorDialog(
            context: context, subtitle: "an error occurred$e");
        setState(() {
          isLoading = false;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Utlis(context).color;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 6000,
              itemBuilder: (context, index) {
                return Image.asset(
                  Constss.authImagesPass[index],
                  fit: BoxFit.fill,
                );
              },
              indicatorLayout: PageIndicatorLayout.COLOR,
              itemCount: Constss.authImagesPass.length,
              pagination: const SwiperPagination(),
              autoplay: true,
            ),
            Container(
              color: Colors.black.withOpacity(.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    TextWidget(
                      text: "Welcome Back",
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    Constss.heightBox(),
                    TextWidget(
                      text: "Sing in to continue",
                      color: Colors.white,
                      textSize: 18,
                      isTitle: false,
                    ),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            textFormField(
                                context: context,
                                controller: _emailTextController,
                                keyboardType: TextInputType.emailAddress,
                                validatorhint: "please enter your email",
                                hint: 'email'),
                            const SizedBox(
                              height: 10,
                            ),
                            textFormField(
                                context: context,
                                obscureText: obscureText,
                                controller: _passTextController,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: Icon(
                                    obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                validatorhint: "please enter your password",
                                hint: 'password'),
                          ],
                        )),
                    Constss.heightBox(),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgetScreen.routeName);
                          },
                          child: const Text(
                            "Forget password",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic),
                          )),
                    ),
                    Constss.heightBox(),
                    AuthButton(
                      fct: _submitFromOnLogin,
                      butoonText: "Login",
                    ),
                    Constss.heightBox(),


                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        )),
                        Constss.widthBox(),
                        TextWidget(
                            text: "OR", color: Colors.white, textSize: 18),
                        Constss.widthBox(),
                        const Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        )),
                      ],
                    ),
                    Constss.heightBox(),
                    AuthButton(
                      fct: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FetchScreen(),
                        ));
                      },
                      butoonText: "Continue as a guest",
                      primary: Colors.black,
                    ),
                    Constss.heightBox(),
                    Row(
                      children: [
                        const Text('Don\'t have an account?',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routeName);
                            },
                            child: const Text('Sign up',
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600))),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
