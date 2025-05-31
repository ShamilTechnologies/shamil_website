// lib/features/provider/data/models/business_analytics_model.dart

import 'package:flutter/material.dart'; // For IconData

enum TrendDirection { up, down, neutral }

@immutable
class AnalyticMetric {
  final String labelKey; // Localization key for metric name
  final String formattedValue;
  final IconData icon;
  final Color iconColor;
  final TrendDirection? trend; // Optional: for metrics like "vs. last month"
  final String? trendValue; // Optional: e.g., "+5.2%"

  const AnalyticMetric({
    required this.labelKey,
    required this.formattedValue,
    required this.icon,
    required this.iconColor,
    this.trend,
    this.trendValue,
  });
}

@immutable
class RevenueDataPoint {
  final DateTime date;
  final double amount;

  const RevenueDataPoint({required this.date, required this.amount});
}

@immutable
class ServicePerformance {
  final String serviceNameKey; // Localization key
  final int bookingCount;
  final double revenueGenerated;

  const ServicePerformance({
    required this.serviceNameKey,
    required this.bookingCount,
    required this.revenueGenerated,
  });
}

@immutable
class BusinessAnalyticsModel {
  final String providerId;
  final DateTimeRange reportPeriod;
  
  // Overview Metrics
  final AnalyticMetric totalRevenue;
  final AnalyticMetric totalBookings;
  final AnalyticMetric averageBookingValue;
  final AnalyticMetric newCustomers;
  final AnalyticMetric bookingConversionRate; // e.g., profile views to bookings

  // Detailed Data for Charts/Tables
  final List<RevenueDataPoint> revenueOverTime; // For line chart
  final List<ServicePerformance> topPerformingServices;
  final Map<String, int> customerDemographics; // e.g., {"age_25_34": 150, "gender_female": 200}

  // Engagement Metrics
  final double profileViews;
  final double averageSessionDuration; // For provider dashboard on web/app

  const BusinessAnalyticsModel({
    required this.providerId,
    required this.reportPeriod,
    required this.totalRevenue,
    required this.totalBookings,
    required this.averageBookingValue,
    required this.newCustomers,
    required this.bookingConversionRate,
    this.revenueOverTime = const [],
    this.topPerformingServices = const [],
    this.customerDemographics = const {},
    this.profileViews = 0,
    this.averageSessionDuration = 0,
  });
}
