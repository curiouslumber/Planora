import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/bloc/auth_bloc.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/views/home_page.dart';
import 'package:planora/views/pages/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          final msg = state.message;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16.0,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4.0,
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeights.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Fill your information below\nor register with your social account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeights.regular,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(100),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeights.regular,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(100),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Stack(
                            children: [
                              TextField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                obscureText: _obscurePassword,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withAlpha(100),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 16.0,
                                top: 16.0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (_) {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: 'terms and conditions',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          if (kDebugMode) {
                                            print(
                                              'Terms and conditions tapped',
                                            );
                                          }
                                        },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed:
                            () => context.read<AuthBloc>().add(
                              EmailSignUpRequested(
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                                "EMAIL_PASSWORD"
                              ),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 1.0,
                              thickness: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeights.regular,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              height: 1.0,
                              thickness: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 16.0,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Ionicons.logo_apple),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.all(16.0),
                              shape: CircleBorder(),
                            ),
                          ),
                          IconButton(
                            onPressed:
                                () => context.read<AuthBloc>().add(
                                  GoogleSignInRequested(),
                                ),
                            icon: Icon(Ionicons.logo_google),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.all(16.0),
                              shape: CircleBorder(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Ionicons.logo_facebook),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.all(16.0),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap =
                                    () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
