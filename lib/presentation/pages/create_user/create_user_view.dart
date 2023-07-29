// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/manager.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView>
    with FormsMixin<CreateUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SpacedColumn(
                mainAxisSize: MainAxisSize.min,
                verticalSpace: 16,
                children: [
                  Text('Create User', style: context.textTheme.headlineSmall),
                  DefaultTextField(
                    label: 'Name',
                    controller: controller1,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  DefaultTextField(
                    label: 'Email',
                    controller: controller2,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      return null;
                    },
                  ),
                  //phone number
                  DefaultTextField(
                    label: 'Phone Number',
                    controller: controller3,
                    keyboardType: TextInputType.number,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Phone Number cannot be empty';
                      }
                      return null;
                    },
                  ),

                  //login instead button
                  TextButton(
                    onPressed: () {
                      context.go(MCANavigation.login);
                    },
                    child: const Text('Login Instead?'),
                  ),

                  //create user button
                  ElevatedButton(
                    onPressed: () async {
                      if (isFormValid) {
                        context.futureLoading(() async {
                          final success = await DependencyManager
                              .instance.firestore
                              .createUser(
                            name: controller1.text,
                            email: controller2.text,
                            phone: controller3.text,
                          );
                          if (success.isLeft) {
                            context.showError(success.left);
                          } else {
                            context.go(MCANavigation.login);
                            context.showSuccess(
                                'User Created. Please contact admin to provide you with a PIN');
                          }
                        });
                      }
                    },
                    child: const Text('Create User'),
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
