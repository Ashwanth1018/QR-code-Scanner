import 'dart:io';

import 'package:flutter/material.dart';

import 'student_storage.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({
    super.key,
    required this.student,
    required this.rawData,
    required this.onEdit,
    required this.onScanAgain,
    required this.onHome,
  });

  final Student student;
  final String rawData;
  final VoidCallback onEdit;
  final VoidCallback onScanAgain;
  final VoidCallback onHome;

  Widget _studentPhoto() {
    final String? photoPath = student.photoPath;
    if (photoPath == null) {
      return const CircleAvatar(
        radius: 68,
        backgroundColor: Color(0xFFE2F1EF),
        child: Icon(Icons.person_rounded, size: 72, color: Color(0xFF087E79)),
      );
    }

    return ClipOval(
      child: Image.file(
        File(photoPath),
        width: 136,
        height: 136,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const CircleAvatar(
              radius: 68,
              backgroundColor: Color(0xFFE2F1EF),
              child: Icon(
                Icons.broken_image_outlined,
                size: 56,
                color: Color(0xFF087E79),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit student',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),
                Center(child: _studentPhoto()),
                const SizedBox(height: 22),
                Text(
                  student.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REGISTER NUMBER',
                        style: TextStyle(
                          color: Color(0xFF61747A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        student.registerNumber,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ExpansionTile(
                  title: const Text('Show raw QR data'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(rawData),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onScanAgain,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Again'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onHome,
                  icon: const Icon(Icons.home),
                  label: const Text('Home'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
