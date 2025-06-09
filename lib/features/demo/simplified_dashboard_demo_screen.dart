// lib/features/demo/simplified_dashboard_demo_screen.dart
import 'package:flutter/material.dart';
import 'package:shamil_web/core/constants/app_colors.dart'; 
import 'package:shamil_web/core/constants/app_dimensions.dart';

// Enum to represent the different demo sections
enum DemoSection {
  dashboardOverview,
  members,
  bookings,
  classesServices,
  accessControl,
  reports,
  analytics,
  settings,
}

class SimplifiedDashboardDemoScreen extends StatefulWidget {
  const SimplifiedDashboardDemoScreen({super.key});

  @override
  State<SimplifiedDashboardDemoScreen> createState() =>
      _SimplifiedDashboardDemoScreenState();
}

class _SimplifiedDashboardDemoScreenState
    extends State<SimplifiedDashboardDemoScreen> {
  DemoSection _selectedSection = DemoSection.dashboardOverview;
  bool _isNfcConnected = false; // Demo state for NFC
  String _lastScanResultStatus = "Access Granted"; // Demo state for scan result
  String _lastScanUser = "John Doe (ID: 12345)";

  // Sidebar Items Data
  final List<Map<String, dynamic>> _sidebarItems = [
    {'label': 'Dashboard', 'icon': Icons.dashboard_rounded, 'section': DemoSection.dashboardOverview},
    {'label': 'Members', 'icon': Icons.group_outlined, 'section': DemoSection.members},
    {'label': 'Bookings', 'icon': Icons.calendar_today_outlined, 'section': DemoSection.bookings},
    {'label': 'Classes/Services', 'icon': Icons.fitness_center_rounded, 'section': DemoSection.classesServices},
    {'label': 'Access Control', 'icon': Icons.admin_panel_settings_outlined, 'section': DemoSection.accessControl},
    {'label': 'Reports', 'icon': Icons.assessment_outlined, 'section': DemoSection.reports},
    {'label': 'Analytics', 'icon': Icons.analytics_outlined, 'section': DemoSection.analytics},
  ];

  final List<Map<String, dynamic>> _footerItems = [
    {'label': 'Settings', 'icon': Icons.settings_outlined, 'section': DemoSection.settings},
    {'label': 'Logout', 'icon': Icons.logout_rounded, 'isLogout': true},
  ];

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobileDemoLayout = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shamil Dashboard - Live Demo'),
        backgroundColor: AppColors.primary, // Use AppColors
        elevation: 2,
        leading: IconButton( // Add back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          _buildDemoSidebar(theme, isMobileDemoLayout),
          Expanded(
            child: Container(
              color: theme.brightness == Brightness.light ? AppColors.lightPageBackground.withOpacity(0.5) : AppColors.darkPageBackground.withOpacity(0.8),
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: _buildDemoContentArea(theme, isMobileDemoLayout),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoSidebar(ThemeData theme, bool isMobileLayout) {
    return Material( 
      elevation: 4.0, 
      child: Container(
        width: isMobileLayout ? 65 : 240, 
        color: theme.brightness == Brightness.light ? AppColors.white : AppColors.darkSurface,
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
        child: Column(
          children: [
            if (!isMobileLayout)
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryGold,
                      child: Text('SP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    const SizedBox(height: AppDimensions.spacingSmall),
                    Text(
                      'Demo Provider Inc.',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'provider@example.com',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
                       textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            if (!isMobileLayout) const Divider(height: AppDimensions.paddingMedium),
            Expanded(
              child: ListView.builder(
                itemCount: _sidebarItems.length,
                itemBuilder: (context, index) {
                  final item = _sidebarItems[index];
                  final isSelected = _selectedSection == item['section'];
                  return Tooltip(
                    message: isMobileLayout ? item['label'] as String : '',
                    child: Material( 
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedSection = item['section'] as DemoSection;
                          });
                        },
                        splashColor: AppColors.primary.withOpacity(0.1),
                        highlightColor: AppColors.primary.withOpacity(0.05),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: AppDimensions.paddingExtraSmall),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobileLayout ? AppDimensions.paddingSmall : AppDimensions.paddingMedium,
                            vertical: AppDimensions.paddingSmall + (isMobileLayout ? 2 : 4),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                          ),
                          child: Row(
                            mainAxisAlignment: isMobileLayout ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                color: isSelected ? AppColors.primary : theme.iconTheme.color?.withOpacity(0.7),
                                size: isMobileLayout ? 22 : 20,
                              ),
                              if (!isMobileLayout) ...[
                                const SizedBox(width: AppDimensions.spacingMedium),
                                Expanded( 
                                  child: Text(
                                    item['label'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? AppColors.primary : theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
             if (!isMobileLayout) const Divider(height: AppDimensions.paddingMedium),
            ..._footerItems.map((item) {
                 final isSelected = _selectedSection == item['section']; 
                 return Tooltip(
                    message: isMobileLayout ? item['label'] as String : '',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (item['isLogout'] == true) {
                            _showDemoMessage('Logout clicked! (Demo Mode)');
                          } else {
                             setState(() {
                               _selectedSection = item['section'] as DemoSection;
                             });
                          }
                        },
                         splashColor: AppColors.primary.withOpacity(0.1),
                        highlightColor: AppColors.primary.withOpacity(0.05),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: AppDimensions.paddingExtraSmall),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobileLayout ? AppDimensions.paddingSmall : AppDimensions.paddingMedium,
                            vertical: AppDimensions.paddingSmall + (isMobileLayout ? 2 : 4),
                          ),
                          decoration: BoxDecoration(
                             color: isSelected && item['isLogout'] != true ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                          ),
                          child: Row(
                             mainAxisAlignment: isMobileLayout ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                color: item['isLogout'] == true ? AppColors.errorRed : (isSelected ? AppColors.primary : theme.iconTheme.color?.withOpacity(0.7)),
                                size: isMobileLayout ? 22 : 20,
                              ),
                              if (!isMobileLayout) ...[
                                const SizedBox(width: AppDimensions.spacingMedium),
                                Text(
                                  item['label'] as String,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                     color: item['isLogout'] == true ? AppColors.errorRed : (isSelected ? AppColors.primary : theme.textTheme.bodyMedium?.color?.withOpacity(0.9)),
                                     fontWeight: isSelected && item['isLogout'] != true ? FontWeight.bold : FontWeight.normal,
                                  )
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                 );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoContentArea(ThemeData theme, bool isMobileLayout) {
    switch (_selectedSection) {
      case DemoSection.dashboardOverview:
        return _DashboardOverviewDemo(theme: theme, isMobileLayout: isMobileLayout, showDemoMessage: _showDemoMessage);
      case DemoSection.accessControl:
        return _AccessControlDemo(
          theme: theme,
          isMobileLayout: isMobileLayout,
          isNfcConnected: _isNfcConnected,
          lastScanResultStatus: _lastScanResultStatus,
          lastScanUser: _lastScanUser,
          onNfcConnectToggle: () => setState(() => _isNfcConnected = !_isNfcConnected),
          onSimulateScan: (bool grant) {
            setState(() {
              _lastScanResultStatus = grant ? "Access Granted" : "Access Denied";
              _lastScanUser = grant ? "Jane Smith (ID: 67890)" : "Unknown User (Tag: XXXXX)";
            });
             _showDemoMessage('Simulated Scan: $_lastScanResultStatus for $_lastScanUser');
          },
          showDemoMessage: _showDemoMessage,
        );
      case DemoSection.classesServices:
        return _ClassesServicesDemo(theme: theme, isMobileLayout: isMobileLayout, showDemoMessage: _showDemoMessage);
      case DemoSection.bookings:
      case DemoSection.members:
      case DemoSection.reports:
      case DemoSection.analytics:
      case DemoSection.settings:
        return _PlaceholderContentWidget(
          label: _selectedSection.toString().split('.').last.replaceAllMapped(
                RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}'
              ).trim().capitalizeFirstLetter(),
          theme: theme,
        );
    }
  }
}

// --- Placeholder Content Widget (Internal to Demo) ---
class _PlaceholderContentWidget extends StatelessWidget {
  final String label;
  final ThemeData theme;
  const _PlaceholderContentWidget({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView( 
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard_customize_outlined,
              size: 60,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Text(label, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8))),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(
              'This is a simplified demo view. Full functionality is available in the Shamil provider app.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
    String capitalizeFirstLetter() {
      if (isEmpty) return this;
      return this[0].toUpperCase() + substring(1);
    }
}

// --- Demo Widget for Dashboard Overview ---
class _DashboardOverviewDemo extends StatelessWidget {
  final ThemeData theme;
  final bool isMobileLayout;
  final Function(String) showDemoMessage;

  const _DashboardOverviewDemo({required this.theme, required this.isMobileLayout, required this.showDemoMessage});

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Added for better spacing
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                Icon(icon, color: iconColor, size: 28),
              ],
            ),
            // const SizedBox(height: AppDimensions.spacingSmall), // Adjusted later by Spacer
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            // const SizedBox(height: AppDimensions.spacingExtraSmall),
            Text('+5% vs last month', style: theme.textTheme.bodySmall?.copyWith(color: Colors.green.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessLogItem(String user, String status, String time, bool isGranted) {
    return ListTile(
      leading: Icon(isGranted ? Icons.check_circle_outline : Icons.cancel_outlined, color: isGranted ? Colors.green : AppColors.errorRed),
      title: Text(user, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text(status, style: theme.textTheme.bodySmall),
      trailing: Text(time, style: theme.textTheme.bodySmall),
      dense: true,
      onTap: () => showDemoMessage('View details for $user (Demo)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.paddingSmall/2, bottom: AppDimensions.spacingMedium),
            child: Text('Dashboard Overview', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isMobileLayout ? 1 : (constraints.maxWidth < 900 ? 2 : 4);
              double aspectRatio = isMobileLayout ? 2.8 : (crossAxisCount == 2 ? 2.0 : 1.8);
              if(crossAxisCount == 1 && constraints.maxWidth > 400) aspectRatio = 3.5;


              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppDimensions.paddingMedium,
                mainAxisSpacing: AppDimensions.paddingMedium,
                childAspectRatio: aspectRatio,
                children: [
                  _buildStatCard('Total Bookings', '178', Icons.event_available, AppColors.primary),
                  _buildStatCard('Revenue (EGP)', '12,500', Icons.monetization_on, AppColors.primaryGold),
                  _buildStatCard('New Members', '23', Icons.person_add, AppColors.accent),
                  _buildStatCard('Pending Access', '2', Icons.hourglass_top_rounded, Colors.orange.shade700),
                ],
              );
            }
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium)),
            child: Container(
              height: isMobileLayout ? 200 : 300,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking Trends (Demo Chart)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1))
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.bar_chart_rounded, size: 60, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          Padding(
             padding: const EdgeInsets.only(left: AppDimensions.paddingSmall/2, bottom: AppDimensions.spacingSmall),
            child: Text('Recent Activity (Demo)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium)),
            child: Column(
              children: [
                _buildAccessLogItem('Ahmed Kamal', 'Access Granted via NFC', '10:32 AM', true),
                const Divider(height: 1),
                _buildAccessLogItem('Sara Ali', 'Access Denied - Invalid Pass', '10:28 AM', false),
                const Divider(height: 1),
                _buildAccessLogItem('Demo User 1', 'Service Booked', '09:15 AM', true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Demo Widget for Access Control ---
class _AccessControlDemo extends StatelessWidget {
  final ThemeData theme;
  final bool isMobileLayout;
  final bool isNfcConnected;
  final String lastScanResultStatus;
  final String lastScanUser;
  final VoidCallback onNfcConnectToggle;
  final Function(bool) onSimulateScan;
  final Function(String) showDemoMessage;

  const _AccessControlDemo({
    required this.theme,
    required this.isMobileLayout,
    required this.isNfcConnected,
    required this.lastScanResultStatus,
    required this.lastScanUser,
    required this.onNfcConnectToggle,
    required this.onSimulateScan,
    required this.showDemoMessage,
  });

  Widget _buildScanResultCard() {
    bool isGranted = lastScanResultStatus == "Access Granted";
    return Card(
      elevation: 2,
      color: isGranted ? Colors.green.shade50 : Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        side: BorderSide(color: isGranted ? Colors.green.shade300 : Colors.red.shade300)
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               children: [
                 Icon(isGranted ? Icons.check_circle : Icons.cancel, color: isGranted ? Colors.green.shade700 : AppColors.errorRed, size: 28),
                 const SizedBox(width: AppDimensions.spacingSmall),
                 Expanded(child: Text('Last Scan: $lastScanResultStatus', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isGranted ? Colors.green.shade800 : AppColors.errorRed))),
               ],
             ),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(lastScanUser, style: theme.textTheme.bodyMedium),
            if (!isGranted)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.spacingExtraSmall),
                  child: Text('Reason: Expired Membership (Demo)', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.errorRed)),
                ),
          ],
        ),
      ),
    );
  }

   Widget _buildAccessLogItem(String user, String status, String time, IconData methodIcon, bool isGranted) {
    return ListTile(
      leading: Icon(isGranted ? Icons.check_circle_outline : Icons.cancel_outlined, color: isGranted ? Colors.green : AppColors.errorRed, size: 28),
      title: Text(user, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Row(
        children: [
          Icon(methodIcon, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
          const SizedBox(width: 4),
          Expanded(child: Text(status, style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8)), overflow: TextOverflow.ellipsis,)),
        ],
      ),
      trailing: Text(time, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingExtraSmall, horizontal: AppDimensions.paddingSmall),
      onTap: () => showDemoMessage('View details for $user (Demo)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall/2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.paddingSmall/2, bottom: AppDimensions.spacingMedium),
            child: Text('Access Control Demo', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium)),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.nfc, color: isNfcConnected ? AppColors.primary : theme.iconTheme.color?.withOpacity(0.5), size: 28),
                          const SizedBox(width: AppDimensions.spacingSmall),
                          Text(isNfcConnected ? 'NFC Reader Connected (Demo)' : 'NFC Reader Disconnected (Demo)', style: theme.textTheme.titleSmall),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onNfcConnectToggle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isNfcConnected ? Colors.grey.shade300 : AppColors.primaryGold,
                          foregroundColor: isNfcConnected ? AppColors.primary : Colors.black,
                           padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: AppDimensions.paddingExtraSmall -2), // Smaller padding
                          textStyle: theme.textTheme.labelMedium, // Ensure text style matches other buttons
                        ),
                        child: Text(isNfcConnected ? 'Disconnect' : 'Connect Demo NFC'),
                      ),
                    ],
                  ),
                  if (isNfcConnected)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.paddingMedium),
                    child: Wrap( // Use Wrap for better responsiveness of buttons
                      spacing: AppDimensions.paddingSmall,
                      runSpacing: AppDimensions.paddingSmall,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                          label: const Text('Simulate Grant'),
                          onPressed: () => onSimulateScan(true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100, foregroundColor: Colors.green.shade800)
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.cancel_schedule_send_rounded, size: 18),
                          label: const Text('Simulate Deny'),
                          onPressed: () => onSimulateScan(false),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red.shade800)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          _buildScanResultCard(),
          const SizedBox(height: AppDimensions.spacingLarge),
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.paddingSmall/2, bottom: AppDimensions.spacingSmall),
            child: Text('Recent Access Logs (Demo)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium)),
            child: Column(
              children: [
                _buildAccessLogItem('Noura Hassan', 'Checked In', '11:05 AM', Icons.qr_code, true),
                const Divider(height: 1),
                _buildAccessLogItem('Karim Fathy', 'Attempted Entry - Invalid Pass', '11:02 AM', Icons.nfc, false),
                const Divider(height: 1),
                _buildAccessLogItem('Layla Ahmed', 'Checked Out', '10:50 AM', Icons.exit_to_app_rounded, true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Demo Widget for Classes/Services ---
class _ClassesServicesDemo extends StatelessWidget {
  final ThemeData theme;
  final bool isMobileLayout;
  final Function(String) showDemoMessage;

  const _ClassesServicesDemo({required this.theme, required this.isMobileLayout, required this.showDemoMessage});

  Widget _buildServiceItem(String name, String duration, String price, IconData icon) {
    return Card(
      elevation: 1.5,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall + 4)),
       margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.1), child: Icon(icon, color: AppColors.primary)),
        title: Text(name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(duration, style: theme.textTheme.bodySmall),
        trailing: Text(price, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
        onTap: () => showDemoMessage('View/Edit "$name" (Demo)'),
      ),
    );
  }

   Widget _buildPlanItem(String name, String price, String interval, List<String> features) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall + 4)),
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary))),
                Text('$price / $interval', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            Wrap(
              spacing: AppDimensions.spacingSmall,
              runSpacing: AppDimensions.spacingExtraSmall,
              children: features.map((f) => Chip(
                label: Text(f, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary.withOpacity(0.8))), 
                backgroundColor: AppColors.primary.withOpacity(0.05),
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraSmall, vertical: 2),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
                )).toList(),
            ),
             Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => showDemoMessage('Edit "$name" Plan (Demo)'), child: const Text('Edit Plan')),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGold,
      foregroundColor: AppColors.textOnGold, // Ensure contrast
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: AppDimensions.paddingExtraSmall -2),
      textStyle: theme.textTheme.labelMedium,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall/2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.paddingSmall/2, bottom: AppDimensions.spacingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Manage Services & Plans (Demo)', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                 ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Add New'),
                  onPressed: () => showDemoMessage('Add New Service/Plan (Demo)'),
                  style: buttonStyle,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.paddingSmall/2, bottom: AppDimensions.spacingSmall, top:AppDimensions.spacingSmall ),
            child: Text('Bookable Services / Classes', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
          ),
          _buildServiceItem('Yoga Session', '60 min - 10 capacity', 'EGP 150', Icons.spa_outlined),
          _buildServiceItem('Fitness Class', '45 min - 20 capacity', 'EGP 120', Icons.fitness_center),
          _buildServiceItem('Consultation', '30 min - 1 capacity', 'EGP 250', Icons.medical_services_outlined),
          
          const SizedBox(height: AppDimensions.spacingLarge),
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.paddingSmall/2, bottom: AppDimensions.spacingSmall),
            child: Text('Subscription Plans', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
          ),
          _buildPlanItem('Gold Membership', 'EGP 500', 'month', ['Unlimited Access', 'Personal Trainer', 'Nutrition Plan']),
          _buildPlanItem('Silver Access', 'EGP 300', 'month', ['Gym Access', 'Group Classes']),
        ],
      ),
    );
  }
}