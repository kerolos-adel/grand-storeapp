import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/screens/loading_manager.dart';
import 'package:grand_store_app/sevices/global_methods.dart';
import 'package:grand_store_app/sevices/utlis.dart';
import 'package:grand_store_app/widets/auth_button_widget.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:grand_store_app/widets/textformfield_widget.dart';

import '../../consts/conss.dart';

class ForgetScreen extends StatefulWidget {
  static const routeName = '/ForgetScreen';

  const ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _emailTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void _forgerPass() async {
    if (_emailTextController.text.isEmpty ||
        !_emailTextController.text.contains("@")) {
      GlobalMethods.errorDialog(
          context: context, subtitle: "Please enter a correct email address");
    } else {
      setState(() {
        isLoading = true;
      });
    try{
      await authInstance.sendPasswordResetEmail(
          email: _emailTextController.text.toLowerCase());
      Fluttertoast.showToast(
          msg: "an email has been sent to your email address",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey.shade600,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }on FirebaseException catch (e) {
      // ignore: use_build_context_synchronously
      GlobalMethods.errorDialog(
          context: context, subtitle: "${e.message}");
      setState(() {
        isLoading=false;
      });
    }
    catch (e) {
      // ignore: use_build_context_synchronously
      GlobalMethods.errorDialog(
          context: context, subtitle: "an error occurred$e");
      setState(() {
        isLoading=false;
      });
    }
    finally{
      setState(() {
        isLoading=false;
      });
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;
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
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextWidget(
                          text: "Forget password",
                          color: Colors.white60,
                          textSize: 30,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        textFormField(
                            context: context,
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validatorhint: "please enter your password",
                            hint: 'Email address'),
                        Constss.heightBox()
                      ],
                    )),
                Constss.heightBox(),
                AuthButton(
                  fct: () {
                    _forgerPass();
                  },
                  butoonText: "Rest now",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
