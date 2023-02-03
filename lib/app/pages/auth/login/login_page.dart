import 'package:dw9_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:dw9_delivery_app/app/pages/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import 'login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginController> {
  final _passwordEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  void togglePassState() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  @override
  void onReady() {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginController, LoginState>(
      listener: (context, state) {
        state.status.matchAny(
            any: () => hideLoader(),
            login: () => showLoader(),
            error: () {
              hideLoader();
              showError('Erro ao realizar login');
            },
            loginError: () {
              hideLoader();
              showError('Email ou senha inválidos');
            },
            success: () {
              hideLoader();
              Navigator.pop(context, true);
            });
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login', style: context.textStyles.textTitle),
                        const SizedBox(height: 30),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'E-mail'),
                          controller: _emailEC,
                          validator: Validatorless.multiple([
                            Validatorless.required('Campo obrigatório'),
                            Validatorless.email('Email inválido'),
                          ]),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: Align(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: InkWell(
                                onTap: togglePassState,
                                child: Icon(_hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          controller: _passwordEC,
                          validator:
                              Validatorless.required('Campo obrigatório'),
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: DeliveryButton(
                              label: 'Entrar',
                              width: double.infinity,
                              onPressed: () {
                                final valid =
                                    _formKey.currentState?.validate() ?? false;
                                if (valid) {
                                  controller.login(
                                      _emailEC.text, _passwordEC.text);
                                }
                              }),
                        )
                      ],
                    )),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não possui conta?',
                          style: context.textStyles.textBold),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/auth/register');
                        },
                        child: Text('Cadastre-se',
                            style: context.textStyles.textBold
                                .copyWith(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
