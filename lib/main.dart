import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_book/Menu/MyTags/wigdets/fetch_tagicons.dart';
import 'package:tag_book/common/widgets/loader_provider.dart';
import 'package:tag_book/postTags/Provider/provider_tagbook.dart';
import 'package:tag_book/root/user_tag_page.dart';
import 'Menu/MyTags/wigdets/fetch_tags.dart';
import 'Menu/MyTags/wigdets/provider_icos.dart';
import 'auth/func/firebase_options/firebase_options.dart';
import 'auth/func/validate_authdata/validate_authdata.dart';
import 'common/styles/styles.dart';
import 'root/intro_page.dart';
import 'auth/screen/login/log_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const MyApp(),
  );
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _tokenFuture;
  bool _internetConnection = true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
     tags.isEmpty?_loadTags():null;
     iconList.isEmpty?_loadIcons():null;
     posts.isEmpty?_loadPosts():null;
     getConnection();
    });
    _tokenFuture = getSavedToken();
    print(posts.length);
  }

  getConnection() async{
    _internetConnection = await InternetConnectionCheckerPlus().hasConnection;
  }
  Future<String> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? '';
  }
  Future<void> _loadTags() async {
    try {
     await getStoredTags();
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<void> _loadIcons() async {
    try {
      await getStoredIcons();
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<void> _loadPosts() async {
    try {
      await getStoredPosts();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    Color statusBarColor = Colors.transparent;
    final Brightness statusBarIconBrightness = isDarkMode ? Brightness.light : Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return FutureBuilder<String>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting //build shimmer here
        } else if (snapshot.hasError) {
          return Center(child: Text('Error retrieving token: ${snapshot.error}')); // Handle errors if any
        } else {
          final String token = snapshot.data ?? '';
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => UserValidator(),),
              ChangeNotifierProvider(create: (context) => ShowLoader(false),),
              ChangeNotifierProvider(create: (context)=>TagBookProvider(),),
              ChangeNotifierProvider(create: (context)=>TagBookProvider2(),),
              ChangeNotifierProvider(create: (context)=>MultiTapped(),),
              ChangeNotifierProvider(create: (BuildContext context) => IconProvider(),),
              ChangeNotifierProvider(create: (BuildContext context) => TagEditProvider(),),
            ],
            child: MaterialApp(
              title: 'MyTagBook',
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
                primaryColor: Colors.blue.shade100,
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.black,
                  selectionColor: Colors.blue.shade100,
                  selectionHandleColor: Colors.black,
                ),
                useMaterial3: true,
              ),
              home:  _internetConnection?token.isEmpty ?
              const LogIn() : tags.isEmpty?
              const IntroPage(): const UserTagPage():
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SvgPicture.asset('assets/images/noInternetConnection.svg',fit: BoxFit.contain,),
              ),
            ),
          );
        }
      },
    );
  }
}
