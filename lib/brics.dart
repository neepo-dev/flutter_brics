import 'package:flutter/material.dart';

enum BricWidth { xs, sm, md, lg, xl, xxl }

// upper breakpoints
const defaultBricsBreakpoints = BricsBreakpointsConfig(
  xs: 576,
  sm: 768,
  md: 992,
  lg: 1200,
  xl: 1400,
);

class BricsBreakpointsConfig {
  final int xs;
  final int sm;
  final int md;
  final int lg;
  final int xl;
  const BricsBreakpointsConfig({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });
}

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

// bric builder: send width to builder arguments
typedef BricBuilder = Widget Function(BuildContext context, double width);

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

  int _getColumnCount(
      double width, int totalColumns, BricsBreakpointsConfig breakpoints) {
    if (width < breakpoints.xs) {
      return size[BricWidth.xs] ?? totalColumns;
    }
    if (width < breakpoints.sm) {
      return size[BricWidth.sm] ?? size[BricWidth.xs] ?? totalColumns;
    }
    if (width < breakpoints.md) {
      return size[BricWidth.md] ??
          size[BricWidth.sm] ??
          size[BricWidth.xs] ??
          totalColumns;
    }
    if (width < breakpoints.lg) {
      return size[BricWidth.lg] ??
          size[BricWidth.md] ??
          size[BricWidth.sm] ??
          size[BricWidth.xs] ??
          totalColumns;
    }
    if (width < breakpoints.xl) {
      return size[BricWidth.xl] ??
          size[BricWidth.lg] ??
          size[BricWidth.md] ??
          size[BricWidth.sm] ??
          size[BricWidth.xs] ??
          totalColumns;
    }
    return size[BricWidth.xxl] ??
        size[BricWidth.xl] ??
        size[BricWidth.lg] ??
        size[BricWidth.md] ??
        size[BricWidth.sm] ??
        size[BricWidth.xs] ??
        totalColumns;
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
