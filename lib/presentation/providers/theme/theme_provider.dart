

import 'package:flutter_riverpod/flutter_riverpod.dart';


final themeProvider = StateProvider<bool>((ref){
  bool appBrightnessTheme = false;
  return appBrightnessTheme;
});