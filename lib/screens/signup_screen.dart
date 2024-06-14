import 'package:ayna_chat/blocs/authentication_bloc.dart';
import 'package:ayna_chat/constants/color_const.dart';
import 'package:ayna_chat/constants/text_const.dart';
import 'package:ayna_chat/events/authentication_events.dart';
import 'package:ayna_chat/events/authentication_state.dart';
import 'package:ayna_chat/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
          if (state is AuthencationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AuthencationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              return const Center(child: Text("error"));
            }
            return Padding(
              padding: MediaQuery.of(context).size.width > 600
                  ? const EdgeInsets.symmetric(horizontal: 100, vertical: 32)
                  : const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/ayna_bg.png",
                              fit: BoxFit.cover),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(36),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                                _isLoginMode
                                    ? "Ayna chat - Login"
                                    : "Ayna chat - Signup",
                                style: kSubHeadingTextStyle),
                            Text(
                                "Built with Bloc, Hive, Websocket and Firebase",
                                style: kSmallParaTextStyle),
                            SizedBox(height: 136),
                            ClipPath(
                              clipper: ShapeBorderClipper(
                                shape: ContinuousRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    side: BorderSide(
                                      color: softGrayStrokeCustomColor,
                                      width: 2,
                                    )),
                              ),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: kSmallParaTextStyle,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blue.shade50,
                                  labelStyle: kSmallParaTextStyle,
                                  labelText: 'Email',

                                  border: InputBorder.none, // Remove the border
                                  errorStyle: kSmallParaTextStyle.copyWith(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            ClipPath(
                              clipper: ShapeBorderClipper(
                                shape: ContinuousRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    side: BorderSide(
                                      color: softGrayStrokeCustomColor,
                                      width: 2,
                                    )),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blue.shade50,
                                  labelStyle: kSmallParaTextStyle,
                                  labelText: 'Password',

                                  border: InputBorder.none, // Remove the border
                                  errorStyle: kSmallParaTextStyle.copyWith(
                                      color: Colors.red, fontSize: 12),
                                ),
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 16),
                            ClipPath(
                              clipper: const ShapeBorderClipper(
                                shape: ContinuousRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                              child: SizedBox(
                                width: 200,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_isLoginMode) {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(
                                        LoggedIn(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    } else {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(
                                        SignUpRequested(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.46),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryBlueCustomColor),
                                  ),
                                  child: Text(
                                    _isLoginMode ? 'Login' : 'Sign Up',
                                    style: kSubHeadingTextStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLoginMode = !_isLoginMode;
                                });
                              },
                              child: Text(_isLoginMode ? 'Sign Up?' : 'Login?'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement the sign up functionality
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
