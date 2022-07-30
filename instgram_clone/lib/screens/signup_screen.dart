import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_clone/responsive/web_screen_layout.dart';
import 'package:instgram_clone/services/auth_service.dart';
import 'package:instgram_clone/utils/utils.dart';
import 'package:instgram_clone/widgets/text_field_edit.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../utils/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthService().signupUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        file: _image);
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout());
      }));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Flexible(flex: 2, child: Container()),
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  height: 60,
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 50,
                ),
                Stack(children: [
                  _image == null
                      ? const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            'https://i.stack.imgur.com/l60Hf.png',
                          ),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: MemoryImage(
                            _image!,
                          ),
                        ),
                  Positioned(
                    bottom: -15,
                    right: -5,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 40,
                ),
                TextFieldEdit(
                    controller: _usernameController,
                    text: "Enter username",
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(
                  height: 25,
                ),
                TextFieldEdit(
                    controller: _emailController,
                    text: "Enter email",
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(
                  height: 25,
                ),
                TextFieldEdit(
                  controller: _passwordController,
                  text: "Enter password",
                  keyboardType: TextInputType.text,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldEdit(
                  controller: _bioController,
                  text: "Enter bio",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: signupUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Sign up"),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                /*Flexible(
                  child: Container(),
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Already have an account?"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Log in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
