import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

/// Platform-aware alert dialog
class PlatformAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<PlatformAlertAction> actions;

  const PlatformAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions
            .map((action) => CupertinoDialogAction(
                  onPressed: action.onPressed ?? () {},
                  child: Text(action.text),
                  isDefaultAction: action.isDefault,
                  isDestructiveAction: action.isDestructive,
                ))
            .toList(),
      );
    } else {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions
            .map((action) => TextButton(
                  onPressed: action.onPressed,
                  child: Text(action.text),
                ))
            .toList(),
      );
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<PlatformAlertAction> actions,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: title,
          content: content,
          actions: actions,
        ),
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: title,
          content: content,
          actions: actions,
        ),
      );
    }
  }
}

class PlatformAlertAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDefault;
  final bool isDestructive;

  PlatformAlertAction({
    required this.text,
    this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });
}

/// Platform-aware action sheet
class PlatformActionSheet extends StatelessWidget {
  final String? title;
  final String? message;
  final List<PlatformActionSheetAction> actions;
  final PlatformActionSheetAction? cancelAction;

  const PlatformActionSheet({
    super.key,
    this.title,
    this.message,
    required this.actions,
    this.cancelAction,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActionSheet(
        title: title != null ? Text(title!) : null,
        message: message != null ? Text(message!) : null,
        actions: actions
            .map((action) => CupertinoActionSheetAction(
                  onPressed: action.onPressed ?? () {},
                  child: Text(action.text),
                  isDefaultAction: action.isDefault,
                  isDestructiveAction: action.isDestructive,
                ))
            .toList(),
        cancelButton: cancelAction != null
            ? CupertinoActionSheetAction(
                onPressed: cancelAction!.onPressed ?? () {},
                child: Text(cancelAction!.text),
              )
            : null,
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) Text(title!),
            if (message != null) Text(message!),
            ...actions
                .map((action) => ListTile(
                      title: Text(action.text),
                      onTap: action.onPressed,
                    ))
                .toList(),
            if (cancelAction != null)
              ListTile(
                title: Text(cancelAction!.text),
                onTap: cancelAction!.onPressed,
              ),
          ],
        ),
      );
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<PlatformActionSheetAction> actions,
    PlatformActionSheetAction? cancelAction,
  }) {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: (context) => PlatformActionSheet(
          title: title,
          message: message,
          actions: actions,
          cancelAction: cancelAction,
        ),
      );
    } else {
      return showModalBottomSheet<T>(
        context: context,
        builder: (context) => PlatformActionSheet(
          title: title,
          message: message,
          actions: actions,
          cancelAction: cancelAction,
        ),
      );
    }
  }
}

class PlatformActionSheetAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDefault;
  final bool isDestructive;

  PlatformActionSheetAction({
    required this.text,
    this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });
}

/// Platform-aware switch
class PlatformSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const PlatformSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    }
  }
}

/// Platform-aware slider
class PlatformSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final Color? activeColor;

  const PlatformSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSlider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    } else {
      return Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    }
  }
}

/// Platform-aware checkbox
class PlatformCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;

  const PlatformCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoCheckbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    } else {
      return Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    }
  }
}

/// Platform-aware radio button
class PlatformRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Color? activeColor;

  const PlatformRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    } else {
      return Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    }
  }
}

/// Platform-aware navigation bar
class PlatformNavigationBar extends StatelessWidget {
  final List<PlatformNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const PlatformNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabBar(
        items: items
            .map((item) => BottomNavigationBarItem(
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  label: item.label,
                ))
            .toList(),
        currentIndex: currentIndex,
        onTap: onTap,
      );
    } else {
      return BottomNavigationBar(
        items: items
            .map((item) => BottomNavigationBarItem(
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  label: item.label,
                ))
            .toList(),
        currentIndex: currentIndex,
        onTap: onTap,
      );
    }
  }
}

class PlatformNavigationBarItem {
  final Widget icon;
  final Widget? activeIcon;
  final String label;

  PlatformNavigationBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Platform-aware app bar
class PlatformAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const PlatformAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title != null ? Text(title!) : null,
        trailing: actions != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    } else {
      return AppBar(
        title: title != null ? Text(title!) : null,
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Platform-aware button
class PlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const PlatformButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: color,
        padding: padding,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: padding,
        ),
        child: Text(text),
      );
    }
  }
}

/// Platform-aware text field
class PlatformTextField extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;

  const PlatformTextField({
    super.key,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTextField(
        placeholder: placeholder,
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
      );
    } else {
      return TextField(
        decoration: InputDecoration(
          hintText: placeholder,
        ),
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
      );
    }
  }
}

/// Platform-aware loading indicator
class PlatformLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  const PlatformLoadingIndicator({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        radius: size != null ? size! / 2 : 10,
        color: color,
      );
    } else {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.blue),
        ),
      );
    }
  }
}
