part of '../core_ops.dart';

const kCssAlignItems = 'align-items';
const kCssAlignItemsFlexStart = 'flex-start';
const kCssAlignItemsFlexEnd = 'flex-end';
const kCssAlignItemsCenter = 'center';
const kCssAlignItemsBaseline = 'baseline';
const kCssAlignItemsStretch = 'stretch';

const kCssFlexDirection = 'flex-direction';
const kCssFlexDirectionColumn = 'column';
const kCssFlexDirectionRow = 'row';

const kCssGap = 'gap';

const kCssJustifyContent = 'justify-content';
const kCssJustifyContentFlexStart = 'flex-start';
const kCssJustifyContentFlexEnd = 'flex-end';
const kCssJustifyContentCenter = 'center';
const kCssJustifyContentSpaceBetween = 'space-between';
const kCssJustifyContentSpaceAround = 'space-around';
const kCssJustifyContentSpaceEvenly = 'space-evenly';

class StyleDisplayFlex {
  final WidgetFactory wf;

  StyleDisplayFlex(this.wf);

  BuildOp get buildOp {
    return BuildOp(
      alwaysRenderBlock: true,
      onRenderedChildren: (tree, children) {
        if (children.isEmpty) {
          return null;
        }

        String alignItems = kCssAlignItemsFlexStart;
        String flexDirection = kCssFlexDirectionRow;
        CssLength? gap;
        String justifyContent = kCssJustifyContentFlexStart;

        for (final element in tree.element.styles) {
          final String? value = element.term;

          if (value != null) {
            switch (element.property) {
              case kCssAlignItems:
                alignItems = value;
              case kCssFlexDirection:
                flexDirection = value;
              case kCssGap:
                gap = tryParseCssLength(element.value);
              case kCssJustifyContent:
                justifyContent = value;
            }
          }
        }

        return WidgetPlaceholder(
          debugLabel: kCssDisplayFlex,
          builder: (context, _) {
            final resolved = tree.inheritanceResolvers.resolve(context);
            final unwrapped = children
                .map((child) => WidgetPlaceholder.unwrap(context, child))
                .where((child) => child != widget0)
                .toList(growable: false);
            return wf.buildFlex(
              tree,
              unwrapped,
              crossAxisAlignment: _toCrossAxisAlignment(alignItems),
              direction: flexDirection == kCssFlexDirectionRow
                  ? Axis.horizontal
                  : Axis.vertical,
              mainAxisAlignment: _toMainAxisAlignment(justifyContent),
              spacing: gap?.getValue(resolved) ?? 0.0,
              textDirection: resolved.directionOrLtr,
            );
          },
        );
      },
      priority: Priority.displayFlex,
    );
  }

  /// Converts CSS [justifyContent] to Flutter Grid MainAxisAlignment
  static MainAxisAlignment _toMainAxisAlignment(String justifyContent) {
    switch (justifyContent) {
      case kCssJustifyContentFlexStart:
        return MainAxisAlignment.start;
      case kCssJustifyContentFlexEnd:
        return MainAxisAlignment.end;
      case kCssJustifyContentCenter:
        return MainAxisAlignment.center;
      case kCssJustifyContentSpaceBetween:
        return MainAxisAlignment.spaceBetween;
      case kCssJustifyContentSpaceAround:
        return MainAxisAlignment.spaceAround;
      case kCssJustifyContentSpaceEvenly:
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  /// Converts CSS [alignItems] to Flutter Grid CrossAxisAlignment
  static CrossAxisAlignment _toCrossAxisAlignment(String alignItems) {
    switch (alignItems) {
      case kCssAlignItemsFlexStart:
        return CrossAxisAlignment.start;
      case kCssAlignItemsFlexEnd:
        return CrossAxisAlignment.end;
      case kCssAlignItemsCenter:
        return CrossAxisAlignment.center;
      case kCssAlignItemsBaseline:
        return CrossAxisAlignment.baseline;
      case kCssAlignItemsStretch:
        return CrossAxisAlignment.stretch;
      default:
        return CrossAxisAlignment.start;
    }
  }
}
