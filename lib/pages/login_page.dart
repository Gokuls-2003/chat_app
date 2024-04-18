import 'package:chat_app/const.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/navigation_service.dart';
import 'package:chat_app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;

  String? email, password;

  @override
  @override
  void initState() {
    super.initState();
    _authService = getIt.get<AuthService>();
    _navigationService = getIt.get<NavigationService>();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [_headerText(), _loginForm(), _createAnAccountLink()],
            )));
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi Welcome Back",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            "Hello again, you've been missed",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: "Email",
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: "Password",
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: true,
            ),
            _loginButton()
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
          onPressed: () async {
            if (_loginFormKey.currentState?.validate() ?? false) {
              _loginFormKey.currentState?.save();
              bool result = await _authService.login(email!, password!);
              print(result);
              if (result) {
                _navigationService.pushReplacementNamed('/home');
              } else {}
            }
          },
          color: Theme.of(context).colorScheme.primary,
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    );
  }

  Widget _createAnAccountLink() {
    return const Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("don't have an account? "),
          Text(
            "Sign Up",
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          )
        ],
      ),
    );
  }
}
