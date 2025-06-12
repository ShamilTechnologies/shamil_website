// lib/features/demo/simplified_dashboard_demo_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// Assuming you have app theme constants

// --- Main Dashboard Screen Widget ---
// This is the main entry point for the new dashboard design.
class SimplifiedDashboardDemoScreen extends StatelessWidget {
  const SimplifiedDashboardDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // UPDATED: The Scaffold is now at this top level. This provides the necessary
    // context for the Navigator to function correctly when the back button is pressed.
    return const Scaffold(
      body: DashboardLayout(),
    );
  }
}

// --- Responsive Dashboard Layout ---
// UPDATED: Converted to a StatefulWidget to manage the state of the selected page.
class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  // The state for the currently selected index now lives here, in the parent widget.
  int _selectedIndex = 0;

  // This callback is passed to the sidebar to update the state when an item is tapped.
  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // This callback handles taps on footer items like "Logout".
  void _onFooterItemSelected(String title) {
     if (title == 'Logout') {
        // Here you would implement your actual logout logic.
        // For this demo, we'll show a confirmation dialog.
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                          Navigator.of(context).pop();
                          // Perform actual logout action
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                ],
            ),
        );
     } else {
        // Handle other footer items like 'Settings'
         setState(() {
            // For this demo, we'll just treat settings as another page index.
            // In a real app, this might navigate to a completely different route.
            _selectedIndex = 5; 
         });
     }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // The sidebar now receives the current index and the callback function.
        _SidebarNavigation(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          onFooterItemSelected: _onFooterItemSelected,
        ),
        // The content area is now a separate widget that also receives the selected index.
        Expanded(
          child: DashboardContent(selectedIndex: _selectedIndex),
        ),
      ],
    );
  }
}

// --- Sidebar Navigation Widget ---
// UPDATED: Converted to a StatelessWidget as it no longer manages its own state.
class _SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final ValueChanged<String> onFooterItemSelected;

  const _SidebarNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onFooterItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final sidebarColor = isDarkMode ? const Color(0xFF1A1D21) : const Color(0xFF0D253F);
    final textColor = Colors.white.withOpacity(0.7);
    final hoverColor = isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2);

    return Container(
      width: 250,
      color: sidebarColor,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.shield_rounded, color: Colors.white, size: 40)),
                const SizedBox(width: 12),
                const Text(
                  'Shamil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0, textColor, hoverColor),
                _buildNavItem(Icons.people_alt_rounded, 'Users', 1, textColor, hoverColor),
                _buildNavItem(Icons.calendar_today_rounded, 'Bookings', 2, textColor, hoverColor),
                _buildNavItem(Icons.class_rounded, 'Classes/Services', 3, textColor, hoverColor),
                _buildNavItem(Icons.admin_panel_settings_rounded, 'Access Control', 4, textColor, hoverColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                 const Divider(color: Colors.white24),
                 _buildNavItem(Icons.settings, 'Settings', 5, textColor, hoverColor, isFooter: true),
                 _buildNavItem(Icons.logout_rounded, 'Logout', 6, textColor, hoverColor, isFooter: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  // UPDATED: The onTap callback now differentiates between main content and footer actions.
  Widget _buildNavItem(IconData icon, String title, int index, Color textColor, Color hoverColor, {bool isFooter = false}) {
    final bool isSelected = selectedIndex == index;
    final color = isSelected ? Colors.white : textColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          // If it's a footer item, use the footer callback. Otherwise, use the main navigation callback.
          if (isFooter) {
            onFooterItemSelected(title);
          } else {
            onDestinationSelected(index);
          }
        },
        borderRadius: BorderRadius.circular(8),
        hoverColor: hoverColor,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Main Dashboard Content ---
// UPDATED: This widget now takes a 'selectedIndex' and displays the correct page.
class DashboardContent extends StatelessWidget {
  final int selectedIndex;
  const DashboardContent({required this.selectedIndex, super.key});

  // This helper method returns the correct page widget based on the selected index.
  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return const _DashboardOverviewContent();
      case 1:
        return const _PlaceholderPage(title: 'User Management', icon: Icons.people_alt_rounded);
      case 2:
        return const _PlaceholderPage(title: 'Bookings', icon: Icons.calendar_today_rounded);
      case 3:
        return const _PlaceholderPage(title: 'Classes/Services', icon: Icons.class_rounded);
      case 4:
        return const _PlaceholderPage(title: 'Access Control', icon: Icons.admin_panel_settings_rounded);
      case 5:
        return const _PlaceholderPage(title: 'Settings', icon: Icons.settings);
      default:
        return const _DashboardOverviewContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final contentBgColor = isDarkMode ? const Color(0xFF101215) : const Color(0xFFF0F2F5);

    return Container(
      color: contentBgColor,
      // Use an AnimatedSwitcher to provide a smooth cross-fade transition between pages.
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildContent(),
      ),
    );
  }
}

// --- Placeholder Page for Other Sections ---
// A generic placeholder widget to show for sections that are not the main dashboard.
class _PlaceholderPage extends StatelessWidget {
    final String title;
    final IconData icon;
    const _PlaceholderPage({required this.title, required this.icon});

    @override
    Widget build(BuildContext context) {
        return Center(
            key: ValueKey(title), // Important for AnimatedSwitcher to detect changes
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Icon(icon, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 20),
                    Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Content for this page is under construction.', style: TextStyle(color: Colors.grey.shade600)),
                ],
            ),
        );
    }
}

// --- Dashboard Overview Content ---
// UPDATED: The original dashboard content is now wrapped in its own widget for clarity.
class _DashboardOverviewContent extends StatelessWidget {
  const _DashboardOverviewContent();
  
  @override
  Widget build(BuildContext context) {
    return ListView(
        key: const ValueKey('DashboardOverview'), // Key for AnimatedSwitcher
        padding: const EdgeInsets.all(24.0),
        children: [
          const _DashboardHeader(),
          const SizedBox(height: 24),
          const _StatsGrid(),
          const SizedBox(height: 24),
          const _ChartSection(),
          const SizedBox(height: 24),
          const _RecentActivity(),
        ].animate(interval: 100.ms).fadeIn(duration: 400.ms).moveY(begin: 20, end: 0),
      );
  }
}


// --- Dashboard Header Widget ---
class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    // This checks if there's a route to go back to.
    final canGoBack = Navigator.of(context).canPop();
    // UPDATED: Determine the color for the back arrow based on the theme to ensure it's always visible.
    final Color iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // The Row now contains the back button and the title.
        Row(
          children: [
            // UPDATED: The back button is conditionally displayed.
            // It only appears if there is a previous screen to navigate back to.
            if (canGoBack)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  // UPDATED: Set the icon color to white as requested, ensuring it's visible.
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: iconColor),
                  tooltip: 'Back to Provider Screen',
                  onPressed: () {
                    // This command navigates to the previous screen.
                    Navigator.of(context).pop();
                  },
                ),
              ),
            const Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search anything...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://placehold.co/100x100/0D253F/FFFFFF?text=S'),
                    radius: 18,
                  ),
                  SizedBox(width: 12),
                  Text('Service Provider', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

// --- Statistics Grid Widget ---
class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: const [
        _StatCard(
          title: 'Total Revenue',
          value: '\$45,231.89',
          icon: Icons.monetization_on,
          color: Color(0xFF2962FF),
          change: '+12.5%',
        ),
        _StatCard(
          title: 'Total Bookings',
          value: '1,890',
          icon: Icons.event_available,
          color: Color(0xFF26A69A),
          change: '+8.2%',
        ),
        _StatCard(
          title: 'Active Members',
          value: '2,315',
          icon: Icons.people,
          color: Color(0xFF673AB7),
          change: '-1.5%',
        ),
        _StatCard(
          title: 'New Users This Month',
          value: '154',
          icon: Icons.person_add,
          color: Color(0xFFFFA000),
          change: '+22%',
        ),
      ],
    );
  }
}

// --- Individual Statistic Card Widget ---
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositiveChange = change.startsWith('+');

    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositiveChange ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositiveChange ? Colors.green.shade600 : Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- Chart Section Widget ---
class _ChartSection extends StatelessWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _ChartCard(
            title: 'Revenue Over Time',
            child: _PlaceholderChart(color: Colors.blue.shade300),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: _ChartCard(
            title: 'Bookings by Service',
            child: _PlaceholderChart(color: Colors.teal.shade300, isBarChart: false),
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// A placeholder to represent a chart visually
class _PlaceholderChart extends StatelessWidget {
  final Color color;
  final bool isBarChart;
  const _PlaceholderChart({required this.color, this.isBarChart = true});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    if(isBarChart) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(12, (index) => Flexible(
          child: Container(
            height: (random.nextDouble() * 0.8 + 0.2) * 250,
            width: 20,
            decoration: BoxDecoration(
              color: color.withOpacity(0.6 + random.nextDouble() * 0.4),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
        )),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.5), width: 25),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 35),
            ),
          ),
        ),
      );
    }
  }
}


// --- Recent Activity List Widget ---
class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Column(
            children: [
              _buildActivityTile(
                icon: Icons.person,
                title: 'New User Subscription',
                subtitle: 'Ahmad subscribed to the Gold Plan.',
                value: '+\$99.00',
                valueColor: Colors.green,
              ),
              const Divider(height: 24),
              _buildActivityTile(
                icon: Icons.calendar_today,
                title: 'New Booking',
                subtitle: 'Fatima booked a Yoga Class.',
                value: 'Confirmed',
                valueColor: Colors.blue,
              ),
              const Divider(height: 24),
              _buildActivityTile(
                icon: Icons.cancel,
                title: 'Booking Cancelled',
                subtitle: 'Omar cancelled his PT session.',
                value: 'Refunded',
                valueColor: Colors.orange,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        CircleAvatar(child: Icon(icon, size: 20)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
