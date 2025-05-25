/// From https://ktuusj.medium.com/flutter-custom-selection-toolbar-3acbe7937dd3
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobichan/localization.dart';

typedef OffsetValue = void Function(int start, int end);

class PostTextSelectionControls extends MaterialTextSelectionControls {
  // Padding between the toolbar and the anchor.
  static const double _kToolbarContentDistanceBelow = 20.0;
  static const double _kToolbarContentDistance = 8.0;
  PostTextSelectionControls({required this.customButton});

  /// Custom
  final OffsetValue customButton;

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus, // Updated signature
    Offset? lastSecondaryTapDownPosition,
  ) {
    // Calculate anchor points (simplified for modern TextSelectionToolbar)
    final Offset anchor = selectionMidpoint;

    // Prepare the custom button logic
    final VoidCallback customButtonLogic = () {
      customButton(delegate.textEditingValue.selection.start,
          delegate.textEditingValue.selection.end);
      // Deselect text after action
      delegate.userUpdateTextEditingValue(
          delegate.textEditingValue.copyWith(
            selection: TextSelection.collapsed(
                offset: delegate.textEditingValue.selection.baseOffset),
          ),
          SelectionChangedCause.toolbar);
      delegate.hideToolbar();
    };

    // Get adaptive buttons and add custom button
    List<Widget> adaptiveButtons = TextSelectionToolbar.getAdaptiveButtons(
      context,
      delegate,
    ).toList(); // Convert to list to allow modification

    // Insert custom button, for example, at the beginning
    // Or, find a specific button (like copy) and insert before/after it
    // For simplicity, adding it at a fixed position or based on availability
    int insertPosition = 0; // Default to beginning
    // Example: insert after "Copy" if "Copy" exists
    final int copyButtonIndex = adaptiveButtons.indexWhere((button) {
      if (button is TextSelectionToolbarButton) {
        // This check is a bit fragile as it depends on the child Text widget's data.
        // A more robust way would be to check button type if Flutter exposes it,
        // or by key if TextSelectionToolbar.getAdaptiveButtons assigned them.
        // For this migration, we'll assume it's identifiable or just add at a fixed position.
        final child = button.child;
        if (child is Text) {
          // Accessing MaterialLocalizations requires a BuildContext that has it.
          // The buildToolbar method's context can be used.
          final localizations = MaterialLocalizations.of(context);
          return child.data == localizations.copyButtonLabel;
        }
      }
      return false;
    });

    if (copyButtonIndex != -1) {
      insertPosition = copyButtonIndex + 1;
    }
    
    // Only add custom button if there's a valid selection for quoting
    if (delegate.textEditingValue.selection.isValid) {
        adaptiveButtons.insert(
        insertPosition,
        TextSelectionToolbarButton(
          onPressed: customButtonLogic,
          child: Text(kQuote.tr()),
        ),
      );
    }


    // The TextSelectionToolbar now manages its own position based on anchors.
    // We provide selectionMidpoint as both anchorAbove and anchorBelow for simplicity,
    // or use more precise anchors if needed (like the original code did).
    // For modern Flutter, often just providing `selectionMidpoint` is enough as `anchor`.
    // The original calculation for anchorAbove and anchorBelow can be used if desired.
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset finalAnchorAbove = Offset(
        globalEditableRegion.left + selectionMidpoint.dx,
        globalEditableRegion.top +
            startTextSelectionPoint.point.dy -
            textLineHeight -
            _kToolbarContentDistance);
    final Offset finalAnchorBelow = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          _kToolbarContentDistanceBelow,
    );

    return TextSelectionToolbar(
      anchorAbove: finalAnchorAbove,
      anchorBelow: finalAnchorBelow,
      children: adaptiveButtons,
    );
  }
}

// MyTextSelectionToolbar, MyTextSelectionToolbarState, and _TextSelectionToolbarItemData are no longer needed.
