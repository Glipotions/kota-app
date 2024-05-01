part of '../register.dart';

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.controller,
  });

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.fKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hoşgeldin',
            style: context.headlineMedium,
          ),
          SizedBox(height: ModulePadding.s.value),
          Text(
            'Kayıt Ol',
            style: context.titleMedium,
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleTextField(
            controller: controller.cEmail,
            labelText: context.i10n.eMail,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validator.isMail,
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleTextField(
            controller: controller.cPassword,
            labelText: context.i10n.password,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: controller.validator.isNotEmptyController,
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleTextField(
            controller: controller.cFullName,
            labelText: 'İsim-Soyisim',
            keyboardType: TextInputType.name,
            validator: controller.validator.isNotEmptyController,
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleTextField(
            controller: controller.cUserName,
            labelText: 'Kullanıcı Adı',
            keyboardType: TextInputType.name,
            validator: controller.validator.isNotEmptyController,
            onFieldSubmitted: (_) => controller.onTapRegister(),
          ),
          SizedBox(height: ModulePadding.s.value),
          ModuleButton.primary(
            onTap: controller.onTapRegister,
            title: 'Kayıt Ol',
          ),
          SizedBox(height: ModulePadding.s.value),
          Center(
            child: ClickableText(
              text: 'Giriş Yap',
              onTap: controller.onTapLogin,
            ),
          ),
        ],
      ),
    );
  }
}
