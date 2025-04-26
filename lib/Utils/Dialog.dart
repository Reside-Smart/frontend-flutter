import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  // Success Dialog
  static void showSuccess(String message, {String title = 'Success'}) {
    Get.dialog(
      _ModernDialog(type: DialogType.success, title: title, message: message),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close the dialog
      }
    });
  }

  // Error Dialog
  static void showError(String message, {String title = 'Error'}) {
    Get.dialog(
      _ModernDialog(type: DialogType.error, title: title, message: message),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close the dialog
      }
    });
  }

  static void showConfirm({
    String message = "Are you sure?.",
    String title = 'Confirm',
    VoidCallback? onConfirm, // Callback function
  }) {
    DialogType type = DialogType.secondary;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: type.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(type.icon, size: 32, color: type.color),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Buttons (Cancel & Confirm)
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(
                          width: 2, // Proper border width
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (onConfirm != null) {
                          onConfirm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: type.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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

// Custom Dialog Widget
class _ModernDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;

  const _ModernDialog({
    required this.type,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: type.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(type.icon, size: 32, color: type.color),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: type.color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog Type Configuration
enum DialogType {
  success(Color(0xFF4CAF50)),
  error(Color(0xFFF44336)),
  secondary(Color(0xFFFFBC37)),
  primary(Color(0xFF4F659C));

  final Color color;

  const DialogType(this.color);

  IconData get icon {
    switch (this) {
      case DialogType.success:
        return Icons.check_circle;
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.primary:
        return Icons.info_outline;
      case DialogType.secondary:
        return Icons.info_outline;
    }
  }
}
