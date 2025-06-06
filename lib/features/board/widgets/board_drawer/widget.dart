import 'package:flutter/material.dart';
import 'board_drawer.dart';

class BoardDrawer extends StatelessWidget {
  const BoardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMenuList(),
            buildVersionInfo(),
          ],
        ),
      ),
    );
  }
}
