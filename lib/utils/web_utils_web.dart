// web_utils_web.dart
import 'dart:js' as js;

void removeNativeLoader() {
  try {
    js.context.callMethod('removeLoader');
  } catch (e) {
    // Ignore if function not found
  }
}
