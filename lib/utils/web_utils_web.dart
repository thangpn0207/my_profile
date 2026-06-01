// web_utils_web.dart
import 'dart:js_interop';

@JS('removeLoader')
external void _removeLoader();

void removeNativeLoader() {
  try {
    _removeLoader();
  } catch (e) {
    // Ignore if function not found
  }
}
