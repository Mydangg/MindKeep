import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/data/model/destination.dart';
import 'package:frontend/features/layout/bottom_navigation.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatefulWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold> {
  final List<Destination> destinations = [
    Destination(id: 'home', icon: Icons.home, labelKey: 'Trang chủ'),
    Destination(id: 'news', icon: Icons.article_outlined, labelKey: 'Tin tức'),
    Destination(id: 'chat', icon: Icons.chat, labelKey: 'chat'),
    Destination(id: 'profile', icon: Icons.person_outline, labelKey: 'Cá nhân'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(PageRoutes.addArticle);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.primary700,
        elevation: 1,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          weight: 700,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigation(
        widget: widget,
        destination: destinations,
      ),
    );
  }
}
