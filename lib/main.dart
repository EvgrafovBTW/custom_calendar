import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:custom_calendar/logic/blocs/app_loading/bloc/app_load_bloc.dart';
import 'package:custom_calendar/logic/blocs/app_settings/bloc/app_settings_bloc.dart';
import 'package:custom_calendar/logic/blocs/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Здесь устанваливается кастомный вид эксепшена на экране
  ErrorWidget.builder = (details) {
    return Material(
      child: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                details.exception.toString(),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  };
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppLoadBloc(),
        ),
        BlocProvider(
          create: (context) => AppSettingsBloc(),
        ),
        BlocProvider(
          create: (context) => BottomNavigationBloc(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLoadBloc appLoadBloc = BlocProvider.of<AppLoadBloc>(context);

    /// Метод, который отстреливает в момент загрузки приложения
    Future<void> loadAppData() async {
      /// старт загрузки
      appLoadBloc.add(AppLoadStart());

      /// конец загрузки
      appLoadBloc.add(AppLoadComplete());
    }

    /// Билдер, который обновляет приложение в рантайме по изменении настроек
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        /// OverlaySupport для различных всплывашек
        return OverlaySupport.global(
          /// автоматические виджеты в зависимости от ОС см. flutter_platfrom_widgets
          child: PlatformApp(
            debugShowCheckedModeBanner: false,
            material: (context, platform) => MaterialAppData(
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme.light(
                  primary: Color.fromRGBO(255, 120, 91, 1),
                  secondary: Color.fromRGBO(116, 105, 105, 1),
                  tertiary: Colors.amber,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.black,
                      displayColor: Colors.white,
                    ),
              ),
            ),
            cupertino: (context, platform) => CupertinoAppData(
              theme: const CupertinoThemeData(
                primaryColor: Color.fromRGBO(255, 120, 91, 1),
                primaryContrastingColor: Colors.white,
              ),
            ),

            /// Билдер который загружает данные приложения и показывает анимации на старте
            home: BlocBuilder<AppLoadBloc, AppLoadState>(
              builder: (context, state) {
                if (state is AppLoadInitial) {
                  loadAppData();
                }
                if (state is AppLoadInitial || state is AppLoading) {
                  return const AppLoadingScreen();
                }
                //! здесь вывод главного экрана после загрузки
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }
}

class AppLoadingScreen extends StatelessWidget {
  /// Виджет, показывающий анимации загрузки на старте приложения
  const AppLoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> loadingAnimations = [
      SpinKitSpinningLines(color: Theme.of(context).primaryColor),
      SpinKitCubeGrid(color: Theme.of(context).primaryColor),
      SpinKitFoldingCube(color: Theme.of(context).primaryColor),
      SpinKitWave(color: Theme.of(context).primaryColor),
    ];
    return Scaffold(
      body: Center(
        child:
            loadingAnimations[Random().nextInt(loadingAnimations.length - 1)],
      ),
    );
  }
}