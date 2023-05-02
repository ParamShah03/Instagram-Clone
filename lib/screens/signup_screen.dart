import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/resources/auth_methods.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signIUpUser() async {
    setState(() {
      _isLoading = true;
    });
   String res = await AuthMethods().signUpUser(
     email: _emailController.text,
     password: _passwordController.text,
     username: _usernameController.text,
     bio: _bioController.text,
     file: _image!,
   );
   setState(() {
     _isLoading = false;
   });

   if(res!= 'success') {
    showSnackBar(res, context);
   } else {
     Navigator.of(context)
         .pushReplacement(
         MaterialPageRoute(builder: (context)=> ResponsiveLayout(
           mobileScreenLayout: MobileScreenLayout(),
           webScreenLayout: WebScreenLayout(),
         ),
         ),);
   }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex: 2,),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  height: 69,
                  color: primaryColor,
                ),
                const SizedBox(height: 20,),
                Stack(
                  children: [
                    _image!= null ?
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                    : const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage(
                        "assets/default_profile.jpg"
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Positioned(
                      bottom: -10,
                        left: 85,
                        child: IconButton(
                          color: Colors.blueGrey,
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 30,),
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25,),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 30,),
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 25,),
                GestureDetector(
                  onTap: signIUpUser,
                  child: Container(
                    child: _isLoading ?
                        const Center(child: CircularProgressIndicator(color: primaryColor,),)
                        :const Text("Sign Up"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))
                    )),

                  ),
                ),
                const SizedBox(height: 12,),
                Flexible(child: Container(), flex: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Don't have an account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        child: const Text("Login.", style: TextStyle(fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
