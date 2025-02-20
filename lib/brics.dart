import 'package:flutter/material.dart';

/// Enum for breakpoints.
enum BricWidth {
  xs, // 0 → 575
  sm, // 576 → 767
  md, // 768 → 991
  lg, // 992 → 1199
  xl, // 1200 → 1399
  xxl, // > 1400
}

/// Configuration for breakpoints.
class BricsBreakpointsConfig {
  final int xs, sm, md, lg, xl;
  const BricsBreakpointsConfig({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });
}

/// Default breakpoints configuration.
/// You can override it by passing in the [BricsConfig].
const defaultBricsBreakpoints = BricsBreakpointsConfig(
  xs: 576,
  sm: 768,
  md: 992,
  lg: 1200,
  xl: 1400,
);

/// Global configuration for Brics.
/// If local values are provided in [Brics], they override these defaults.
class BricsConfig extends InheritedWidget {
  final BricsBreakpointsConfig breakpoints;
  final int totalColumns;

  const BricsConfig({
    super.key,
    Widget? child,
    this.totalColumns = 12,
    this.breakpoints = defaultBricsBreakpoints,
  }) : super(child: child ?? const SizedBox.shrink());

  static BricsConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BricsConfig>() ??
        const BricsConfig();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

/// Brics container with optional width control.
class Brics extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final double crossGap;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  const Brics({
    super.key,
    required this.children,
    this.gap = 0,
    this.crossGap = 0,
    this.maxWidth,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bricsConstraints = maxWidth == null
            ? null
            : BoxConstraints(
                maxWidth: constraints.maxWidth < maxWidth!
                    ? constraints.maxWidth
                    : maxWidth!);
        return Align(
          alignment: alignment,
          child: Container(
            padding: padding!,
            constraints: bricsConstraints,
            child: Wrap(
              spacing: gap,
              runSpacing: crossGap,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

/// [BricBuilder] is a function type that provides the computed width to its builder.
typedef BricBuilder = Widget Function(BuildContext context, double width);

/// [Bric] calculates its width based on the specified column settings and breakpoints.
class Bric extends StatelessWidget {
  final Map<BricWidth, int> size;
  final Widget? child;
  final BricBuilder? builder;

  const Bric({
    super.key,
    this.child,
    this.builder,
    this.size = const {},
  }) : assert(child != null || builder != null,
            'Either child or builder must be provided.');

  /// Determines column count based on screen width.
  int _getColumnCount(
      double width, int totalColumns, BricsBreakpointsConfig breakpoints) {

    final breakpointValues = {
      BricWidth.xs: breakpoints.xs,
      BricWidth.sm: breakpoints.sm,
      BricWidth.md: breakpoints.md,
      BricWidth.lg: breakpoints.lg,
      BricWidth.xl: breakpoints.xl,
      BricWidth.xxl: double.infinity,
    };

    int columnCount = totalColumns;
    for (final breakpoint in BricWidth.values) {
      if (size.containsKey(breakpoint)) {
        columnCount = size[breakpoint]!;
      }
      if (width < breakpointValues[breakpoint]!) {
        return columnCount;
      }
    }
    return columnCount;
  }

  @override
  Widget build(BuildContext context) {
    final config = BricsConfig.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final columnCount =
        _getColumnCount(width, config.totalColumns, config.breakpoints);
    final brics = context.findAncestorWidgetOfExactType<Brics>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = brics?.gap ?? 0;
        final totalColumns = config.totalColumns;
        final columnWidth =
            (constraints.maxWidth - gap * (totalColumns - 1)) / totalColumns;
        final bricWidth = columnCount * columnWidth + (columnCount - 1) * gap;

        return SizedBox(
          width: bricWidth,
          // return builder or child
          child: builder != null ? builder!(context, bricWidth) : child,
        );
      },
    );
  }
}
