part of '../login.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.controller,
  });

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.grey[900]!, Colors.grey[850]!]
              : [Colors.grey[100]!, Colors.white],
        ),
      ),
      child: Form(
        key: controller.fKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.i10n.welcomeBack,
                style: context.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.i10n.loginToYourAccount,
                style: context.titleMedium.copyWith(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),
              ModuleTextField(
                controller: controller.cEmail,
                labelText: context.i10n.eMail,
                hintText: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: controller.validator.isMail,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              ModuleTextField(
                controller: controller.cPassword,
                labelText: context.i10n.password,
                hintText: '••••••••',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: controller.validator.isNotEmptyController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.onTapLogin(),
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Obx(
                          () => Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: (bool? value) {
                              controller.rememberMe.value = value!;
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Beni hatırla',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: Text(
                      'Şifremi Unuttum',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.onTapLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    context.i10n.login,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'veya',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     _SocialLoginButton(
              //       icon: 'assets/icons/google.png',
              //       onTap: () {
              //       },
              //     ),
              //     _SocialLoginButton(
              //       icon: 'assets/icons/facebook.png',
              //       onTap: () {
              //       },
              //     ),
              //     _SocialLoginButton(
              //       icon: 'assets/icons/apple.png',
              //       onTap: () {
              //       },
              //     ),
              //   ],
              // ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hesabın yok mu? ',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onTapRegister,
                    child: Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
