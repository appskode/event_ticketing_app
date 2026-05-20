import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

/// Shared hero target for event list → detail image transitions.
class EventHeroImage extends StatelessWidget {
  const EventHeroImage({
    super.key,
    required this.eventId,
    this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
  });

  final int eventId;
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final BoxFit fit;

  static String heroTag(int eventId) => 'event_image_$eventId';

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final image = _buildImage(context, appColors);

    return Hero(
      tag: heroTag(eventId),
      createRectTween: (begin, end) =>
          MaterialRectArcTween(begin: begin, end: end),
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(width: width, height: height, child: image),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, AppColorsExtension appColors) {
    final url = imageUrl?.trim() ?? '';
    if (url.isEmpty) {
      return ColoredBox(
        color: appColors.imagePlaceholder,
        child: Center(
          child: Icon(
            Icons.event,
            size: 40.sp,
            color: appColors.onImagePlaceholder,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, _) => ColoredBox(
        color: appColors.imagePlaceholder,
        child: Center(
          child: SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ),
      errorWidget: (context, _, __) => ColoredBox(
        color: appColors.imagePlaceholder,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32.sp,
          color: appColors.onImagePlaceholder,
        ),
      ),
    );
  }
}

void precacheEventImage(BuildContext context, String? imageUrl) {
  final url = imageUrl?.trim() ?? '';
  if (url.isEmpty) return;
  precacheImage(CachedNetworkImageProvider(url), context);
}
