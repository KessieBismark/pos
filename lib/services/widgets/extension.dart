import 'package:flutter/material.dart';

import 'label.dart';

extension ContextExtension on BuildContext {
  double get widthh => MediaQuery.of(this).size.width;
  double widthResponse(double perc, double min, double max) =>
      MediaQuery.of(this).size.width * perc < min
          ? min
          : MediaQuery.of(this).size.width * perc > max
              ? max
              : MediaQuery.of(this).size.width * perc;
  double get height => MediaQuery.of(this).size.height;
  void showForm(Widget child) => Navigator.of(this).push(MaterialPageRoute(
        builder: (_) => child,
      ));
}

extension StringExtension on String {
  Widget toLabel({double? fontsize, Color? color, bool bold = false}) => MLabel(
        // ignore: unnecessary_this
        this.replaceAll("Exception: ", ""),
        bold: bold,
        fontSize: fontsize,
        color: color,
      );
}

extension AutoStringExtension on String {
  Widget toAutoLabel({double? fontsize, Color? color, bool bold = false}) =>
      MAutoText(
        // ignore: unnecessary_this
        this.replaceAll("Exception: ", ""),
        bold: bold,
        fontSize: fontsize,
        color: color,
      );
}

extension WidgetExtension on Widget {
  Widget get vMargin3 =>
      Container(margin: const EdgeInsets.symmetric(vertical: 3), child: this);
  Widget get vMargin6 =>
      Container(margin: const EdgeInsets.symmetric(vertical: 6), child: this);
  Widget get vMargin9 =>
      Container(margin: const EdgeInsets.symmetric(vertical: 9), child: this);
  Widget get hMargin3 =>
      Container(margin: const EdgeInsets.symmetric(horizontal: 3), child: this);
  Widget get hMargin6 =>
      Container(margin: const EdgeInsets.symmetric(horizontal: 6), child: this);
  Widget get hMargin9 =>
      Container(margin: const EdgeInsets.symmetric(horizontal: 9), child: this);
  Widget get margin3 => Container(margin: const EdgeInsets.all(3), child: this);
  Widget get margin6 => Container(margin: const EdgeInsets.all(6), child: this);
  Widget get margin9 => Container(margin: const EdgeInsets.all(9), child: this);

//padding
  Widget get vPadding3 =>
      Container(padding: const EdgeInsets.symmetric(vertical: 3), child: this);
  Widget get vPadding6 =>
      Container(padding: const EdgeInsets.symmetric(vertical: 6), child: this);
  Widget get vPadding9 =>
      Container(padding: const EdgeInsets.symmetric(vertical: 9), child: this);
  Widget get hPadding3 => Container(
      padding: const EdgeInsets.symmetric(horizontal: 3), child: this);
  Widget get hPadding6 => Container(
      padding: const EdgeInsets.symmetric(horizontal: 6), child: this);
  Widget get hPadding9 => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9), child: this);
  Widget get padding3 =>
      Container(padding: const EdgeInsets.all(3), child: this);
  Widget get padding6 =>
      Container(padding: const EdgeInsets.all(6), child: this);
  Widget get padding9 =>
      Container(padding: const EdgeInsets.all(9), child: this);

  //card

  Widget get card => Card(child: this);
  Widget get center => Center(child: this);

  Widget get expand => Expanded(child: this);
}

/// add Padding Property to widget
extension WidgetPaddingX on Widget {
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);
}

/// Add margin property to widget
extension WidgetMarginX on Widget {
  Widget marginAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
          margin:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
          margin: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);
}

/// Allows you to insert widgets inside a CustomScrollView
extension WidgetSliverBoxX on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({
    required this.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 399),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      ScaleTransition(scale: animation, child: child);
}
