part of '../forgot_password.dart';

/// Email form component for the first step of forgot password flow
class _EmailForm extends StatelessWidget {
  const _EmailForm({
    required this.controller,
  });

  final ForgotPasswordController controller;

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
        key: controller.emailFormKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Şifrenizi mi unuttunuz?',
                style: context.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'E-posta adresinizi girin, size bir doğrulama kodu göndereceğiz.',
                style: context.titleMedium.copyWith(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),
              // Email input field
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  hintText: 'example@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                ),
                keyboardType: TextInputType.emailAddress,
                validator: controller.validator.isMail,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.onTapSendCode(),
              ),
              const SizedBox(height: 24),
              // Send code button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.onTapSendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Kod Gönder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Back to login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Şifrenizi hatırladınız mı? ',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onTapBackToLogin,
                    child: Text(
                      'Giriş Yap',
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
