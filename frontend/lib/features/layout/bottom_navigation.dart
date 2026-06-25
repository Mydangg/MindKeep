import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/data/model/destination.dart';
import 'package:frontend/features/layout/layout_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    required this.widget,
    required this.destination,
    super.key,
  });

  final LayoutScaffold widget;
  final List<Destination> destination;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 80,
      color: AppColors.primary500,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.jost().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primary800,
              );
            }
            return GoogleFonts.jost().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.greyscale500,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary800, size: 28);
            }

            return const IconThemeData(color: AppColors.greyscale500);
          }),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          selectedIndex: widget.navigationShell.currentIndex,
          indicatorColor: Colors.transparent,
          onDestinationSelected: widget.navigationShell.goBranch,
          destinations:
              destination.map((e) {
                return NavigationDestination(
                  icon: Icon(e.icon),
                  selectedIcon: Icon(e.icon),
                  label: e.labelKey,
                );
              }).toList(),
        ),
      ),
    );
  }
}
