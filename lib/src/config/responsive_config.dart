import 'package:flutter/foundation.dart';

import 'package:responsive_flex_list/src/models/breakpoints.dart';

class ResponsiveConfig {
  static Breakpoints? _activeBreakpoints;
  static bool _initialized = false;

  /// Initialize configuration at app startup.
  static void init({required Breakpoints breakpoints}) {
    debugPrint('initialized with $breakpoints');
    _activeBreakpoints = breakpoints;
    _initialized = true;
  }

  /// Returns the active [Breakpoints].
  /// Throws a clear error if [init] was never called.
  static Breakpoints get breakpoints {
    if (!_initialized) {
      throw FlutterError.fromParts([
        ErrorSummary('ResponsiveConfig not initialized.'),
        ErrorDescription(
          'You must call `ResponsiveConfig.init(...)` in your main() '
          'before runApp()',
        ),
        ErrorHint(
          '\n\nExample:\n\n'
          'void main() {\n'
          '  WidgetsFlutterBinding.ensureInitialized();\n'
          '  ResponsiveConfig.init(breakpoints: Breakpoints.defaultBreakpoints);\n'
          '  runApp(MyApp());\n'
          '}\n\n.',
        ),
      ]);
    }
    return _activeBreakpoints!;
  }
}
