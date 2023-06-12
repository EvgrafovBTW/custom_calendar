import 'package:custom_calendar/logic/blocs/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:custom_calendar/screens/components/app_close_dialog.dart';
import 'package:custom_calendar/screens/pages/calendar_page.dart';
import 'package:custom_calendar/screens/pages/feed_page.dart';
import 'package:custom_calendar/screens/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  /// массив со страницами из боттом бара
  static List<Widget> pages = [
    const CalendarPage(),
    const FeedPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    BottomNavigationBloc bottomNavigationBloc =
        BlocProvider.of<BottomNavigationBloc>(context);

    /// метод изменения страницы по нажатию на боттом бар
    onPageTapped(int index) {
      bottomNavigationBloc.add(BottomNavTap(index));
    }

    /// Билдер, который изменяет страницу на экране
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        /// Виджет, который позволяет отловить системный жест "назад"
        return WillPopScope(
          onWillPop: () async {
            if (bottomNavigationBloc.state.pageIndex == 0) {
              showDialog(
                context: context,
                builder: (context) => const AppCloseDialog(),
              );
            } else {
              onPageTapped(0);
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SizedBox.expand(
              /// IndexedStack - хранилище страниц и их стейтов,
              /// которые можно получить по индексу
              child: IndexedStack(
                index: state.pageIndex,
                children: pages,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              currentIndex: state.pageIndex,
              onTap: onPageTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_month,
                  ),
                  label: 'Календарь',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu_book,
                  ),
                  label: 'Лента',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_2_outlined,
                  ),
                  label: 'Профиль',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
