import 'package:flutter/material.dart';

class ProgressRail extends StatelessWidget {
  final int currentStep;
  final int maxStep;
  final bool vertical;
  final void Function(int)? onStepTap;

  const ProgressRail({
    super.key,
    required this.currentStep,
    this.maxStep = 3,
    this.vertical = false,
    this.onStepTap,
  });

  static const List<String> _stepLabels = [
    'Willkommen',
    'Ernährung',
    'Vorlieben',
    'Überprüfung',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return vertical ? _buildVerticalLayout(theme) : _buildHorizontalLayout(theme);
  }

  Widget _buildVerticalLayout(ThemeData theme) {
    return Column(
      children: List.generate(maxStep + 1, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildStepItem(theme, index),
        );
      }),
    );
  }

  Widget _buildHorizontalLayout(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(maxStep + 1, (index) {
        return Expanded(
          child: _buildStepItem(theme, index),
        );
      }),
    );
  }

  Widget _buildStepItem(ThemeData theme, int stepIndex) {
    final isCompleted = stepIndex < currentStep;
    final isCurrent = stepIndex == currentStep;
    final isFuture = stepIndex > currentStep;
    final canTap = stepIndex <= currentStep && onStepTap != null;

    return GestureDetector(
      onTap: canTap ? () => onStepTap!(stepIndex) : null,
      child: vertical ? _buildVerticalStep(theme, stepIndex, isCompleted, isCurrent, isFuture, canTap)
                     : _buildHorizontalStep(theme, stepIndex, isCompleted, isCurrent, isFuture, canTap),
    );
  }

  Widget _buildVerticalStep(ThemeData theme, int stepIndex, bool isCompleted, bool isCurrent, bool isFuture, bool canTap) {
    return Row(
      children: [
        _buildStepBubble(theme, stepIndex, isCompleted, isCurrent, isFuture),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            _stepLabels[stepIndex],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isCompleted || isCurrent 
                ? theme.colorScheme.primary 
                : theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalStep(ThemeData theme, int stepIndex, bool isCompleted, bool isCurrent, bool isFuture, bool canTap) {
    return Column(
      children: [
        _buildStepBubble(theme, stepIndex, isCompleted, isCurrent, isFuture),
        const SizedBox(height: 8),
        Text(
          _stepLabels[stepIndex],
          style: theme.textTheme.bodySmall?.copyWith(
            color: isCompleted || isCurrent 
              ? theme.colorScheme.primary 
              : theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepBubble(ThemeData theme, int stepIndex, bool isCompleted, bool isCurrent, bool isFuture) {
    const double bubbleSize = 32.0;
    
    if (isCompleted) {
      // Completed: filled circle + check
      return Container(
        width: bubbleSize,
        height: bubbleSize,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          color: theme.colorScheme.onPrimary,
          size: 20,
        ),
      );
    } else if (isCurrent) {
      // Current: colored circle with number
      return Container(
        width: bubbleSize,
        height: bubbleSize,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      // Future: outlined circle
      return Container(
        width: bubbleSize,
        height: bubbleSize,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
        ),
      );
    }
  }
}
