import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class SettingProvider extends StatelessWidget {
  final String settingTitle;
  final Widget? loadingWidget;
  final Function(Setting setting) builder;

  const SettingProvider({
    required this.settingTitle,
    required this.builder,
    this.loadingWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, List<Setting>?>(
      builder: (context, settings) {
        if (settings == null) {
          return loadingWidget ?? Container();
        }

        final setting = settings.findByTitle(settingTitle);

        if (setting == null) {
          // Simple case-insensitive search for similar settings
          final similarSettings = settings
              .where((s) => s.title.toLowerCase().contains(settingTitle.toLowerCase()) ||
                  settingTitle.toLowerCase().contains(s.title.toLowerCase()))
              .take(3)
              .map((s) => s.title)
              .toList();

          var errorMessage = 'Setting "$settingTitle" not found.';

          if (similarSettings.isNotEmpty) {
            errorMessage += '\nSimilar settings: ${similarSettings.join(", ")}';
          } else {
            errorMessage += '\nAvailable settings: ${settings.map((s) => s.title).take(5).join(", ")}...';
          }

          throw Exception(errorMessage);
        }

        return builder(setting);
      },
    );
  }
}
