import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget child;
  final ButtonStyle? style;
  final bool? autofocus;
  final Clip? clipBehavior;
  final FocusNode? focusNode;
  final VoidCallback? onLongPress;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
    this.style,
    this.autofocus,
    this.clipBehavior,
    this.focusNode,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      autofocus: autofocus ?? false,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      onLongPress: onLongPress,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          : child,
    );
  }
}
