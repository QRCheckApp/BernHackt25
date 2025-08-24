import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  // Backend API is ready to use
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
