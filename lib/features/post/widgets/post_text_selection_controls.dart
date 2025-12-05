/// From https://ktuusj.medium.com/flutter-custom-selection-toolbar-3acbe7937dd3
library;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    // Prepare the custom button logic
    customButtonLogic() {
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
    }

    // Create standard context menu button items
    final List<ContextMenuButtonItem> buttonItems = <ContextMenuButtonItem>[];
    final TextSelection selection = delegate.textEditingValue.selection;

    // Add standard buttons based on availability
    // Add standard buttons based on availability
    if (delegate.cutEnabled && !delegate.textEditingValue.selection.isCollapsed) {
      buttonItems.add(ContextMenuButtonItem(
        onPressed: () => delegate.cutSelection(SelectionChangedCause.toolbar),
        type: ContextMenuButtonType.cut,
      ));
    }

    if (delegate.copyEnabled && !delegate.textEditingValue.selection.isCollapsed) {
      buttonItems.add(ContextMenuButtonItem(
        onPressed: () => delegate.copySelection(SelectionChangedCause.toolbar),
        type: ContextMenuButtonType.copy,
      ));
    }

    if (delegate.pasteEnabled) {
      buttonItems.add(ContextMenuButtonItem(
        onPressed: () => delegate.pasteText(SelectionChangedCause.toolbar),
        type: ContextMenuButtonType.paste,
      ));
    }

    if (delegate.selectAllEnabled) {
      buttonItems.add(ContextMenuButtonItem(
        onPressed: () => delegate.selectAll(SelectionChangedCause.toolbar),
        type: ContextMenuButtonType.selectAll,
      ));
    }

    // Get the adaptive buttons for the current platform
    final List<Widget> adaptiveButtons = AdaptiveTextSelectionToolbar.getAdaptiveButtons(
      context,
      buttonItems,
    ).toList();

    // Add custom Quote button if there's a valid selection
    if (selection.isValid && !selection.isCollapsed) {
      // Create custom button using TextSelectionToolbarTextButton for consistency
      final Widget quoteButton = TextSelectionToolbarTextButton(
        padding: TextSelectionToolbarTextButton.getPadding(
          adaptiveButtons.length,
          adaptiveButtons.length + 1,
        ),
        onPressed: customButtonLogic,
        alignment: AlignmentDirectional.centerStart,
        child: Text(kQuote.tr()),
      );
      
      // Insert the custom button at the beginning
      adaptiveButtons.insert(0, quoteButton);
    }

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
