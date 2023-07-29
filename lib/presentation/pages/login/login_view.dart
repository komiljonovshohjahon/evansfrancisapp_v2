// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/routes.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController =
      TextEditingController(text: GlobalConstants.debugusername);
  final TextEditingController _passwordController =
      TextEditingController(text: GlobalConstants.debugpassword);
  final TextEditingController _pinController =
      TextEditingController(text: GlobalConstants.debugpin);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SpacedColumn(
          mainAxisSize: MainAxisSize.min,
          verticalSpace: 16,
          children: [
            Text('Login', style: context.textTheme.headlineLarge),
            // add login form, email and password and login with firebase auth
            DefaultTextField(
              label: 'Email',
              controller: _emailController,
            ),
            DefaultTextField(
              label: 'Password',
              controller: _passwordController,
            ),
            // TextButton(
            //     onPressed: () async {
            //       context.futureLoading(() async {
            //         final success = await DependencyManager
            //             .instance.navigation.loginState
            //             .resetPassword(_emailController.text);
            //         if (success.isLeft) {
            //           context.showError(success.left);
            //         } else {
            //           context.showSuccess('Reset Password Email Sent');
            //         }
            //       });
            //     },
            //     child: const Text('Forgot Password')),
            TextButton(
                onPressed: () async {
                  context.go(MCANavigation.createUser);
                },
                child: const Text('Register')),
            ElevatedButton(
                onPressed: () {
                  context.futureLoading(() async {
                    final success = await DependencyManager
                        .instance.navigation.loginState
                        .loginWithPin(_pinController.text);
                    if (success.isLeft) {
                      context.showError(success.left);
                    }
                  });
                },
                child: const Text('Login')),
          ],
        ),
      ),
    );
  }

  Widget buildPinPut() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Pinput(
        validator: (value) {
          //not empty
          //6 digits
          if (value!.isEmpty) {
            return 'PIN cannot be empty';
          }
          if (value.length != 6) {
            return 'PIN must be 6 digits';
          }
          return null;
        },
        controller: _pinController,
        length: 6,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
