import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/screens/profile.dart';
import 'package:e_tutoring/screens/signup.dart';
import 'package:e_tutoring/widgets/button_widget.dart';
import 'package:e_tutoring/widgets/title_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // For CircularProgressIndicator.
  bool visible = false;

  // Initially password is obscure
  bool _obscureText = true;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("init login widget");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    print("dispose login widget");
    super.dispose();
  }

// Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // CONTROLLER
  Future userLogin() async {
    setState(() {
      // Showing CircularProgressIndicator.
      visible = true;
    });

    try {
      // Getting value from Controller
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      // Store all data with Param Name: json format

      if (await login(http.Client(), email, password)) {
        await UserSecureStorage.setEmail(emailController.text);
        await UserSecureStorage.setPassword(passwordController.text);

        // get user role
        dynamic role = await getRoleFromWS(http.Client(), emailController.text);
        await UserSecureStorage.setRole(role.role_name);
        setState(() {
          visible = false;
        });
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
      } else {
        setState(() {
          visible = false;
        });

        // Showing Alert Dialog with Response JSON Message.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Invalid Username or Password Please Try Again"),
              actions: <Widget>[
                TextButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.emailController.text = email;
                    this.passwordController.text = password;
                  },
                ),
              ],
            );
          },
        );
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Error. Verify Your Connection.'),
        backgroundColor: Colors.redAccent,
      ));
      setState(() {
        visible = false;
      });
    }
  }

  Future init() async {
    final email = await UserSecureStorage.getEmail() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';

    this.emailController.text = email;
    this.passwordController.text = password;
  }

  // VIEW
  @override
  Widget build(BuildContext context) {
    this.setState(() {
      // init();
    });
    return new WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text("E-Tutoring " + AppLocalizations.of(context).login),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1),
            // actions: [LanguagePickerWidget()],
          ),
          backgroundColor: Colors.white,
          body: Scaffold(
              // resizeToAvoidBottomInset: false,
              body: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/img/logo_size_2.jpg',
                    height: 100, width: 100),
                TitleWidget(
                  icon: Icons.login,
                  text: AppLocalizations.of(context).welcome,
                  color: ArgonColors.redUnito,
                  fontSize: 36,
                ),
                const SizedBox(height: 32),
                buildEmail(),
                const SizedBox(height: 12),
                buildPassword(),
                const SizedBox(height: 50),
                buildLoginButton(),
                const SizedBox(height: 50),
                builRegisteredButton(),
                const SizedBox(height: 20),
                Visibility(
                  visible: visible,
                  child: Center(
                      child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: CircularProgressIndicator(
                            backgroundColor: ArgonColors.redUnito,
                          ))),
                )
              ],
            ),
          )),
        ));
  }

  Widget buildEmail() => buildTitle(
        title: 'E-mail',
        child: TextFormField(
          key: Key("email"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context).error_email_empty;
            }
            if (!EmailValidator.validate(value)) {
              return AppLocalizations.of(context).error_email_not_valid;
            }
            return null;
          },
          controller: emailController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              hintText: AppLocalizations.of(context).youremail,
              prefixIcon: Icon(Icons.email)),
        ),
      );

  Widget buildPassword() => buildTitle(
        title: 'Password',
        child: TextFormField(
          key: Key("password"),
          obscureText: _obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context).error_password_empty;
            }
            return null;
          },
          controller: passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            hintText: AppLocalizations.of(context).yourpassword,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: GestureDetector(
              onTap: () async {
                print(this.emailController.text);
                _toggle();
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );

  Widget buildLoginButton() => ButtonWidget(
      pressed: true,
      text: AppLocalizations.of(context).login,
      color: ArgonColors.redUnito,
      keyValue: "login",
      onClicked: () async {
        if (formKey.currentState.validate()) {
          userLogin();
        }
      });

  Widget builRegisteredButton() => ButtonWidget(
      pressed: true,
      text: AppLocalizations.of(context).signup,
      keyValue: "signup",
      color: ArgonColors.blueUnito,
      onClicked: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signup()));
      });

  Widget buildTitle({
    String title,
    Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}
