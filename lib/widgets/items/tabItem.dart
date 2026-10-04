import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/theme/app_styles.dart';
import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.text,
    required this.selected,
    required this.contentDescription,
  });

  final String text;
  final bool selected;
  final String contentDescription;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      label: contentDescription,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',                // ← Cairo everywhere
              fontSize: 11,                       // ← same for every tab
              height: 1.2,
              fontWeight: selected
                  ? FontWeight.w800               // selected → bold
                  : FontWeight.w600,              // unselected → normal
              color: AppColors.mainC,
            ),
          ),
        ),
      ),
    );
  }
}
