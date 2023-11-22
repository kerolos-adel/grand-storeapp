import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/screens/btm_bar_screen.dart';
import 'package:grand_store_app/sevices/global_methods.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/auth_button_widget.dart';
import 'package:grand_store_app/widets/google_butt.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:grand_store_app/widets/textformfield_widget.dart';

import '../../consts/conss.dart';
import '../../fetch_screen.dart';
import '../loading_manager.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void dispose() {
    _fullNameTextController.dispose();
    _addressTextController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void _submitFromOnRegister() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {

      _formkey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase(),
            password: _passTextController.text);
        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameTextController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameTextController.text,
          'email': _emailTextController.text,
          'address': _addressTextController.text,
          'userWish': [],
          'userCart': [],
          'createAt': Timestamp.now(),
        });

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
        print("successfuly");
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
                    TextWidget(
                      text: "Sing up to continue",
                      color: Colors.white,
                      textSize: 18,
                      isTitle: false,
                    ),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Constss.heightBox(),
                            textFormField(
                              context: context,
                              controller: _fullNameTextController,
                              keyboardType: TextInputType.name,
                              validatorhint: "must enter your name",
                              hint: 'Full name',
                            ),
                            Constss.heightBox(),
                            textFormField(
                              context: context,
                              controller: _emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              validatorhint: "must enter your email",
                              hint: 'Email',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            textFormField(
                              context: context,
                              controller: _passTextController,
                              obscureText: obscureText,
                              keyboardType: TextInputType.visiblePassword,
                              validatorhint: "must enter your password",
                              hint: 'Password',
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            textFormField(
                              context: context,
                              controller: _addressTextController,
                              keyboardType: TextInputType.emailAddress,
                              validatorhint: "must enter your addrees",
                              hint: 'Shipping address',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    AuthButton(
                      fct: () {
                        _submitFromOnRegister();
                      },
                      butoonText: "Sign up",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                            text: "OR", color: Colors.white, textSize: 18),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Already a user?',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            },
                            child: const Text(' Sign in',
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
