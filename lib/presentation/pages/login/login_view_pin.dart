// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/routes.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class LoginPinView extends StatefulWidget {
  const LoginPinView({super.key});

  @override
  State<LoginPinView> createState() => _LoginPinViewState();
}

class _LoginPinViewState extends State<LoginPinView> {
  final TextEditingController _pinController =
      TextEditingController(text: GlobalConstants.debugpin);

  @override
  void dispose() {
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
            Text(
              'Enter 6 digit MPIN,\nprovided by your Church',
              style: context.textTheme.titleLarge,
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 3,
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
            buildPinPut(),
            TextButton(
                onPressed: () async {
                  context.go(MCANavigation.createUser);
                },
                child: const Text('Sign up')),
            ElevatedButton(onPressed: login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }

  Widget buildPinPut() {
    return Pinput(
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
      errorPinTheme: PinTheme(
          height: 100.h,
          width: 90.w,
          textStyle: context.textTheme.headlineSmall,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: context.colorScheme.error),
          )),
      defaultPinTheme: PinTheme(
          height: 100.h,
          width: 90.w,
          textStyle: context.textTheme.headlineSmall,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(10.r),
            border:
                Border.all(color: context.colorScheme.primary.withOpacity(.2)),
          )),
      focusedPinTheme: PinTheme(
          height: 100.h,
          width: 90.w,
          textStyle: context.textTheme.headlineSmall,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: context.colorScheme.primary),
          )),
      keyboardType: TextInputType.text,
      onCompleted: (value) {
        login();
      },
    );
  }

  void login() {
    if (_pinController.text.isEmpty) {
      context.showError('PIN cannot be empty');
      return;
    }
    if (_pinController.text.length != 6) {
      context.showError('PIN must be 6 digits');
      return;
    }
    context.futureLoading(() async {
      final success = await DependencyManager.instance.navigation.loginState
          .loginWithPin(_pinController.text);
      if (success.isLeft) {
        context.showError(success.left);
      }
    });
  }
}
