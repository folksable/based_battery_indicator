import 'index.dart';

/// [BasedBatteryIndicator] shows a iOS-like battery indicator with
class BasedBatteryIndicator extends StatelessWidget {
  const BasedBatteryIndicator({
    super.key,
    required this.status,
    this.trackHeight = 10.0,
    this.trackAspectRatio = 2.0,
    this.curve = Curves.ease,
    this.duration = const Duration(seconds: 1),
  }) : assert(trackAspectRatio >= 1, 'width:height must >= 1');

  /// battery status
  final BasedBatteryStatus status;

  /// The height of the track (i.e. container).
  final double trackHeight;

  /// width:height must >= 1
  final double trackAspectRatio;

  /// animation curve
  final Curve curve;

  /// animation duration
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final track = _buildTrack(context, colorScheme);
    final knob = _buildKnob(context, colorScheme);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [track, knob],
    );
  }

  Widget _buildTrack(BuildContext context, ColorScheme colorScheme) {
    final borderRadius = BorderRadius.circular(trackHeight / 4);
    final borderColor = colorScheme.outline;

    final bar = _buildBar(context, trackHeight * 5 / 6, colorScheme);
    final icon = _buildIcon(colorScheme);

    final children = [bar, icon];

    return Container(
      height: trackHeight,
      width: trackHeight * trackAspectRatio,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Stack(
        children: children,
      ),
    );
  }

  Widget _buildBar(
    BuildContext context,
    double barHeight,
    ColorScheme colorScheme,
  ) {
    final barWidth = trackHeight * trackAspectRatio;
    final borderRadius = barHeight / 5;
    final currentColor = status.getBatteryColor(colorScheme);

    return Padding(
      padding: EdgeInsets.all(trackHeight / 25),
      child: Stack(
        children: [
          const SizedBox.expand(),
          AnimatedContainer(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            duration: duration,
            width: barWidth * status.value / 100,
            height: double.infinity,
            curve: curve,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
                topRight: const Radius.circular(4), 
                bottomRight: const Radius.circular(4),
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: duration.inMilliseconds ~/ 5),
            switchInCurve: curve,
            switchOutCurve: curve,
            child: status.type.isCharing
                ? Icon(
                    Icons.electric_bolt,
                    color: colorScheme.primary,
                    size: constraints.maxHeight,
                    shadows: [
                      const Shadow(blurRadius: 0.5),
                      Shadow(
                        color: colorScheme.primary,
                        blurRadius: 1,
                      ),
                    ],
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildKnob(BuildContext context, ColorScheme colorScheme) {
    final double knobHeight = trackHeight / 3;
    final double knobWidth = knobHeight / 2;
    final borderColor = colorScheme.outline;

    return Padding(
      padding: EdgeInsets.only(left: trackHeight / 20),
      child: Container(
        width: knobWidth,
        height: knobHeight,
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(knobWidth / 3),
          ),
        ),
      ),
    );
  }
}
