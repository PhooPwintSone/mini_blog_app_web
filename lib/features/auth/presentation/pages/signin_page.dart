import 'package:blog_app/bloc/auth_bloc.dart';
import 'package:blog_app/core/common/responsive/constrained_scaffold.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_btn.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const SigninPage());
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  //Text field controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Key for form
  final formKey = GlobalKey<FormState>();

  //dispose the controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Build UI
    return ConstrainedScaffold(
      maxWidth: 430,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message.toString()),
                  backgroundColor: AppPallete.errorColor, // Make it pop!
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },

          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Title Text
                  Text(
                    '✨ Sign In',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 35),

                  //Text field group
                  // email
                  AuthTextfield(
                    hintText: "Email :",
                    controller: emailController,
                  ),
                  const SizedBox(height: 25),

                  //password
                  AuthTextfield(
                    hintText: "Password :",
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 25),

                  //Sign Up Btn
                  AuthGradientBtn(
                    btnText: "Sign In",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthSignIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  //Do u have an account ?
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SignupPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't you have an account ? ✍️ ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          //Btn to Sign In Page
                          TextSpan(
                            text: "Sign Up Here",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: AppPallete.gradient1,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
