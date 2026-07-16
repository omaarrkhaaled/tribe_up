import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class ImageCropperScreen extends StatefulWidget {
  final File imageFile;

  final bool isCover;

  const ImageCropperScreen({
    super.key,
    required this.imageFile,
    this.isCover = false,
  });

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen>
    with SingleTickerProviderStateMixin {
  ui.Image? _image;
  bool _isCropping = false;

  Offset _offset = Offset.zero;
  double _scale = 1.0;
  double _minScale = 1.0;
  double _maxScale = 4.0;

  Offset _startFocalPoint = Offset.zero;
  Offset _startOffset = Offset.zero;
  double _startScale = 1.0;

  // Viewport/crop dimensions (set in build, used in gesture callbacks)
  double _viewportWidth = 0;
  double _viewportHeight = 0;
  double _cropW = 0;
  double _cropH = 0;
  bool _initialized = false;

  // Cover aspect ratio: match the cover display frame (width:height ≈ 190/110 ≈ 1.73)
  static const double _coverAspect = 190 / 110;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final bytes = await widget.imageFile.readAsBytes();
    final decoded = await decodeImageFromList(bytes);
    if (mounted) {
      setState(() => _image = decoded);
      WidgetsBinding.instance.addPostFrameCallback((_) => _initTransform());
    }
  }

  void _initTransform() {
    if (_image == null || _viewportWidth == 0 || _initialized) return;
    final double imgW = _image!.width.toDouble();
    final double imgH = _image!.height.toDouble();

    // Scale so the image fully covers the crop frame
    final double scaleX = _cropW / imgW;
    final double scaleY = _cropH / imgH;
    _minScale = scaleX > scaleY ? scaleX : scaleY;
    _scale = _minScale;
    _maxScale = _minScale * 4.0;

    // Center the scaled image in the viewport
    _offset = Offset(
      (_viewportWidth - imgW * _scale) / 2,
      (_viewportHeight - imgH * _scale) / 2,
    );

    setState(() => _initialized = true);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startFocalPoint = details.focalPoint;
    _startOffset = _offset;
    _startScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_startScale * details.scale).clamp(_minScale, _maxScale);
      final Offset focalDelta = details.focalPoint - _startFocalPoint;
      _offset =
          _startOffset +
          focalDelta +
          (_startFocalPoint - _startOffset) * (1 - details.scale);
    });
  }

  void _onSliderChanged(double newScale) {
    setState(() {
      final double oldScale = _scale;
      _scale = newScale.clamp(_minScale, _maxScale);

      // Zoom relative to the center of the viewport
      final Offset center = Offset(_viewportWidth / 2, _viewportHeight / 2);
      _offset = center - (center - _offset) * (_scale / oldScale);
    });
  }

  Future<void> _cropAndSave() async {
    if (_isCropping || _image == null) return;

    final double vw = _viewportWidth;
    final double vh = _viewportHeight;
    final double cw = _cropW;
    final double ch = _cropH;
    final double scale = _scale;
    final Offset offset = _offset;
    final ui.Image image = _image!;
    final double dpr = MediaQuery.of(context).devicePixelRatio;

    setState(() => _isCropping = true);

    try {
      // Crop rect top-left in viewport space (centered)
      final double cropLeft = (vw - cw) / 2;
      final double cropTop = (vh - ch) / 2;

      // Convert crop rect from viewport space → image space
      final double srcLeft = (cropLeft - offset.dx) / scale;
      final double srcTop = (cropTop - offset.dy) / scale;
      final double srcW = cw / scale;
      final double srcH = ch / scale;

      final double outW = cw * dpr;
      final double outH = ch * dpr;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final srcRect = Rect.fromLTWH(
        srcLeft.clamp(0.0, image.width.toDouble()),
        srcTop.clamp(0.0, image.height.toDouble()),
        srcW.clamp(1.0, image.width.toDouble()),
        srcH.clamp(1.0, image.height.toDouble()),
      );
      final dstRect = Rect.fromLTWH(0, 0, outW, outH);

      canvas.drawImageRect(
        image,
        srcRect,
        dstRect,
        Paint()..filterQuality = FilterQuality.high,
      );

      final picture = recorder.endRecording();
      final cropped = await picture.toImage(outW.round(), outH.round());
      final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception("Failed to get byte data");

      final croppedFile = File(
        '${widget.imageFile.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await croppedFile.writeAsBytes(byteData.buffer.asUint8List());

      if (mounted) Navigator.of(context).pop(croppedFile);
    } catch (e) {
      debugPrint("Crop error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(UiConstants.failedToCropImage),
            backgroundColor: ColorManager.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCropping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (widget.isCover) {
      // Cover: full-width viewport, crop frame = cover display ratio
      _viewportWidth = screenWidth * 0.95;
      _cropW = _viewportWidth * 0.95;
      _cropH = _cropW / _coverAspect;
      _viewportHeight = _cropH + 80; // a little breathing room above/below
    } else {
      // Profile: square viewport, circular crop
      _viewportWidth = screenWidth * 0.9;
      _viewportHeight = _viewportWidth;
      _cropW = _viewportWidth * 0.8;
      _cropH = _cropW;
    }

    if (_image != null && !_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initTransform());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: ColorManager.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isCover ? "Edit Cover Photo" : "Edit Profile Picture",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: ColorManager.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _image == null
                    ? CircularProgressIndicator(color: ColorManager.primary)
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onScaleStart: _onScaleStart,
                        onScaleUpdate: _onScaleUpdate,
                        child: SizedBox(
                          width: _viewportWidth,
                          height: _viewportHeight,
                          child: ClipRect(
                            child: CustomPaint(
                              painter: _CropperPainter(
                                image: _image!,
                                offset: _offset,
                                scale: _scale,
                                cropW: _cropW,
                                cropH: _cropH,
                                viewportWidth: _viewportWidth,
                                viewportHeight: _viewportHeight,
                                isCircle: !widget.isCover,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),

            // Zoom Slider and Instructions
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  if (_initialized) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.zoom_out,
                          color: ColorManager.lightGrey,
                          size: 20,
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: ColorManager.primary,
                              inactiveTrackColor: ColorManager.grey,
                              thumbColor: ColorManager.primary,
                              overlayColor: ColorManager.primary.withValues(
                                alpha: 0.2,
                              ),
                              trackHeight: 4.0,
                            ),
                            child: Slider(
                              value: _scale.clamp(_minScale, _maxScale),
                              min: _minScale,
                              max: _maxScale,
                              onChanged: _onSliderChanged,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.zoom_in,
                          color: ColorManager.lightGrey,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    "Drag to Move • Pinch or Use Slider to Zoom",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: ColorManager.lightGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isCropping
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorManager.white,
                        side: BorderSide(color: ColorManager.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorManager.white,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isCropping ? null : _cropAndSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        foregroundColor: ColorManager.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isCropping
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: ColorManager.white,
                              ),
                            )
                          : Text(
                              "Apply",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: ColorManager.white,
                                  ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints the image behind a darkened overlay with either a circle or
/// rounded-rectangle crop window depending on [isCircle].
class _CropperPainter extends CustomPainter {
  final ui.Image image;
  final Offset offset;
  final double scale;
  final double cropW;
  final double cropH;
  final double viewportWidth;
  final double viewportHeight;
  final bool isCircle;

  _CropperPainter({
    required this.image,
    required this.offset,
    required this.scale,
    required this.cropW,
    required this.cropH,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.isCircle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the image at current pan/zoom position
    final Rect destRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      image.width * scale,
      image.height * scale,
    );
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      destRect,
      Paint()..filterQuality = FilterQuality.medium,
    );

    // 2. Crop frame rect (centered in viewport)
    final Rect cropRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cropW,
      height: cropH,
    );

    // 3. Darkened overlay with a cutout
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.72)
      ..style = PaintingStyle.fill;

    final Path cutout = isCircle
        ? (Path()..addOval(cropRect))
        : (Path()..addRRect(
            RRect.fromRectAndRadius(cropRect, const Radius.circular(12)),
          ));

    final Path overlay = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      cutout,
    );
    canvas.drawPath(overlay, overlayPaint);

    // 4. Border around crop frame
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (isCircle) {
      canvas.drawOval(cropRect, borderPaint);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(cropRect, const Radius.circular(12)),
        borderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CropperPainter old) =>
      old.image != image ||
      old.offset != offset ||
      old.scale != scale ||
      old.isCircle != isCircle;
}
