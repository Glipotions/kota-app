import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/auth/forgot_password_screen/controller/forgot_password_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:values/values.dart';

part 'components/email_form.dart';
part 'components/verification_form.dart';
part 'components/reset_password_form.dart';

/// Widget for Forgot Password Screen View
class ForgotPassword extends StatelessWidget {
  /// Widget for Forgot Password Screen View
  const ForgotPassword({required this.controller, super.key});

  /// Controller for this view
  final ForgotPasswordController controller;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: controller.unFocus,
      
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          title: const Text('Şifremi Unuttum'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.onTapBackToLogin,
          ),
        ),
        body: BaseView<ForgotPasswordController>(
          controller: controller,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [Colors.grey[900]!, Colors.grey[850]!]
                    : [Colors.grey[100]!, Colors.white],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: screenSize.height * 0.2,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[850] : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const ImageAssets().exampleImage.image(
                                fit: BoxFit.cover,
                              ),
                          // Add a subtle overlay gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                          // Center text overlay
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Şifre Yenileme',
                                  style: context.headlineMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Obx(() {
                        switch (controller.currentStep.value) {
                          case 0:
                            return _EmailForm(controller: controller);
                          case 1:
                            return _VerificationForm(controller: controller);
                          case 2:
                            return _ResetPasswordForm(controller: controller);
                          default:
                            return _EmailForm(controller: controller);
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
