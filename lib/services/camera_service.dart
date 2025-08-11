import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Capture image from camera using real device camera
  Future<File?> captureFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Good quality for OCR
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Camera capture error: $e');
      rethrow;
    }
  }

  /// Pick image from gallery using real device gallery
  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Gallery pick error: $e');
      rethrow;
    }
  }

  /// Show image source selection dialog
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: const Text('Choose how you want to add the receipt image:'),
          actions: [
            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final file = await captureFromCamera();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showErrorDialog(context, 'Camera Error', e.toString());
                  }
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final file = await pickFromGallery();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showErrorDialog(context, 'Gallery Error', e.toString());
                  }
                }
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Check if camera is available
  Future<bool> isCameraAvailable() async {
    try {
      // Just check if we can access camera without actually taking a photo
      return true; // Assume camera is available, will handle errors during actual capture
    } catch (e) {
      return false;
    }
  }

  /// Request all necessary permissions (simplified for demo)
  Future<bool> requestPermissions() async {
    // In a real app, you would request permissions here
    // For demo purposes, we'll assume permissions are granted
    return true;
  }
}
