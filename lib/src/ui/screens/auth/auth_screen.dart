import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tech_initiator/src/ui/components/custom_component.dart';
import 'package:social_tech_initiator/src/utils/utils.dart';

import '../../../../routes.dart';
import '../../../blocs/auth/auth_cubit.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../utils/app_strings.dart';
import '../../components/common_scaffold.dart';
import '../../components/custom_text_form_field.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: appTitle,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacementNamed(context, AppRoutes.postsScreen);
          } else if (state.isFailure && state.failureMessage != null) {
            showSnackBar(context, state.failureMessage!);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: pageMargin(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildTextFieldsColumn(context, state),
                  20.v,
                  buildButtonsSection(context, state)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTextFieldsColumn(BuildContext context, AuthState state) {
    return Column(
      children: [
        if (!state.isLogin)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomTextFormField(
              controller: _userNameController,
              label: "Username",
              validator: (value) =>
                  context.read<AuthCubit>().validateInput(value, 'username'),
              infoMessages: [
                "Username must be between 3 and 20 characters.",
                "It can only contain letters, numbers, and underscores.",
              ],
              focusNode: _userNameFocusNode,
              nextFocusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
            ),
          ),
        CustomTextFormField(
          controller: _emailController,
          label: "Email",
          validator: (value) =>
              context.read<AuthCubit>().validateInput(value, 'email'),
          infoMessages: [
            "Email should be in a valid format (e.g. user@example.com).",
          ],
          focusNode: _emailFocusNode,
          nextFocusNode: _passwordFocusNode,
          textInputAction: TextInputAction.next,
        ),
        10.v,
        CustomTextFormField(
          controller: _passwordController,
          label: "Password",
          obscureText: true,
          validator: (value) =>
              context.read<AuthCubit>().validateInput(value, 'password'),
          infoMessages: [
            "Password must have at least one uppercase letter, one number, and one special character.",
            "It should be at least 8 characters long.",
          ],
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget buildButtonsSection(BuildContext context, AuthState state) {
    return state.isLoading
        ? CircularProgressIndicator()
        : Column(
            children: [
              CustomButton(
                text: state.isLogin ? 'Login' : 'Signup',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().authenticate(
                          _emailController.text,
                          _passwordController.text,
                          username: state.isLogin
                              ? null
                              : _userNameController.text.trim(),
                        );
                  }
                },
              ),
              CustomButton(
                text: state.isLogin
                    ? 'Don’t have an account? Sign up'
                    : 'Already have an account? Login',
                onPressed: () {
                  context.read<AuthCubit>().toggleAuthMode();
                  _formKey.currentState?.reset();
                },
                isPrimary: false,
              ),
            ],
          );
  }
}
