part of '../forgot_password.dart';

/// Verification form component for the second step of forgot password flow
class _VerificationForm extends StatelessWidget {
  const _VerificationForm({
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
        key: controller.verificationFormKey,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Doğrulama Kodu',
                style: context.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'E-posta adresinize gönderilen 6 haneli kodu girin.',
                style: context.titleMedium.copyWith(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),
              // Verification code input field
              TextFormField(
                controller: controller.codeController,
                decoration: InputDecoration(
                  labelText: 'Doğrulama Kodu',
                  hintText: '123456',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen doğrulama kodunu girin';
                  }
                  if (value.length != 6) {
                    return 'Doğrulama kodu 6 haneli olmalıdır';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.onTapVerifyCode(),
              ),
              const SizedBox(height: 24),
              // Verify code button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.onTapVerifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Doğrula',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Resend code button
              TextButton(
                onPressed: controller.onTapResendCode,
                child: Text(
                  'Kodu Tekrar Gönder',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Back to email step
              TextButton(
                onPressed: () => controller.currentStep.value = 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'E-posta Adresini Değiştir',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
