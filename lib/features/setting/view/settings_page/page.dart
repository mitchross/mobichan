import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan/core/widgets/responsive_width.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kSettings.tr()),
      ),
      body: BlocBuilder<SettingsCubit, List<Setting>?>(
        builder: (context, settings) {
          if (settings != null) {
            final Map<SettingGroup, List<Setting>> groupedSettings = {};
            for (var setting in settings) {
              (groupedSettings[setting.group] ??= []).add(setting);
            }

            final sortedGroups = groupedSettings.keys.toList()
              ..sort((a, b) => a.compareTo(b));

            final List<dynamic> displayList = [];
            for (var group in sortedGroups) {
              displayList.add(group);
              displayList.addAll(groupedSettings[group]!);
            }

            return ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];
                if (item is SettingGroup) {
                  return buildGroupSeparator(item);
                } else if (item is Setting) {
                  return ResponsiveWidth(child: buildListTile(item));
                }
                return Container();
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
