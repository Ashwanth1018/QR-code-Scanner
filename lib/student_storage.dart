import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Student {
  const Student({
    required this.registerNumber,
    required this.name,
    this.photoPath,
  });

  final String registerNumber;
  final String name;
  final String? photoPath;

  factory Student.fromMap(Map<String, Object?> map) {
    return Student(
      registerNumber: map['register_number']! as String,
      name: map['name']! as String,
      photoPath: map['photo_path'] as String?,
    );
  }

  Map<String, Object?> toMap() => {
    'register_number': registerNumber,
    'name': name,
    'photo_path': photoPath,
  };
}

class StudentStorage {
  StudentStorage._();

  static final StudentStorage instance = StudentStorage._();

  Future<Database>? _database;

  Future<Database> get _db => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    try {
      final String databasePath = await getDatabasesPath();
      return await openDatabase(
        p.join(databasePath, 'qr_attend_students.db'),
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute('''
            CREATE TABLE students (
              register_number TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              photo_path TEXT
            )
          ''');
        },
      );
    } catch (_) {
      _database = null;
      rethrow;
    }
  }

  Future<Student?> findStudent(String registerNumber) async {
    final Database database = await _db;
    final List<Map<String, Object?>> rows = await database.query(
      'students',
      where: 'register_number = ?',
      whereArgs: [registerNumber.trim()],
      limit: 1,
    );
    return rows.isEmpty ? null : Student.fromMap(rows.first);
  }

  Future<Student> saveStudent({
    required String registerNumber,
    required String name,
    String? selectedPhotoPath,
    bool removePhoto = false,
  }) async {
    final String normalizedRegisterNumber = registerNumber.trim();
    final String normalizedName = name.trim();
    if (normalizedRegisterNumber.isEmpty) {
      throw ArgumentError.value(registerNumber, 'registerNumber');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name');
    }

    final Database database = await _db;
    final Student? previous = await findStudent(normalizedRegisterNumber);
    String? savedPhotoPath = removePhoto ? null : previous?.photoPath;
    String? copiedPhotoPath;

    if (selectedPhotoPath != null) {
      final File selectedPhoto = File(selectedPhotoPath);
      if (!await selectedPhoto.exists()) {
        throw FileSystemException(
          'The selected student photo is no longer available.',
          selectedPhotoPath,
        );
      }

      final Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      final Directory photoDirectory = Directory(
        p.join(documentsDirectory.path, 'student_photos'),
      );
      await photoDirectory.create(recursive: true);

      final String safeRegisterNumber = normalizedRegisterNumber.replaceAll(
        RegExp(r'[^A-Za-z0-9_-]'),
        '_',
      );
      String extension = p.extension(selectedPhotoPath);
      if (!RegExp(r'^\.[A-Za-z0-9]{1,8}$').hasMatch(extension)) {
        extension = '.jpg';
      }
      copiedPhotoPath = p.join(
        photoDirectory.path,
        'student_${safeRegisterNumber}_${DateTime.now().microsecondsSinceEpoch}'
        '$extension',
      );
      await selectedPhoto.copy(copiedPhotoPath);
      savedPhotoPath = copiedPhotoPath;
    }

    final Student student = Student(
      registerNumber: normalizedRegisterNumber,
      name: normalizedName,
      photoPath: savedPhotoPath,
    );

    try {
      await database.insert(
        'students',
        student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      if (copiedPhotoPath != null) {
        await _deleteManagedPhoto(copiedPhotoPath);
      }
      rethrow;
    }

    final String? previousPhotoPath = previous?.photoPath;
    if (previousPhotoPath != null &&
        previousPhotoPath != savedPhotoPath &&
        (copiedPhotoPath != null || removePhoto)) {
      await _deleteManagedPhoto(previousPhotoPath);
    }
    return student;
  }

  Future<void> _deleteManagedPhoto(String photoPath) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String managedDirectory = p.join(
      documentsDirectory.path,
      'student_photos',
    );
    final String normalizedPhotoPath = p.normalize(photoPath);
    if (!p.isWithin(managedDirectory, normalizedPhotoPath)) return;

    final File photo = File(normalizedPhotoPath);
    if (await photo.exists()) {
      await photo.delete();
    }
  }
}
