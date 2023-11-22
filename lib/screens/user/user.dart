import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grand_store_app/consts/firebase_const.dart';
import 'package:grand_store_app/screens/auth/forget_password_screen.dart';
import 'package:grand_store_app/screens/auth/login_screen.dart';
import 'package:grand_store_app/screens/loading_manager.dart';
import 'package:grand_store_app/screens/user/viewed/viewed_screen.dart';
import 'package:grand_store_app/screens/user/wishlist/wishlist_screen.dart';
import 'package:grand_store_app/sevices/global_methods.dart';
import 'package:grand_store_app/widets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../provider/dark_theme_provider.dart';
import 'orders/order_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController addresscontroller =
      TextEditingController(text: "");

  @override
  void dispose() {
    addresscontroller.dispose();
    super.dispose();
  }

  String? email;
  String? name;
  String? address;

  bool isLoading = false;
  final User? user = authInstance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc == null) {
        return;
      } else {
        email = userDoc.get('email');
        name = userDoc.get('name');
        address = userDoc.get('address');
        addresscontroller.text = userDoc.get('address');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      GlobalMethods.errorDialog(context: context, subtitle: "$error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
        body: LoadingManager(
      isLoading: isLoading,
      child: Center(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(
                  text: "Hi,  ",
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: name == null ? 'user' : name,
                        style: TextStyle(
                          color: color,
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("my name is pressed");
                          })
                  ]),
            ),
            const SizedBox(
              height: 5,
            ),
            TextWidget(
              text: email == null ? 'email' : email!,
              color: color,
              textSize: 18,
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            _listTiles(
                title: "Address",
                subtitle: address,
                leftIcon: IconlyLight.profile,
                rightIcon: IconlyLight.arrow_right_2,
                onPressed: () async {
                  await showAddressDialog();
                },
                color: color),
            _listTiles(
                title: "Orders",
                leftIcon: IconlyLight.bag,
                rightIcon: IconlyLight.arrow_right_2,
                onPressed: () {
                  Navigator.pushNamed(context, OrderScreen.routeName);
                },
                color: color),
            _listTiles(
                title: "Wishlist",
                leftIcon: IconlyLight.heart,
                rightIcon: IconlyLight.arrow_right_2,
                onPressed: () {
                  Navigator.pushNamed(context, WishListScreen.routeName);
                },
                color: color),
            _listTiles(
                title: "History",
                leftIcon: IconlyLight.show,
                rightIcon: IconlyLight.arrow_right_2,
                onPressed: () {
                  Navigator.pushNamed(context, ViewedScreen.routeName);
                },
                color: color),
            _listTiles(
                title: "Forget password",
                leftIcon: IconlyLight.password,
                rightIcon: IconlyLight.arrow_right_2,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgetScreen(),
                  ));
                },
                color: color),
            SwitchListTile(
              title: TextWidget(
                text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                color: color,
                textSize: 18,
              ),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              onChanged: (bool value) {
                themeState.setDarkTheme = value;
              },
              value: themeState.getDarkTheme,
            ),
            _listTiles(
                title: user == null ? "Login" : "Logout",
                leftIcon: user == null ? IconlyLight.login : IconlyLight.logout,
                rightIcon: IconlyLight.arrow_right_2,
                onPressed: () {
                  setState(() {});
                  if (user == null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                    return;
                  }
                  GlobalMethods.warningDialog(
                      context: context,
                      title: "Sign out",
                      subtitle: "Doyou wanna sign out?",
                      fct: () async {
                        await authInstance.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      });
                },
                color: color),
          ],
        ),
      ))),
    ));
  }

  Future<void> showAddressDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update"),
          content: TextField(
            onChanged: (value) {
              // addresscontroller.text;
              // print(addresscontroller.text);
            },
            controller: addresscontroller,
            maxLines: 5,
            decoration: const InputDecoration(hintText: "Your Adrress"),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({'address': addresscontroller.text});
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    setState(() {
                      address=addresscontroller.text;
                    });
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    GlobalMethods.errorDialog(
                        context: context, subtitle: e.toString());
                  }
                },
                child: const Text("Update")),
          ],
        );
      },
    );
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData leftIcon,
    required IconData rightIcon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18,
      ),
      subtitle: TextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 22,
      ),
      onTap: () {
        onPressed();
      },
      leading: Icon(leftIcon),
      trailing: Icon(rightIcon),
    );
  }
}
