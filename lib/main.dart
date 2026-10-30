import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attend/student_form_page.dart';
import 'package:qr_attend/student_profile_page.dart';
import 'package:qr_attend/student_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QRAttendApp());
}

class QRAttendApp extends StatelessWidget {
  const QRAttendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Attend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087E79)),
        scaffoldBackgroundColor: const Color(0xFFF5F8F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F8F8),
          foregroundColor: Color(0xFF102A2A),
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color ink = Color(0xFF102A2A);
  static const Color teal = Color(0xFF087E79);
  static const Color pale = Color(0xFFE5F5F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: teal,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.qr_code_2_rounded,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('QR ATTEND',
                              style: TextStyle(
                                  color: ink,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.4,
                                  fontSize: 17)),
                          SizedBox(height: 2),
                          Text('STUDENT IDENTIFICATION',
                              style: TextStyle(
                                  color: Color(0xFF718181),
                                  fontSize: 10,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 8),
                        decoration: BoxDecoration(
                          color: pale,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shield_outlined, size: 15, color: teal),
                            SizedBox(width: 5),
                            Text('LOCAL',
                                style: TextStyle(
                                    color: teal,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D4745), Color(0xFF087E79)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('SMART CAMPUS TOOL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Identify students.\\nIn a single scan.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 31,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Scan a college ID to find a student record or add a new student.',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 14,
                              height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ScannerPage()),
                            ),
                            icon: const Icon(Icons.center_focus_strong_rounded),
                            label: const Text('Scan ID Card'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: teal,
                              minimumSize: const Size.fromHeight(56),
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text('HOW IT WORKS',
                      style: TextStyle(
                          color: Color(0xFF718181),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 13),
                  const _HomeFeature(
                    number: '01',
                    icon: Icons.qr_code_scanner_rounded,
                    title: 'Scan the ID',
                    subtitle: 'Read the QR code on a college ID card.',
                  ),
                  const SizedBox(height: 10),
                  const _HomeFeature(
                    number: '02',
                    icon: Icons.person_search_rounded,
                    title: 'Find the student',
                    subtitle: 'View saved details or register a new student.',
                  ),
                  const SizedBox(height: 10),
                  const _HomeFeature(
                    number: '03',
                    icon: Icons.phone_iphone_rounded,
                    title: 'Stored on this device',
                    subtitle: 'Student records stay in local app storage.',
                  ),
                  const SizedBox(height: 22),
                  const Center(
                    child: Text('Simple • Fast • Local-first',
                        style: TextStyle(
                            color: Color(0xFF829090),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
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

class _HomeFeature extends StatelessWidget {
  const _HomeFeature({
    required this.number,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F5F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF087E79), size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Color(0xFF102A2A),
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF718181), fontSize: 12, height: 1.35)),
              ],
            ),
          ),
          Text(number,
              style: const TextStyle(
                  color: Color(0xFF9BAAAA),
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  bool _processing = false;
  bool _torchOn = false;
  String _status = 'Point the camera at the QR code on your ID card.';
  String? _lastRawValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
      // Do not restrict formats: some ID cards may use a different barcode format.
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_processing) unawaited(_controller.start());
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(_controller.stop());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_controller.dispose());
    super.dispose();
  }

  String? _extractRegisterNumber(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    // First, look for a labelled value such as "Reg No: 12345".
    final labelled = RegExp(
      r'(?:register(?:\s*(?:number|no\.?))?|registration(?:\s*(?:number|no\.?))?|roll(?:\s*(?:number|no\.?))?|reg\s*no\.?)\s*[:=#\-]?\s*([A-Za-z0-9][A-Za-z0-9/-]{4,19})',
      caseSensitive: false,
    ).firstMatch(text);
    if (labelled != null) return labelled.group(1);

    // If the entire QR value is a register number, accept it.
    final plain = RegExp(r'^[A-Za-z0-9][A-Za-z0-9/-]{4,19}$');
    if (plain.hasMatch(text) && RegExp(r'\d').hasMatch(text)) return text;

    // Also handle text/URL payloads that contain a long ID-like value.
    final candidates = RegExp(
      r'\b[A-Za-z0-9][A-Za-z0-9/-]{5,19}\b',
    ).allMatches(text);
    for (final match in candidates) {
      final candidate = match.group(0)!;
      if (RegExp(r'\d').hasMatch(candidate)) return candidate;
    }
    return null;
  }

  void _onDetect(BarcodeCapture capture) {
    if (_processing || !mounted) return;

    String? raw;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        raw = value;
        break;
      }
    }
    if (raw == null) {
      setState(
        () =>
            _status =
                'Barcode detected, but it returned no readable text. Try again with better focus.',
      );
      return;
    }

    // Print the exact data decoded from the ID QR/barcode in VS Code terminal.
    debugPrint('QR RAW DATA: $raw');
    final registerNumber = _extractRegisterNumber(raw);

    if (registerNumber != null) {
      _processing = true;
      unawaited(_controller.stop());
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => ResultPage(registerNumber: registerNumber, rawData: raw!),
        ),
      );
      return;
    }

    // Keep the scanner running if data was read but no register number was recognized.
    setState(() {
      _lastRawValue = raw;
      _status =
          'Barcode was read, but the register number pattern was not recognized. Keep scanning or check the raw data below.';
    });
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      if (mounted) setState(() => _torchOn = !_torchOn);
    } catch (e) {
      if (mounted) setState(() => _status = 'Flashlight error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            onDetectError: (error, stackTrace) {
              debugPrint('SCANNER ERROR: $error');
              if (mounted) setState(() => _status = 'Scanner error: $error');
            },
            errorBuilder:
                (context, error) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Camera error: ${error.errorCode}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Scan ID card',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const Spacer(),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.82,
                  height: 230,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                if (_lastRawValue != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      'RAW DATA: $_lastRawValue',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      onPressed: _toggleTorch,
                      icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
                      tooltip: 'Toggle flashlight',
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _lastRawValue = null;
                          _status =
                              'Point the camera at the QR code on your ID card.';
                        });
                        unawaited(
                          _controller.stop().then((_) => _controller.start()),
                        );
                      },
                      child: const Text(
                        'Try again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.registerNumber,
    required this.rawData,
  });

  final String registerNumber;
  final String rawData;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<Student?> _studentFuture;

  @override
  void initState() {
    super.initState();
    _studentFuture = StudentStorage.instance.findStudent(widget.registerNumber);
  }

  Future<void> _addStudent() async {
    final Student? savedStudent = await Navigator.of(context).push<Student>(
      MaterialPageRoute(
        builder: (_) => StudentFormPage(registerNumber: widget.registerNumber),
      ),
    );
    if (savedStudent != null && mounted) {
      setState(() => _studentFuture = Future<Student?>.value(savedStudent));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student saved successfully.')),
      );
    }
  }

  Future<void> _editStudent(Student student) async {
    final Student? savedStudent = await Navigator.of(context).push<Student>(
      MaterialPageRoute(
        builder:
            (_) => StudentFormPage(
              registerNumber: student.registerNumber,
              existingStudent: student,
            ),
      ),
    );
    if (savedStudent != null && mounted) {
      setState(() => _studentFuture = Future<Student?>.value(savedStudent));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student details updated successfully.')),
      );
    }
  }

  void _scanAgain() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const ScannerPage()));
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Student?>(
      future: _studentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Scan result'), centerTitle: true),
            body: _LookupMessage(
              icon: Icons.storage_rounded,
              title: 'Student records unavailable',
              message:
                  'The local student database could not be read. Your scan is safe; try again.',
              actionLabel: 'Retry',
              onAction: () {
                setState(() {
                  _studentFuture = StudentStorage.instance.findStudent(
                    widget.registerNumber,
                  );
                });
              },
              onHome: _goHome,
            ),
          );
        }

        final Student? student = snapshot.data;
        if (student != null) {
          return StudentProfilePage(
            student: student,
            rawData: widget.rawData,
            onEdit: () => _editStudent(student),
            onScanAgain: _scanAgain,
            onHome: _goHome,
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Scan result'), centerTitle: true),
          body: _LookupMessage(
            icon: Icons.person_search_rounded,
            title: 'Student not registered',
            message: 'No saved student matches this register number.',
            registerNumber: widget.registerNumber,
            actionLabel: 'Add Student',
            onAction: _addStudent,
            onHome: _goHome,
            onScanAgain: _scanAgain,
            rawData: widget.rawData,
          ),
        );
      },
    );
  }
}

class _LookupMessage extends StatelessWidget {
  const _LookupMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onHome,
    this.registerNumber,
    this.onScanAgain,
    this.rawData,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback onHome;
  final String? registerNumber;
  final VoidCallback? onScanAgain;
  final String? rawData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 28),
              Icon(icon, size: 76, color: const Color(0xFF087E79)),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF61747A), fontSize: 16),
              ),
              if (registerNumber != null) ...[
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
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
                      const SizedBox(height: 10),
                      SelectableText(
                        registerNumber!,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (rawData != null)
                ExpansionTile(
                  title: const Text('Show raw QR data'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(rawData!),
                    ),
                  ],
                ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: onAction,
                icon: Icon(
                  actionLabel == 'Add Student'
                      ? Icons.person_add_alt_1_rounded
                      : Icons.refresh_rounded,
                ),
                label: Text(actionLabel),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
              ),
              if (onScanAgain != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onScanAgain,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Again'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onHome,
                icon: const Icon(Icons.home),
                label: const Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
