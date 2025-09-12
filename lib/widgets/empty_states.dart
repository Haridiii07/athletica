import 'package:flutter/material.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/widgets/error_widgets.dart';

/// Empty state for clients list
class EmptyClientsWidget extends StatelessWidget {
  final VoidCallback? onAddClient;

  const EmptyClientsWidget({
    super.key,
    this.onAddClient,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Clients Yet',
      subtitle:
          'Start building your client base by adding your first client. You can create personalized workout plans and track their progress.',
      icon: Icons.people_outline,
      iconColor: AppTheme.primaryBlue,
      actionText: 'Add First Client',
      onAction: onAddClient,
    );
  }
}

/// Empty state for plans list
class EmptyPlansWidget extends StatelessWidget {
  final VoidCallback? onCreatePlan;

  const EmptyPlansWidget({
    super.key,
    this.onCreatePlan,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Workout Plans',
      subtitle:
          'Create your first workout plan to start helping your clients achieve their fitness goals. Choose from templates or create custom plans.',
      icon: Icons.fitness_center,
      iconColor: AppTheme.successGreen,
      actionText: 'Create First Plan',
      onAction: onCreatePlan,
    );
  }
}

/// Empty state for messages
class EmptyMessagesWidget extends StatelessWidget {
  final VoidCallback? onStartChat;

  const EmptyMessagesWidget({
    super.key,
    this.onStartChat,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Messages',
      subtitle:
          'Start a conversation with your clients to provide support, answer questions, and build stronger relationships.',
      icon: Icons.chat_bubble_outline,
      iconColor: AppTheme.warningOrange,
      actionText: 'Start Chatting',
      onAction: onStartChat,
    );
  }
}

/// Empty state for analytics
class EmptyAnalyticsWidget extends StatelessWidget {
  final VoidCallback? onViewReports;

  const EmptyAnalyticsWidget({
    super.key,
    this.onViewReports,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Analytics Data',
      subtitle:
          'Analytics will appear here once you start working with clients and creating plans. Track progress and performance over time.',
      icon: Icons.analytics_outlined,
      iconColor: AppTheme.textGrey,
      actionText: 'View Reports',
      onAction: onViewReports,
    );
  }
}

/// Empty state for notifications
class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: 'No Notifications',
      subtitle:
          'You\'re all caught up! New notifications will appear here when you receive messages, client updates, or system alerts.',
      icon: Icons.notifications_none,
      iconColor: AppTheme.textGrey,
    );
  }
}

/// Empty state for search results
class EmptySearchResultsWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const EmptySearchResultsWidget({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Results Found',
      subtitle:
          'No results found for "$searchQuery". Try adjusting your search terms or filters.',
      icon: Icons.search_off,
      iconColor: AppTheme.textGrey,
      actionText: 'Clear Search',
      onAction: onClearSearch,
    );
  }
}

/// Empty state for favorites
class EmptyFavoritesWidget extends StatelessWidget {
  final VoidCallback? onBrowseItems;

  const EmptyFavoritesWidget({
    super.key,
    this.onBrowseItems,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Favorites',
      subtitle:
          'Items you mark as favorites will appear here for quick access.',
      icon: Icons.favorite_border,
      iconColor: AppTheme.errorRed,
      actionText: 'Browse Items',
      onAction: onBrowseItems,
    );
  }
}

/// Empty state for history
class EmptyHistoryWidget extends StatelessWidget {
  final VoidCallback? onStartActivity;

  const EmptyHistoryWidget({
    super.key,
    this.onStartActivity,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No History',
      subtitle:
          'Your activity history will appear here once you start using the app.',
      icon: Icons.history,
      iconColor: AppTheme.textGrey,
      actionText: 'Get Started',
      onAction: onStartActivity,
    );
  }
}

/// Empty state for downloads
class EmptyDownloadsWidget extends StatelessWidget {
  final VoidCallback? onBrowseContent;

  const EmptyDownloadsWidget({
    super.key,
    this.onBrowseContent,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Downloads',
      subtitle: 'Downloaded content will appear here for offline access.',
      icon: Icons.download_outlined,
      iconColor: AppTheme.textGrey,
      actionText: 'Browse Content',
      onAction: onBrowseContent,
    );
  }
}

/// Empty state for achievements
class EmptyAchievementsWidget extends StatelessWidget {
  final VoidCallback? onViewGoals;

  const EmptyAchievementsWidget({
    super.key,
    this.onViewGoals,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Achievements Yet',
      subtitle:
          'Complete goals and milestones to earn achievements and badges.',
      icon: Icons.emoji_events_outlined,
      iconColor: AppTheme.warningOrange,
      actionText: 'View Goals',
      onAction: onViewGoals,
    );
  }
}

/// Empty state for settings
class EmptySettingsWidget extends StatelessWidget {
  final VoidCallback? onConfigureSettings;

  const EmptySettingsWidget({
    super.key,
    this.onConfigureSettings,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Custom Settings',
      subtitle:
          'Customize your app experience by adjusting settings and preferences.',
      icon: Icons.settings_outlined,
      iconColor: AppTheme.textGrey,
      actionText: 'Configure Settings',
      onAction: onConfigureSettings,
    );
  }
}

/// Empty state for subscriptions
class EmptySubscriptionsWidget extends StatelessWidget {
  final VoidCallback? onViewPlans;

  const EmptySubscriptionsWidget({
    super.key,
    this.onViewPlans,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Active Subscriptions',
      subtitle:
          'Subscribe to a plan to unlock premium features and grow your fitness business.',
      icon: Icons.star_outline,
      iconColor: AppTheme.warningOrange,
      actionText: 'View Plans',
      onAction: onViewPlans,
    );
  }
}

/// Empty state for payments
class EmptyPaymentsWidget extends StatelessWidget {
  final VoidCallback? onAddPaymentMethod;

  const EmptyPaymentsWidget({
    super.key,
    this.onAddPaymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Payment Methods',
      subtitle: 'Add a payment method to manage subscriptions and billing.',
      icon: Icons.payment_outlined,
      iconColor: AppTheme.successGreen,
      actionText: 'Add Payment Method',
      onAction: onAddPaymentMethod,
    );
  }
}

/// Empty state for reports
class EmptyReportsWidget extends StatelessWidget {
  final VoidCallback? onGenerateReport;

  const EmptyReportsWidget({
    super.key,
    this.onGenerateReport,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Reports Generated',
      subtitle:
          'Generate reports to track your business performance and client progress.',
      icon: Icons.assessment_outlined,
      iconColor: AppTheme.primaryBlue,
      actionText: 'Generate Report',
      onAction: onGenerateReport,
    );
  }
}

/// Empty state for templates
class EmptyTemplatesWidget extends StatelessWidget {
  final VoidCallback? onCreateTemplate;

  const EmptyTemplatesWidget({
    super.key,
    this.onCreateTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Templates',
      subtitle:
          'Create workout templates to save time and maintain consistency across your programs.',
      icon: Icons.content_copy_outlined,
      iconColor: AppTheme.successGreen,
      actionText: 'Create Template',
      onAction: onCreateTemplate,
    );
  }
}

/// Empty state for exercises
class EmptyExercisesWidget extends StatelessWidget {
  final VoidCallback? onAddExercise;

  const EmptyExercisesWidget({
    super.key,
    this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Exercises',
      subtitle:
          'Add exercises to your library to create comprehensive workout plans.',
      icon: Icons.fitness_center_outlined,
      iconColor: AppTheme.primaryBlue,
      actionText: 'Add Exercise',
      onAction: onAddExercise,
    );
  }
}

/// Empty state for sessions
class EmptySessionsWidget extends StatelessWidget {
  final VoidCallback? onScheduleSession;

  const EmptySessionsWidget({
    super.key,
    this.onScheduleSession,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Sessions Scheduled',
      subtitle:
          'Schedule training sessions with your clients to provide personalized coaching.',
      icon: Icons.event_outlined,
      iconColor: AppTheme.warningOrange,
      actionText: 'Schedule Session',
      onAction: onScheduleSession,
    );
  }
}
