import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/recipe.dart';
import '../../../app_state/providers.dart';

class SwipeDeckInline extends ConsumerStatefulWidget {
  final List<Recipe> recipes;
  final String tripId;
  final VoidCallback? onSwipeComplete;

  const SwipeDeckInline({
    super.key,
    required this.recipes,
    required this.tripId,
    this.onSwipeComplete,
  });

  @override
  ConsumerState<SwipeDeckInline> createState() => _SwipeDeckInlineState();
}

class _SwipeDeckInlineState extends ConsumerState<SwipeDeckInline>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    // Ensure current index is valid
    _currentIndex = 0;
    print('DEBUG: SwipeDeck initialized with ${widget.recipes.length} recipes');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingSuperlikes = _getRemainingSuperlikes();
    
    // Debug output
    if (_currentIndex >= widget.recipes.length && widget.recipes.isNotEmpty) {
      print('DEBUG: Current index $_currentIndex >= ${widget.recipes.length}, resetting to 0');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex = 0;
          });
        }
      });
    }
    
    if (widget.recipes.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                'Alle Rezepte bewertet!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 400,
      child: Stack(
        children: [
          // Recipe cards
          Positioned.fill(
            child: _buildRecipeCards(),
          ),
          
          // Overlay action buttons
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildActionButtons(remainingSuperlikes),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCards() {
    if (_currentIndex >= widget.recipes.length) {
      return const SizedBox.shrink();
    }

    final recipe = widget.recipes[_currentIndex];
    
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _isDragging = true;
          _dragOffset = Offset.zero;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
        });
      },
      onPanEnd: (details) {
        setState(() {
          _isDragging = false;
        });
        
        final velocity = details.velocity.pixelsPerSecond;
        final dragDistance = _dragOffset.dx;
        final dragDistanceY = _dragOffset.dy;
        
        // Determine swipe direction based on drag distance and velocity
        if (dragDistance.abs() > 100 || velocity.dx.abs() > 500) {
          if (dragDistance > 0 || velocity.dx > 0) {
            // Swipe right - like
            _handleSwipe(1);
          } else {
            // Swipe left - dislike
            _handleSwipe(-1);
          }
        } else if (dragDistanceY > 100 || velocity.dy > 500) {
          // Swipe down - veto
          _handleSwipe(-3);
        } else {
          // Return to center
          setState(() {
            _dragOffset = Offset.zero;
          });
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final currentOffset = _isDragging ? _dragOffset : Offset.zero;
          final rotation = currentOffset.dx * 0.1; // Rotation based on drag
          final scale = _isDragging ? 1.0 : _scaleAnimation.value;
          
          return Transform.translate(
            offset: currentOffset,
            child: Transform.rotate(
              angle: rotation * 3.14159 / 180, // Convert to radians
              child: Transform.scale(
                scale: scale,
                child: _buildRecipeCard(recipe),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(int remainingSuperlikes) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildModernVoteButton(
            Icons.block,
            Colors.black,
            -3,
            'Veto',
          ),
          _buildModernVoteButton(
            Icons.thumb_down,
            Colors.red,
            -1,
            'Dislike',
          ),
          _buildModernVoteButton(
            Icons.clear,
            Theme.of(context).colorScheme.outline,
            null,
            'Neutral',
          ),
          _buildModernVoteButton(
            Icons.thumb_up,
            Colors.green,
            1,
            'Gefällt mir',
          ),
          _buildModernVoteButton(
            Icons.favorite,
            remainingSuperlikes > 0 ? Colors.purple : Colors.grey,
            3,
            'Super-Like',
            remainingCount: remainingSuperlikes,
          ),
        ],
      ),
    );
  }

  Widget _buildModernVoteButton(
    IconData icon,
    Color color,
    int? vote,
    String tooltip, {
    int? remainingCount,
  }) {
    final isSuperlikeDisabled = vote == 3 && (remainingCount ?? 0) <= 0;
    
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          if (isSuperlikeDisabled) {
            _showNoSuperlikesDialog(context);
          } else {
            _handleSwipe(vote ?? 0);
          }
        },
        child: Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSuperlikeDisabled ? Colors.grey.withOpacity(0.3) : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSuperlikeDisabled ? Colors.grey : color,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  color: isSuperlikeDisabled ? Colors.grey : color,
                  size: 24,
                ),
              ),
              if (remainingCount != null && remainingCount > 0)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      remainingCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    // Get live vote counts for this recipe
    final recipeScore = ref.watch(recipeScoreInTripProvider((widget.tripId, recipe.id)));
    final swipes = ref.watch(tripSwipesProvider(widget.tripId));
    final recipeSwipes = swipes.where((s) => s.recipeId == recipe.id).toList();
    final likes = recipeSwipes.where((s) => s.vote > 0).length;
    final dislikes = recipeSwipes.where((s) => s.vote < 0).length;

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              // Header with image placeholder and live counters
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Recipe title overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                            child: Text(
                              recipe.title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.6),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Live vote counters overlay
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.thumb_up, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '$likes',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.thumb_down, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '$dislikes',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            Icons.people,
                            '${recipe.servingsBase} Portionen',
                          ),
                          _buildStatItem(
                            Icons.timer,
                            '${recipe.estPrepMin + recipe.estCookMin} min',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Tags
                      if (recipe.tags.isNotEmpty) ...[
                        Text(
                          'Kategorien',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: recipe.tags.take(3).map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                fontSize: 10,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Dietary info
                      if (recipe.satisfies.isNotEmpty) ...[
                        Text(
                          'Ernährung',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: recipe.satisfies.take(3).map((diet) {
                            return Chip(
                              label: Text(diet),
                              backgroundColor: Colors.green.withValues(alpha: 0.1),
                              labelStyle: const TextStyle(color: Colors.green, fontSize: 10),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Ingredients preview
                      Text(
                        'Zutaten',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.ingredients.take(3).map((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 6,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${ingredient.qty} ${ingredient.unit} ${ingredient.itemName}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (recipe.ingredients.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '... und ${recipe.ingredients.length - 3} weitere',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  int _getRemainingSuperlikes() {
    final currentUserId = ref.read(currentUserIdProvider);
    final swipes = ref.read(tripSwipesProvider(widget.tripId));
    final usedSuperlikes = swipes
        .where((swipe) => swipe.memberId == currentUserId && swipe.vote == 3)
        .length;
    return 2 - usedSuperlikes; // Limit of 2 superlikes per user
  }

  void _showNoSuperlikesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keine Super-Likes mehr verfügbar'),
        content: const Text(
          'Du hast bereits alle deine Super-Likes verwendet. '
          'Du kannst weiterhin normale Likes und Dislikes vergeben.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSwipe(int vote) async {
    if (_currentIndex < widget.recipes.length) {
      final recipe = widget.recipes[_currentIndex];
      final currentUserId = ref.read(currentUserIdProvider);
      
      try {
        // Check superlike limit
        if (vote == 3) {
          final remainingSuperlikes = _getRemainingSuperlikes();
          if (remainingSuperlikes <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Du hast bereits alle deine Super-Likes verwendet'),
              ),
            );
            return;
          }
        }

        // Add vote using TripVotesController
        ref.read(tripVotesControllerProvider.notifier).addVote(
          tripId: widget.tripId,
          recipeId: recipe.id,
          memberId: currentUserId,
          vote: vote,
        );
        
        // Vote submitted successfully - no more snackbar feedback
        
        // Animate card out
        await _animationController.forward();
        
        // Move to next recipe
        setState(() {
          _currentIndex++;
          _dragOffset = Offset.zero;
        });
        
        // Reset animation
        _animationController.reset();
        
        // Call completion callback if all recipes are swiped
        if (_currentIndex >= widget.recipes.length) {
          // Add a small delay to ensure the animation completes
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted && _currentIndex >= widget.recipes.length) {
            // Double-check that we're really done
            print('Swipe complete: $_currentIndex / ${widget.recipes.length}');
            widget.onSwipeComplete?.call();
          }
        }
      } catch (e) {
        // Don't advance to next recipe if swipe failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Bewerten: $e')),
        );
      }
    }
  }
}
