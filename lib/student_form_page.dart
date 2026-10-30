import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'student_storage.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({
    super.key,
    required this.registerNumber,
    this.existingStudent,
  });

  final String registerNumber;
  final Student? existingStudent;

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedPhotoPath;
  bool _isPickingPhoto = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.existingStudent?.name ?? '';
    _selectedPhotoPath = widget.existingStudent?.photoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    setState(() {
      _isPickingPhoto = true;
      _errorMessage = null;
    });
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (image != null && mounted) {
        setState(() => _selectedPhotoPath = image.path);
      }
    } on PlatformException catch (error) {
      debugPrint('PHOTO PICKER ERROR: $error');
      if (mounted) {
        setState(
          () =>
              _errorMessage =
                  'Could not open the photo gallery. Please try again.',
        );
      }
    } catch (error) {
      debugPrint('PHOTO PICKER ERROR: $error');
      if (mounted) {
        setState(
          () =>
              _errorMessage =
                  'The selected photo could not be loaded. Please try another.',
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    try {
      final Student savedStudent = await StudentStorage.instance.saveStudent(
        registerNumber: widget.registerNumber,
        name: _nameController.text,
        selectedPhotoPath:
            _selectedPhotoPath == widget.existingStudent?.photoPath
                ? null
                : _selectedPhotoPath,
        removePhoto:
            widget.existingStudent != null && _selectedPhotoPath == null,
      );
      if (mounted) Navigator.of(context).pop(savedStudent);
    } catch (error) {
      debugPrint('STUDENT SAVE ERROR: $error');
      if (mounted) {
        setState(() {
          _errorMessage =
              'Student details could not be saved. Please try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _photoPreview() {
    const double photoSize = 128;
    final String? photoPath = _selectedPhotoPath;
    if (photoPath == null) {
      return const CircleAvatar(
        radius: photoSize / 2,
        backgroundColor: Color(0xFFE2F1EF),
        child: Icon(Icons.person_rounded, size: 64, color: Color(0xFF087E79)),
      );
    }

    return ClipOval(
      child: Image.file(
        File(photoPath),
        width: photoSize,
        height: photoSize,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const CircleAvatar(
              radius: photoSize / 2,
              backgroundColor: Color(0xFFE2F1EF),
              child: Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Color(0xFF087E79),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.existingStudent != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit student' : 'Add student'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    isEditing
                        ? 'Update the saved student details.'
                        : 'Save this student on this device.',
                    style: const TextStyle(
                      color: Color(0xFF61747A),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: widget.registerNumber,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Register number',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _saveStudent(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter the student name.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Student name',
                      hintText: 'Enter full name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(child: _photoPreview()),
                  const SizedBox(height: 14),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed:
                              _isPickingPhoto || _isSaving ? null : _pickPhoto,
                          icon:
                              _isPickingPhoto || _isSaving
                                  ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.photo_library_outlined),
                          label: Text(
                            _selectedPhotoPath == null
                                ? 'Choose photo'
                                : 'Change photo',
                          ),
                        ),
                        if (_selectedPhotoPath != null)
                          TextButton.icon(
                            onPressed:
                                _isPickingPhoto
                                    ? null
                                    : () => setState(() {
                                      _selectedPhotoPath = null;
                                    }),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Remove'),
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Photo is optional and stays on this device.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF61747A)),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _saveStudent,
                    icon:
                        _isSaving
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Icon(Icons.save_outlined),
                    label: Text(isEditing ? 'Save changes' : 'Save student'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
