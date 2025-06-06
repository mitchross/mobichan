import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/core.dart';

import 'board_expansion_tile.dart';

class BoardExpansionTileWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget? child;
  final double? iconSize;
  final void Function()? onTap;

  const BoardExpansionTileWidget({
    required this.title,
    required this.icon,
    this.child,
    this.iconSize = 30,
    this.onTap,
    super.key,
  });

  @override
  State<BoardExpansionTileWidget> createState() =>
      _BoardExpansionTileWidgetState();
}

class _BoardExpansionTileWidgetState extends State<BoardExpansionTileWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ConfigurableExpansionTile(
      onExpansionChanged: (isExpanded) {
        setState(() {
          this.isExpanded = isExpanded;
        });
      },
      header: (bool isExpandedFromBuilder, Animation<double> animationIcon, Animation<double> animationBody, ConfigurableExpansionTileController tileController) {
        // Signature changed to match the error message. Context is no longer a direct parameter here.
        // Methods like widget.buildBackButton(context) will use the 'context' from the outer State's build method.
        // The actual signature from configurable_expansion_tile_null_safety ^3.3.2 for `header` builder might be simpler.
        // Let's assume a simpler one for now if the other one causes issues, or stick to the error if it's precise.
        // For now, using a signature that includes context as it's often available in builders.
        // If the package truly uses the one from the error (without context directly in builder args),
        // then `widget.buildBackButton(context)` etc. would rely on the outer `context`.
        // The key is that `Expanded` is *returned by* this builder.

        // Reconstructing the header content to use `isExpandedFromBuilder`
        return Expanded(
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) { // This inner builder provides a new context
                  return Row(
                    children: [
                      if (state is Searching && widget.onTap == null)
                        widget.buildBackButton(context)
                      else
                        widget.buildIcon(),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: state is Searching && widget.onTap == null
                            ? widget.buildSearchField(context)
                            : widget.buildTitle(context),
                      ),
                      // Use the isExpandedFromBuilder from the header's builder
                      if (isExpandedFromBuilder) widget.buildSearchIcon(context),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
      // headerExpanded parameter removed.
      // childrenBody parameter removed.
      child: widget.child, // Added 'child' parameter
    );
  }
}
