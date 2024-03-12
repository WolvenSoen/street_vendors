import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:street_vendors/src/bindings/bindings.dart';
import 'package:street_vendors/src/data/repositories/authentication/authentication_repository.dart';
import 'package:street_vendors/src/routing/routes.dart';
import 'package:street_vendors/src/utils/api/firebase_api.dart';
import 'package:street_vendors/src/utils/constants/colors.dart';
import 'package:street_vendors/src/utils/theme/theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  // INIT WIDGETS BINDING
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding
      .ensureInitialized();

  // GET LOCAL STORAGE
  await GetStorage.init();

  // AWAIT NATIVE SPLASH
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // INIT FIREBASE
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // INIT FIREBASE MESSAGING
  await FirebaseAPI().init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STREETER',
      themeMode: ThemeMode.system,
      theme: WolvenTheme.lightTheme,
      darkTheme: WolvenTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          )
        ),
      ),
      routes: Routes.routes,
    );
  }
}
