// ignore_for_file: lines_longer_than_80_chars

import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/navigation/modules/auth_route/auth_route_enums.dart';
import 'package:widgets/widget.dart';

/// Controller for Forgot Password Screen
class ForgotPasswordController extends BaseControllerInterface {
  /// Global form key for email form
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  
  /// Global form key for verification code form
  final GlobalKey<FormState> verificationFormKey = GlobalKey<FormState>();
  
  /// Global form key for new password form
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  
  /// Text controller for email input
  final TextEditingController emailController = TextEditingController();
  
  /// Text controller for verification code input
  final TextEditingController codeController = TextEditingController();
  
  /// Text controller for new password input
  final TextEditingController newPasswordController = TextEditingController();
  
  /// Text controller for confirm password input
  final TextEditingController confirmPasswordController = TextEditingController();

  /// Current step in the forgot password flow
  final RxInt currentStep = 0.obs;
  
  /// Email entered by the user (stored for verification steps)
  String? userEmail;

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {});
  }

  /// Navigate to login screen
  void onTapBackToLogin() => context.goNamed(AuthRouteScreens.loginScreen.name);

  /// Send verification code to the user's email
  Future<void> onTapSendCode() async {
    final labels = AppLocalization.getLabels(context);
    
    if (emailFormKey.currentState!.validate()) {
      userEmail = emailController.text.trim();
      
      // Show loading indicator
      LoadingProgress.start();
      
      // Create request model for sending verification code
      final request = ForgotPasswordRequestModel(
        email: userEmail!,
      );
      
      // Call API to send verification code
      await client.appService.sendForgotPasswordCode(request: request).handleRequest(
        defaultResponse: BaseResponseModel(),
        onSuccess: (res) {
          // Move to verification code step
          currentStep.value = 1;
          showSuccessToastMessage(labels.verificationCodeSent);
        },
        ignoreException: true,
        onIgnoreException: (err) => showErrorToastMessage(
          err?.detail ?? labels.somethingWentWrong,
        ),
      );
      
      LoadingProgress.stop();
    }
  }

  /// Verify the code entered by the user
  Future<void> onTapVerifyCode() async {
    final labels = AppLocalization.getLabels(context);
    
    if (verificationFormKey.currentState!.validate()) {
      // Show loading indicator
      LoadingProgress.start();
      
      // Create request model for verifying code
      final request = VerifyForgotPasswordRequestModel(
        email: userEmail!,
        code: codeController.text.trim(),
      );
      
      // Call API to verify code
      await client.appService.verifyForgotPasswordCode(request: request).handleRequest(
        defaultResponse: BaseResponseModel(),
        onSuccess: (res) {
          // Move to reset password step
          currentStep.value = 2;
          showSuccessToastMessage(labels.codeVerified);
        },
        ignoreException: true,
        onIgnoreException: (err) => showErrorToastMessage(
          err?.detail ?? labels.invalidCode,
        ),
      );
      
      LoadingProgress.stop();
    }
  }

  /// Reset the user's password with the new password
  Future<void> onTapResetPassword() async {
    final labels = AppLocalization.getLabels(context);
    
    if (passwordFormKey.currentState!.validate()) {
      // Check if passwords match
      if (newPasswordController.text != confirmPasswordController.text) {
        showErrorToastMessage(labels.passwordsDoNotMatch);
        return;
      }
      
      // Show loading indicator
      LoadingProgress.start();
      
      // Create request model for resetting password
      final request = ResetPasswordRequestModel(
        email: userEmail!,
        code: codeController.text.trim(),
        newPassword: newPasswordController.text,
      );
      
      // Call API to reset password
      await client.appService.resetPassword(request: request).handleRequest(
        defaultResponse: BaseResponseModel(),
        onSuccess: (res) {
          showSuccessToastMessage(labels.passwordResetSuccess);
          // Navigate back to login screen
          context.goNamed(AuthRouteScreens.loginScreen.name);
        },
        ignoreException: true,
        onIgnoreException: (err) => showErrorToastMessage(
          err?.detail ?? labels.somethingWentWrong,
        ),
      );
      
      LoadingProgress.stop();
    }
  }

  /// Resend verification code to the user's email
  Future<void> onTapResendCode() async {
    final labels = AppLocalization.getLabels(context);
    
    if (userEmail != null && userEmail!.isNotEmpty) {
      // Show loading indicator
      LoadingProgress.start();
      
      // Create request model for resending verification code
      final request = ForgotPasswordRequestModel(
        email: userEmail!,
      );
      
      // Call API to resend verification code
      await client.appService.sendForgotPasswordCode(request: request).handleRequest(
        defaultResponse: BaseResponseModel(),
        onSuccess: (res) {
          showSuccessToastMessage(labels.verificationCodeResent);
        },
        ignoreException: true,
        onIgnoreException: (err) => showErrorToastMessage(
          err?.detail ?? labels.somethingWentWrong,
        ),
      );
      
      LoadingProgress.stop();
    } else {
      showErrorToastMessage(labels.emailRequired);
    }
  }
}
