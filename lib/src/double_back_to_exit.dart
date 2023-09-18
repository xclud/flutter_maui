part of maui;

/// Implements double-back to exit functionality. When the back button is pressed only once, [onPopCanceled] is called.
class DoubleBackToExit extends StatefulWidget {
  /// Constructs the class.
  const DoubleBackToExit({
    Key? key,
    required this.child,
    this.delay = const Duration(milliseconds: 2000),
    required this.onPopCanceled,
  }) : super(key: key);

  /// The widget tree behind a double-back to exit.
  final Widget child;

  /// On pop canceled. Usually we show a [SnackBar] or a toast.
  final void Function(BuildContext context) onPopCanceled;

  /// The timeout.
  final Duration delay;

  @override
  State<StatefulWidget> createState() => _DoubleBackToExitState();
}

class _DoubleBackToExitState extends State<DoubleBackToExit> {
  DateTime? _lastPop;

  /// Returns whether this route can be popped.
  bool get canPop {
    final lastPop = _lastPop;

    return lastPop != null &&
        DateTime.now().isBefore(lastPop.add(widget.delay));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) {
          _lastPop = DateTime.now();

          setState(() {});
          final delay = widget.delay +
              Duration(microseconds: widget.delay.inMicroseconds ~/ 20);

          Timer(delay, () {
            setState(() {});
          });

          widget.onPopCanceled.call(context);
        }
      },
      canPop: canPop,
      child: widget.child,
    );
  }
}
