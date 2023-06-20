import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_organizer/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:life_organizer/services/AuthService.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {

  var key = GlobalKey<FormState>();
  var _emailCtrl = TextEditingController();
  var _passCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 50),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: const AssetImage('assets/logo.png'),
                        backgroundColor: AppColors().pink,
                        radius: 50,
                      ),
                      const SizedBox(height: 80),
                      TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors().pink,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        unselectedLabelColor: AppColors().dark,
                        labelStyle: GoogleFonts.poppins(),
                        tabs: const [
                          Tab(
                            text: 'Login',
                          ),
                          Tab(
                            text: 'Register',
                          )
                        ],
                      ),
                      Expanded(
                        child: Form(
                          key: key,
                          child: TabBarView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15,),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      controller: _emailCtrl,
                                      style: const TextStyle(
                                          fontSize: 14
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(height: 0),
                                        label: const Text("Email"),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors().dark,
                                            width: 2.0,
                                          ),
                                        ),

                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 6.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      obscureText: true,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      controller: _passCtrl,
                                      style: const TextStyle(
                                          fontSize: 14
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(height: 0),
                                        label: const Text("Password"),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors().dark,
                                            width: 2.0,
                                          ),
                                        ),

                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 6.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30,),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if(key.currentState!.validate()){
                                        await AuthService().signIn(_emailCtrl.text, _passCtrl.text);
                                        if(FirebaseAuth.instance.currentUser != null){
                                          await Future.delayed(const Duration(seconds: 2));
                                          context.push("/home");
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please fill up all the fields",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      }
                                      //AuthService().signIn(_emailCtrl.text, _passCtrl.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      fixedSize: const Size(409, 50),
                                      backgroundColor: AppColors().darkBlue,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(6))
                                      ),
                                    ),
                                    child: const Text('Login'),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15,),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      controller: _emailCtrl,
                                      style: const TextStyle(
                                          fontSize: 14
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(height: 0),
                                        label: const Text("Email"),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors().dark,
                                            width: 2.0,
                                          ),
                                        ),

                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 6.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      obscureText: true,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      controller: _passCtrl,
                                      style: const TextStyle(
                                          fontSize: 14
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(height: 0),
                                        label: const Text("Password"),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors().dark,
                                            width: 2.0,
                                          ),
                                        ),

                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 6.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30,),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if(key.currentState!.validate()){
                                        await AuthService().signUp(_emailCtrl.text, _passCtrl.text);
                                        await Future.delayed(const Duration(seconds: 2));
                                        if(FirebaseAuth.instance.currentUser != null){
                                          context.push("/home");
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please fill up all the fields",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      }
                                      //AuthService().signIn(_emailCtrl.text, _passCtrl.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      fixedSize: const Size(409, 50),
                                      backgroundColor: AppColors().darkBlue,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(6))
                                      ),
                                    ),
                                    child: const Text('Register'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
