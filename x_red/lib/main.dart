import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'app/routes/app_pages.dart';
import 'data/reposetory/firebase_database.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ar_MA");
  await  Database.databaseInitialise();
  Responsive.setGlobalBreakPoints(0, 768.0, 992.0, 1232.0);
  runApp(
    GetMaterialApp(
      fallbackLocale: const Locale("ar"),
      scrollBehavior: MouseGest(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
          fontFamily: GoogleFonts.cairo(fontSize: 18).fontFamily,
          useMaterial3: true),
      supportedLocales: const [Locale('ar')],
      locale: const Locale("ar"),
      debugShowCheckedModeBanner: true,
      title: "خضر وفواكه الرضوان",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

class MouseGest extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.cd 
      };
}
//**flutter build web --release --no-tree-shake-icons --web-renderer html
//flutter run -d chrome --web-browser-flag --disable-web-security
//gsutil cors set cors.json gs://fouzi-87672.appspot.com
//
// */     
