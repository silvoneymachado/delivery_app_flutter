import 'dart:math';

import 'package:dw9_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:dw9_delivery_app/app/pages/auth/register/register_controller.dart';
import 'package:dw9_delivery_app/app/pages/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  void togglePassState() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  void toggleConfirmPassState() {
    setState(() {
      _hideConfirmPassword = !_hideConfirmPassword;
    });
  }

  @override
  void onReady() {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
            any: () => hideLoader(),
            register: () => showLoader(),
            error: () {
              hideLoader();
              showError('Erro ao criar cadastro');
            },
            success: () {
              hideLoader();
              showSuccess('Cadastro criado com sucesso');
              Navigator.pop(context);
            });
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Cadastro', style: context.textStyles.textTitle),
                    Text('Preencha os campos para cria o cadastro',
                        style: context.textStyles.textMedium
                            .copyWith(fontSize: 18)),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      controller: _nameEC,
                      validator: Validatorless.required('Campo obrigatório'),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      controller: _emailEC,
                      validator: Validatorless.multiple([
                        Validatorless.required('Campo obrigatório'),
                        Validatorless.email('Email inválido'),
                      ]),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
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
                      obscureText: _hidePassword,
                      validator: Validatorless.multiple([
                        Validatorless.required('Campo obrigatório'),
                        Validatorless.min(
                            6, 'Senha deve conter pelo menos 6 caracteres'),
                      ]),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirma Senha',
                        suffixIcon: Align(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: InkWell(
                            onTap: toggleConfirmPassState,
                            child: Icon(_hideConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                      obscureText: _hideConfirmPassword,
                      validator: Validatorless.multiple([
                        Validatorless.required('Campo obrigatório'),
                        Validatorless.compare(
                            _passwordEC, 'As senhas precisam ser iguais')
                      ]),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: DeliveryButton(
                          label: 'Cadastrar',
                          onPressed: () {
                            final valid =
                                _formKey.currentState?.validate() ?? false;

                            if (valid) {
                              controller.register(_nameEC.text, _emailEC.text,
                                  _passwordEC.text);
                            }
                          },
                          width: double.infinity),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
