import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../theme/app_theme.dart';
import 'workout_screen.dart';
import 'timer_screen.dart';
import 'nutrition_screen.dart';
import 'progress_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WorkoutScreen(),
    TimerScreen(),
    NutritionScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xEB121214),
          border: const Border(
            top: BorderSide(color: Color(0x33FFFFFF), width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: _getItemColor(_currentIndex),
              unselectedItemColor: AppTheme.textSecondary,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.flame),
                  activeIcon: Icon(CupertinoIcons.flame_fill),
                  label: 'Antrenman',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(CupertinoIcons.timer),
                      if (provider.isRestTimerRunning)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.greenNeon,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  activeIcon: const Icon(CupertinoIcons.timer_fill),
                  label: 'Sayaç',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.drop),
                  activeIcon: Icon(CupertinoIcons.drop_fill),
                  label: 'Beslenme',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.graph_circle),
                  activeIcon: Icon(CupertinoIcons.graph_circle_fill),
                  label: 'Gelişim',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getItemColor(int index) {
    switch (index) {
      case 0:
        return AppTheme.redPulse;
      case 1:
        return AppTheme.greenNeon;
      case 2:
        return AppTheme.blueCyan;
      case 3:
        return AppTheme.purpleNeon;
      default:
        return AppTheme.redPulse;
    }
  }
}
