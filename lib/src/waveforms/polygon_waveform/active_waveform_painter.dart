import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/polygon_waveform.dart';

///ActiveWaveformPainter for the [PolygonWaveform]
class PolygonActiveWaveformPainter extends ActiveWaveformPainter {
  // ignore: public_member_api_docs
  PolygonActiveWaveformPainter({
    required super.color,
    super.gradient,
    required super.activeSamples,
    required super.waveformAlignment,
    required super.style,
    required super.sampleWidth,
    required this.startIndex,
    required this.endIndex,
  });

  final int startIndex;
  final int endIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final continousActivePaint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path()..moveTo(startIndex * sampleWidth, 0);
    final isStroked = style == PaintingStyle.stroke;

    for (var i = startIndex; i <= endIndex; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i];
      if (isStroked) {
        path.lineTo(x, y);
      } else {
        if (i == activeSamples.length - 1) {
          path.lineTo(x, 0);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    //Shifts the path along y-axis by amount of [alignPosition]
    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, continousActivePaint);
  }
}
