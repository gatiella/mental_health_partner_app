// side_menu.dart
import 'package:flutter/material.dart';
import '../../../config/routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      width: 280,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildHeader(theme, isDark),
                const SizedBox(height: 24),
                // _buildMenuTile(
                //   context,
                //   icon: Icons.psychology_rounded,
                //   title: 'Mindfulness',
                //   route: AppRouter.meditationRoute,
                // ),
                // Add new community sections
                _buildMenuTile(
                  context,
                  icon: Icons.group_work_rounded,
                  title: 'Challenges',
                  route: AppRouter.challengesRoute,
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.forum_rounded,
                  title: 'Discussion Groups',
                  route: AppRouter.discussionGroupsRoute,
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.chat_bubble_rounded,
                  title: 'Community Forum',
                  route: AppRouter.forumsRoute,
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.celebration_rounded,
                  title: 'Success Stories',
                  route: AppRouter.successStoriesRoute,
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.insights_rounded,
                  title: 'Analytics',
                  route: AppRouter.analyticsRoute,
                ),

                _buildMenuTile(
                  context,
                  icon: Icons.auto_awesome_rounded,
                  title: 'Achievements',
                  route: AppRouter.achievementsRoute,
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.card_giftcard_rounded,
                  title: 'Rewards',
                  route: AppRouter.rewardsRoute,
                ),
                // _buildMenuTile(
                //   context,
                //   icon: Icons.insights_rounded,
                //   title: 'Statistics',
                //   route: AppRouter.statsRoute,
                // ),
                _buildMenuTile(
                  context,
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  route: AppRouter.settingsRoute,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              'Made with ❤️',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 32,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Sanctuary',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Find peace within',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(icon, size: 24, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        minLeadingWidth: 32,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        hoverColor: theme.colorScheme.primary.withOpacity(0.1),
        splashColor: theme.colorScheme.primary.withOpacity(0.2),
        onTap: () {
          // Removed Navigator.pop(context) - drawer will stay open
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
