// File generated manually: firebase_options.dart
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // 🔹 Configuración para Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDZYZ74T6sks2R1brduDhr4ChlQfNNYEGc',
    authDomain: 'adv-formacion-apppp.firebaseapp.com',
    projectId: 'adv-formacion-apppp',
    storageBucket: 'adv-formacion-apppp.appspot.com',
    messagingSenderId: '530951938601',
    appId: '1:530951938601:web:0cc998c25e893abe9a3238',
  );

  // 🔹 Configuración para Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZYZ74T6sks2R1brduDhr4ChlQfNNYEGc',
    projectId: 'adv-formacion-apppp',
    storageBucket: 'adv-formacion-apppp.appspot.com',
    messagingSenderId: '530951938601',
    appId: '1:530951938601:android:0cc998c25e893abe9a3238',
  );

  // 🔹 Configuración para iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZYZ74T6sks2R1brduDhr4ChlQfNNYEGc',
    projectId: 'adv-formacion-apppp',
    storageBucket: 'adv-formacion-apppp.appspot.com',
    messagingSenderId: '530951938601',
    appId: '1:530951938601:ios:0cc998c25e893abe9a3238',
    iosBundleId: 'com.example.zxc',
  );

  // 🔹 Configuración para macOS
  static const FirebaseOptions macos = ios;

  // 🔹 Configuración para Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDZYZ74T6sks2R1brduDhr4ChlQfNNYEGc',
    authDomain: 'adv-formacion-apppp.firebaseapp.com',
    projectId: 'adv-formacion-apppp',
    storageBucket: 'adv-formacion-apppp.appspot.com',
    messagingSenderId: '530951938601',
    appId: '1:530951938601:windows:0cc998c25e893abe9a3238',
  );
}
