import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'desktop_initial_view.dart';
import '../pageview_mobile/mobile_initial_view.dart';

class InitialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size) {
        if (size.deviceScreenType == DeviceScreenType.desktop) {
          return MobileInitialView();
        }
        return MobileInitialView();
      },
    );
  }
}
