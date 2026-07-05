import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: textStyle);
        final tp = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: widget.maxLines,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        // If the text does not exceed the maximum lines, render it as-is
        if (!tp.didExceedMaxLines) {
          return Text(widget.text, style: textStyle);
        }

        if (_isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text, style: textStyle),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = false),
                child: Text(
                  UiConstants.seeLess,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: ColorManager.primary),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: widget.maxLines,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = true),
              child: Text(
                UiConstants.seeMore,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: ColorManager.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
