import 'package:complex_ui/core/mvp/presenter.dart';
import 'package:complex_ui/core/services/navigation_service.dart';
import 'package:complex_ui/features/dashboard/screens/bar_chart_detail.dart';
import 'package:flutter/material.dart';

abstract class ChartView {}

abstract class IChartPresenter {
  void onChartTap(String chartId);
}

class ChartPresenter extends Presenter<ChartView> implements IChartPresenter {
  final INavigationService _navigationService;

  ChartPresenter(this._navigationService);

  @override
  void onChartTap(String chartId) {
    _navigationService.showModalBottomSheet(
      SafeArea(child: BarChartDetailScreen(chartId: chartId)),
    );
  }
}
