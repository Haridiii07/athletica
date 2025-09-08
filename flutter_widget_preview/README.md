# Flutter Widget Preview

This project provides a collection of Flutter widgets with real-time previews using the Flutter Preview extension. It allows developers to visualize their widgets across different device frames and configurations.

## Getting Started

### Installation

1. Install the Flutter Preview extension for your IDE.
2. Add the preview package to your Flutter project by including it in your `pubspec.yaml` file.

### Running the Preview

- Open any Dart file in your project, and a preview button will appear.
- Click the button to launch the Flutter Preview.

### Adding a Preview

To create a new preview:

1. Use the provided VS Code snippet by typing `preview`.
2. Create a new class that extends `PreviewProvider`.

Example:

```dart
class MyPreview extends PreviewProvider {
  List<Preview> get previews {
    return [
      Preview(
        frame: Frames.ipadPro12,
        child: MyApp(),
      ),
      Preview(
        frame: Frames.iphoneX,
        child: MyApp(),
      ),
    ];
  }
}
```

### Custom Providers

You can create custom preview providers by extending any widget that implements the `Previewer` mixin. For example:

```dart
class MyCustomPreview extends StatelessWidget with Previewer {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Resizable Preview

The `ResizablePreviewProvider` allows you to resize widgets to see how they look in different scenarios. 

Example:

```dart
class Resizable extends ResizablePreviewProvider with Previewer {
  @override
  Preview get preview {
    return Preview(
      mode: UpdateMode.hotReload,
      child: MusicCard(
        title: 'Blond',
        singer: 'Frank Ocean',
        image: PreviewImage.asset('preview_assets/cover1.jpg'),
        onTap: () => {},
      ),
    );
  }
}
```

### Device Preview

You can also use the `DevicePreview` package to see how your app looks on various devices.

Example:

```dart
class DevicePreviewProvider extends StatelessWidget with Previewer {
  @override
  String get title => 'Device Preview';

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) => MyApp(),
    );
  }
}
```

## Contributing

If you encounter any issues or have suggestions for improvements, please create a new issue in the project's repository. Your contributions are welcome!