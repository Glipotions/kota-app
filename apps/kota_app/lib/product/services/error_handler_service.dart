import 'dart:async';
import 'dart:io';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/session_handler.dart';

/// Service for handling errors in a consistent way across the app
///
/// This service centralizes error handling logic to provide a consistent user experience
/// when errors occur. It handles different types of errors (network, server, validation, etc.)
/// and presents appropriate feedback to the user.
///
/// Key features:
/// - Categorizes errors by type for appropriate messaging
/// - Provides visual feedback through snackbars or dialogs
/// - Handles special cases like authentication errors
/// - Works with or without BuildContext for flexibility
///
/// This service follows the singleton pattern to ensure consistent error handling
/// throughout the application.
class ErrorHandlerService {
  /// Private constructor
  ErrorHandlerService._();

  /// Singleton instance
  static final ErrorHandlerService _instance = ErrorHandlerService._();

  /// Get the singleton instance
  static ErrorHandlerService get instance => _instance;

  /// Handle API errors with appropriate user feedback
  ///
  /// This method categorizes API errors by type and displays appropriate error messages.
  /// It handles common error scenarios including:
  /// - Network timeouts
  /// - Connection issues
  /// - Authentication failures
  /// - Server errors
  ///
  /// For authentication errors, it also triggers the logout process to redirect
  /// the user to the login screen.
  ///
  /// @param error The error object to handle (can be various types)
  /// @param context Optional BuildContext for showing UI feedback (can be null)
  void handleApiError(dynamic error, BuildContext? context) {
    final labels = AppLocalization.getLabels(Get.context ?? context!);
    String errorMessage;

    if (error is TimeoutException) {
      errorMessage = labels.timeoutErrorMessage;
    } else if (error is SocketException) {
      errorMessage = labels.noInternetErrorMessage;
    } else if (error is UnauthorizedException) {
      errorMessage = labels.unauthorizedErrorMessage;
      // Handle unauthorized (e.g., logout user)
      _handleUnauthorized();
    } else if (error is ServerException) {
      errorMessage = labels.serverErrorMessage;
    } else {
      // Default error message
      errorMessage = labels.defaultErrorMessage;
    }

    _showErrorMessage(errorMessage, context);
  }

  /// Handle form validation errors
  void handleValidationError(String message, BuildContext? context) {
    _showErrorMessage(message, context);
  }

  /// Handle general errors
  void handleGeneralError(dynamic error, BuildContext? context) {
    final labels = AppLocalization.getLabels(Get.context ?? context!);
    String errorMessage;

    if (error is String) {
      errorMessage = error;
    } else {
      errorMessage = labels.defaultErrorMessage;
    }

    _showErrorMessage(errorMessage, context);
  }

  /// Show error message to the user with appropriate UI feedback
  ///
  /// This method displays error messages to the user through either:
  /// - GetX snackbars (when no context is available)
  /// - Material snackbars (when context is available)
  ///
  /// The method adapts to the available context to ensure errors are always
  /// displayed, even in scenarios where a BuildContext might not be accessible.
  /// Both display methods use consistent styling for error messages.
  ///
  /// @param message The error message to display
  /// @param context Optional BuildContext for showing UI feedback (can be null)
  void _showErrorMessage(String message, BuildContext? context) {
    // Use GetX snackbar if context is not available
    if (context == null || !context.mounted) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        margin: const EdgeInsets.all(8),
        // Default duration is 3 seconds
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } else {
      // Use ScaffoldMessenger if context is available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  /// Handle unauthorized errors (e.g., expired token)
  ///
  /// This method is called when an unauthorized error (401) is detected.
  /// It attempts to find the SessionHandler and log the user out, which typically
  /// redirects them to the login screen.
  ///
  /// If the SessionHandler can't be found or an error occurs during logout,
  /// the error is logged but not propagated to avoid crashing the app.
  void _handleUnauthorized() {
    // Get the session handler and log out
    try {
      // Call logOut directly on the found instance
      Get.find<SessionHandler>().logOut();
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  /// Show a confirmation dialog with customizable options
  ///
  /// This method displays a Material Design confirmation dialog with:
  /// - A title and message explaining the action
  /// - Confirm and cancel buttons with customizable text
  /// - Styling that emphasizes the confirm action as a potentially destructive action
  ///
  /// The dialog is modal and returns a Future<bool> that resolves to:
  /// - true if the user confirms the action
  /// - false if the user cancels or dismisses the dialog
  ///
  /// This is particularly useful for confirming destructive or important actions
  /// before proceeding.
  ///
  /// @param title The dialog title
  /// @param message The detailed explanation message
  /// @param context The BuildContext for showing the dialog
  /// @param confirmText Optional custom text for the confirm button
  /// @param cancelText Optional custom text for the cancel button
  /// @return A Future that resolves to true if confirmed, false otherwise
  Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    required BuildContext context,
    String? confirmText,
    String? cancelText,
  }) async {
    final labels = AppLocalization.getLabels(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(cancelText ?? labels.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(
                confirmText ?? labels.confirm,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Show a success message with appropriate visual feedback
  ///
  /// This method displays success messages to the user through either:
  /// - GetX snackbars (when no context is available)
  /// - Material snackbars (when context is available)
  ///
  /// Success messages use green color styling and a check icon to visually
  /// differentiate them from error messages. The display duration is shorter
  /// than for error messages since success feedback typically requires less
  /// user attention.
  ///
  /// @param message The success message to display
  /// @param context Optional BuildContext for showing UI feedback (can be null)
  void showSuccessMessage(String message, BuildContext? context) {
    // Use GetX snackbar if context is not available
    if (context == null || !context.mounted) {
      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        margin: const EdgeInsets.all(8),
        duration: const Duration(seconds: 2),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      );
    } else {
      // Use ScaffoldMessenger if context is available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}

/// Exception for unauthorized errors (HTTP 401)
///
/// This exception is thrown when an API request fails due to authentication issues,
/// such as an expired token or invalid credentials. It's typically handled by
/// logging the user out and redirecting to the login screen.
///
/// The exception includes a customizable message that defaults to 'Unauthorized'
/// if none is provided.
class UnauthorizedException implements Exception {
  /// Constructor
  UnauthorizedException([this.message = 'Unauthorized']);

  /// Error message
  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exception for server errors (HTTP 5xx)
///
/// This exception is thrown when an API request fails due to server-side issues,
/// such as internal server errors, service unavailability, or other backend problems.
/// These errors are typically not resolvable by the client application and require
/// server-side investigation.
///
/// The exception includes a customizable message that defaults to 'Server error'
/// if none is provided.
class ServerException implements Exception {
  /// Constructor
  ServerException([this.message = 'Server error']);

  /// Error message
  final String message;

  @override
  String toString() => 'ServerException: $message';
}
