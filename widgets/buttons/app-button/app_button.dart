import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = const Size.fromHeight(48),
    this.padding,
    this.margin,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.enabled = true,
    this.expand = true,
    this.borderRadius = 14,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation,
    this.loaderColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Size size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? icon;
  final Widget? trailingIcon;
  final bool isLoading;
  final bool enabled;
  final bool expand;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? elevation;
  final Color? loaderColor;

  bool _isCupertinoPlatform(BuildContext context) {
    final platform = Theme.of(context).platform;

    return platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color defaultBg;
    final Color defaultFg;
    final Color defaultBorder;

    switch (variant) {
      case AppButtonVariant.primary:
        defaultBg = scheme.primary;
        defaultFg = scheme.onPrimary;
        defaultBorder = scheme.primary;

      case AppButtonVariant.secondary:
        defaultBg = scheme.secondary;
        defaultFg = scheme.onSecondary;
        defaultBorder = scheme.secondary;

      case AppButtonVariant.outline:
        defaultBg = Colors.transparent;
        defaultFg = scheme.onSurface;
        defaultBorder = scheme.outline;

      case AppButtonVariant.ghost:
        defaultBg = Colors.transparent;
        defaultFg = scheme.onSurface;
        defaultBorder = Colors.transparent;

      case AppButtonVariant.danger:
        defaultBg = scheme.error;
        defaultFg = scheme.onError;
        defaultBorder = scheme.error;
    }

    final bg = backgroundColor ?? defaultBg;
    final fg = foregroundColor ?? defaultFg;
    final brColor = borderColor ?? defaultBorder;

    final resolvedPadding =
        padding ??
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        );

    final content = _ButtonContent(
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      textStyle: textStyle ??
          TextStyle(
            color: fg,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
      loaderColor: loaderColor ?? fg,
    );

    final isCupertino =
        _isCupertinoPlatform(context);

    Widget child;

    if (isCupertino) {
      final button = CupertinoButton(
        padding: resolvedPadding,
        borderRadius:
            BorderRadius.circular(borderRadius),
        color:
            variant == AppButtonVariant.outline ||
                    variant == AppButtonVariant.ghost
                ? null
                : bg,
        onPressed:
            enabled && !isLoading
                ? onPressed
                : null,
        minimumSize: Size(
          size.height,
          size.height,
        ),
        child: content,
      );

      if (variant == AppButtonVariant.outline ||
          variant == AppButtonVariant.ghost ||
          borderColor != null) {
        child = DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius:
                BorderRadius.circular(borderRadius),
            border: Border.all(
              color: brColor,
            ),
          ),
          child: button,
        );
      } else {
        child = button;
      }

      child = SizedBox(
        width:
            expand ? double.infinity : null,
        child: child,
      );
    } else {
      child = SizedBox(
        width:
            expand ? double.infinity : null,
        child: ElevatedButton(
          onPressed:
              enabled && !isLoading
                  ? onPressed
                  : null,
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            backgroundColor: bg,
            foregroundColor: fg,
            disabledBackgroundColor:
                scheme.surfaceContainerHighest,
            disabledForegroundColor:
                scheme.onSurfaceVariant,
            minimumSize: size,
            padding: resolvedPadding,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                borderRadius,
              ),
              side: BorderSide(
                color: brColor,
              ),
            ),
          ),
          child: content,
        ),
      );
    }

    if (margin == null) {
      return child;
    }

    return Padding(
      padding: margin!,
      child: child,
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.trailingIcon,
    required this.isLoading,
    required this.textStyle,
    required this.loaderColor,
  });

  final String label;
  final Widget? icon;
  final Widget? trailingIcon;
  final bool isLoading;
  final TextStyle textStyle;
  final Color loaderColor;

  @override
  Widget build(BuildContext context) {
    final isCupertino =
        Theme.of(context).platform ==
                TargetPlatform.iOS ||
            Theme.of(context).platform ==
                TargetPlatform.macOS;

    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: isCupertino
            ? CupertinoActivityIndicator(
                color: loaderColor,
              )
            : CircularProgressIndicator(
                strokeWidth: 2.2,
                color: loaderColor,
              ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],

        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),

        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          trailingIcon!,
        ],
      ],
    );
  }
}