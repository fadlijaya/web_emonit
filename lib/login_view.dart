import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_emonit/admin_view.dart';
import 'package:web_emonit/theme/colors.dart';
import 'package:web_emonit/theme/padding.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  late bool _showPassword = true;
  late final bool _isLoading = false;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
       WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AdminView(),
          ),
          (route) => false,
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kRed,
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: image()),
            formLogin(),
          ],
        ),
      )),
    );
  }

  Widget image() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://tedis.telkom.design/assets/download_logo/logo-telkom-putih.png",
        ),
        header(),
      ],
    );
  }

  Widget header() {
    return Column(
      children: const [
        SizedBox(
          height: 16,
        ),
        Text(
          "Selamat Datang di Aplikasi e-Monit",
          style: TextStyle(
              fontSize: 20, color: kWhite, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "Telkom Regional 7 Makassar",
          style: TextStyle(
              fontSize: 20, color: kWhite, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget formLogin() {
    return Form(
        key: _formKey,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), color: kWhite),
          padding: const EdgeInsets.all(paddingDefault),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Row(
                children: const [
                  Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: kBlack54),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _controllerEmail,
                cursorColor: kRed,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: kGrey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kGrey)),
                    prefixIcon: Icon(
                      Icons.email,
                      color: kGrey,
                    ),
                    hintText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Email";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: _controllerPassword,
                obscureText: _showPassword,
                cursorColor: kRed,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kGrey)),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: kGrey,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: togglePasswordVisibility,
                      child: _showPassword
                          ? const Icon(
                              Icons.visibility_off,
                              color: kGrey,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: kGrey,
                            ),
                    ),
                    hintText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Password";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              buttonLogin(),
            ],
          ),
        ));
  }

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget buttonLogin() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kRed),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)))),
      onPressed: login,
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        width: double.infinity,
        height: 48,
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(color: kWhite, fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Future<dynamic> login() async {
    if (!_isLoading) {
      if (_formKey.currentState!.validate()) {
        if (_controllerEmail.text == "admincdcreg7@gmail.com" &&
            _controllerPassword.text == "admincdcreg7") {
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _controllerEmail.text,
                password: _controllerPassword.text);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AdminView()),
                (route) => false);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              displaySnackBar("Email Tidak Terdaftar");
            } else if (e.code == 'wrong-password') {
              displaySnackBar("Email/Password Salah");
            }
          }
        } else {
          displaySnackBar("Email/Password Salah!");
        }
      }
    }
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
