import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/animation.dart';

// Chart-wide defaults to avoid magic numbers and duplication.

// Animation
const Duration barSwapDuration = Duration(milliseconds: 350);
const Curve barSwapCurve = Curves.easeOutCubic;

// Layout
const double barLeftReservedSizeSmall = 28;
const double barLeftReservedSizeDetail = 36;
const double barLeftInterval = 10;
const double barWidthCard = 8;
const double barWidthDetail = 12;

// Alignment
const BarChartAlignment defaultBarAlignment = BarChartAlignment.spaceBetween;
