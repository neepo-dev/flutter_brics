# Brics

A flexible and lightweight Flutter library that provides an adaptive grid layout system inspired by Bootstrap.

![Flutter Brics Example App](https://github.com/neepo-dev/flutter_brics/blob/main/example/example_app.gif?raw=true)

## Features
- **Responsive Grid Layout:** Define widget widths with column gaps that change at various breakpoints.
- **Flexible Configuration:** Customize global settings such as breakpoints, total columns, and spacing via an inherited configuration widget.


## How to Use

**Simple usage:**
1. Use the `Brics` widget to place `Bric` widgets inside it
2. In `Bric`, add the required sizes using the `size` parameter

```dart
Brics(
  children: [
    
    Bric(
      size: {
        BricWidth.xs: 6,
        BricWidth.md: 2,
        BricWidth.lg: 3,
      },
      child: MyBricContent(),
    ),
    
    Bric(
      size: {
        BricWidth.md: 8,
        BricWidth.xxl: 12,
      },
      child: MyBricContent(),
    ),
  ],

),
```

### Brics Parameters

You can set the following parameters for `Brics` (default values are shown in comments):

```dart
Brics(
    maxWidth: 1200, // unset
    gap: 10, // unset
    crossGap: 8, // unset
    padding: EdgeInsets.all(20), // EdgeInsets.zero
    alignment: Alignment.centerLeft, // Alignment.topCenter
    width: 500, // unset
    
    children: ...
)
```

![Brics layout scheme](https://github.com/neepo-dev/flutter_brics/blob/main/example/example_scheme.png?raw=true)

## Breakpoints

![Brics breakpoints](https://github.com/neepo-dev/flutter_brics/blob/main/example/example_breakpoints.png?raw=true)

The following breakpoints are set by default:

```dart
const defaultBricsBreakpoints = BricsBreakpointsConfig(
    xs: 576,
    sm: 768,
    md: 992,
    lg: 1200,
    xl: 1400,
);
```

You can override these values in `BricsConfig`.

### Bric Width Calculation Logic

Essentially, `BricWidth` is a range between two breakpoints. For example, `BricWidth.sm` spans from 576px → to 767px. At this window width, the `Bric` will occupy the specified number of columns.

- By default, `Bric` takes 100% of the parent's width
- If no size is specified for a `Bric` at a certain range, its width will be equal to the next larger size specified

## Customizing Breakpoints and Column Count

You can set your own values for the **total number of columns** (default is 12) and override **breakpoints** (see image) using `BricsConfig`.

## BricsConfig: Global Brics Settings

To specify global `Brics` settings, wrap your root widget with the `BricsConfig` widget to put your settings in the context.
If these parameters are specified in the `Brics` widget, they will take priority over global settings.

Available global parameters: `breakpoints`, `totalColumns`, `gap`, `crossGap`, `maxWidth`.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BricsConfig(
      totalColumns: 24,
      breakpoints: BricsBreakpointsConfig(
          xs: 500,
          sm: 600,
          md: 700,
          lg: 800,
          xl: 900,
      ),
      gap: 20,
      crossGap: 10,
      maxWidth: 600,
      child: MaterialApp(
        home: HomeWidget(),
      ),
    );
  }
}
```

## Brics inside Dialog

If you place Brics inside widgets like Dialog, BottomSheet, Drawer, Tooltip, and others, you might see the error: **"LayoutBuilder does not support returning intrinsic dimensions."** This occurs because LayoutBuilder tries to calculate intrinsic dimensions, which is not allowed in the context of widgets that require exact dimensions before layout.

To solve this issue, you need to specify the `width` parameter in `Brics`, thereby setting a specific width for LayoutBuilder.
