// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          height: 600,
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.onBackground.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalSpace: 32,
            children: [
              Text('Login View', style: context.textTheme.headlineLarge),
              // add login form, email and password and login with firebase auth
              DefaultTextField(
                label: 'Email',
                controller: _emailController,
              ),
              DefaultTextField(
                label: 'Password',
                obscureText: true,
                controller: _passwordController,
              ),
              TextButton(
                  onPressed: () async {
                    context.futureLoading(() async {
                      final success = await DependencyManager
                          .instance.navigation.loginState
                          .resetPassword(_emailController.text);
                      if (success.isLeft) {
                        context.showError(success.left);
                      } else {
                        context.showSuccess('Reset Password Email Sent');
                      }
                    });
                  },
                  child: const Text('Forgot Password')),

              ElevatedButton(
                  onPressed: () {
                    // login with firebase auth
                    context.futureLoading(() async {
                      final success = await DependencyManager
                          .instance.navigation.loginState
                          .login(
                              _emailController.text, _passwordController.text);
                      if (success.isLeft) {
                        context.showError(success.left);
                      }
                    });
                  },
                  child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
