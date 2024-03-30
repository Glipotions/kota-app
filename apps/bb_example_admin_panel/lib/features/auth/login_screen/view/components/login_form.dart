part of '../login.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.controller,
  });

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.fKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.i10n.welcomeBack,
            style: context.headlineMedium,
          ),
          SizedBox(height: ModulePadding.s.value),
          Text(
            context.i10n.loginToYourAccount,
            style: context.titleMedium,
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleTextField(
            controller: controller.cEmail,
            labelText: context.i10n.eMail,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validator.isMail,
            onFieldSubmitted: (_)=>controller.onTapLogin(),
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleTextField(
            controller: controller.cPassword,
            labelText: context.i10n.password,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: controller.validator.isNotEmptyController,
            onFieldSubmitted: (_)=>controller.onTapLogin(),
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleButton.primary(
            onTap: controller.onTapLogin,
            title: context.i10n.login,
          ),
        ],
      ),
    );
  }
}
