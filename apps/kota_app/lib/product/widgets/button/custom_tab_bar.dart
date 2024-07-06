import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
import 'package:values/values.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    required this.tabController,
    required this.tabList,
    super.key,
    this.color,
    this.radius,
    this.labelStyle,
    this.width,
  });
  final TabController tabController;

  final List<String> tabList;

  final Color? color;
  final double? radius;
  final double? width;

  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius ?? ModuleRadius.m.value),
        border: Border.all(color: context.onBackground),
      ),
      child: TabBar(
        controller: tabController,
        indicatorWeight: 0,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        labelStyle: labelStyle,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicator: BoxDecoration(
          color:
              color ?? context.onBackground,
          borderRadius: BorderRadius.circular(ModuleRadius.m.value),
        ),
        tabs: tabList
            .map((e) => SizedBox(width: double.infinity, child: Tab(text: e,)))
            .toList(),
      ),
    );
  }
}
