import 'dart:async';
import 'dart:math';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/helpers/app_letters.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/features/game/presentation/widgets/category_input_card.dart';
import 'package:autobus_complete/src/features/game/presentation/widgets/game_top_bar.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_cubit.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameBoardScreen extends StatefulWidget {
  final String? targetLetter;
  final List<RoomCategoryEntity>? categories;
  final int? currentRound;
  final int? totalRounds;

  const GameBoardScreen({super.key, this.targetLetter, this.categories, this.currentRound, this.totalRounds});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  late Listenable _allControllers;

  String _currentLetter = '؟';
  bool _isShuffling = true;
  Timer? _shuffleTimer;

  @override
  void initState() {
    super.initState();
    final activeCategories = _getActiveCategories();
    for (final cat in activeCategories) {
      _controllers[cat.id] = TextEditingController();
      _focusNodes[cat.id] = FocusNode();
    }
    _allControllers = Listenable.merge(_controllers.values.toList());

    // Start shuffle animation after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLetterShuffle();
    });
  }

  List<RoomCategoryEntity> _getActiveCategories() {
    final raw = widget.categories ?? sl<RoomCubit>().currentRoom?.categories;
    return RoomCategoryEntity.getOrderedCategories(raw);
  }

  String? _getBackendTargetLetter() {
    if (widget.targetLetter != null && widget.targetLetter!.isNotEmpty) {
      return widget.targetLetter;
    }
    final room = sl<RoomCubit>().currentRoom;
    return room?.currentLetter;
  }

  int _getCurrentRound() {
    if (widget.currentRound != null) return widget.currentRound!;
    final room = sl<RoomCubit>().currentRoom;
    return room?.currentRound ?? 1;
  }

  int _getTotalRounds() {
    if (widget.totalRounds != null) return widget.totalRounds!;
    final room = sl<RoomCubit>().currentRoom;
    return room?.rounds ?? 5;
  }

  void _startLetterShuffle() {
    final letters = Localizations.localeOf(context).languageCode == 'ar'
        ? AppLetters.arabicLetters
        : AppLetters.englishLetters;
    final random = Random();

    var tickCount = 0;
    _shuffleTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      tickCount++;
      if (tickCount < 18) {
        setState(() {
          _currentLetter = letters[random.nextInt(letters.length)];
        });
      } else {
        _shuffleTimer?.cancel();
        final backendTargetLetter = _getBackendTargetLetter();
        final finalLetter = (backendTargetLetter != null && backendTargetLetter.isNotEmpty)
            ? backendTargetLetter
            : letters[random.nextInt(letters.length)];

        setState(() {
          _currentLetter = finalLetter;
          _isShuffling = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _shuffleTimer?.cancel();
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  bool _hasSubmitted = false;

  void _submitCurrentAnswers() {
    if (_hasSubmitted) return;
    _hasSubmitted = true;

    final answers = <String, String>{};
    _controllers.forEach((catId, controller) {
      answers[catId] = controller.text.trim();
    });
    unawaited(sl<RoomCubit>().submitRoundAnswers(answers));
  }

  void _onAutobusCompletePressed() {
    _submitCurrentAnswers();
    unawaited(Go.offNamed(NamedRoutes.scoring));
  }

  @override
  Widget build(BuildContext context) {
    final activeCategories = _getActiveCategories();

    return BlocProvider.value(
      value: sl<RoomCubit>(),
      child: BlocListener<RoomCubit, RoomState>(
        listener: (context, state) {
          final room = sl<RoomCubit>().currentRoom;
          if (room?.status == 'scoring') {
            _submitCurrentAnswers();
            unawaited(Go.offNamed(NamedRoutes.scoring));
          }
        },
        child: PopScope(
          canPop: false,
          child: AppScaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    // Top Bar with Rounds & Letter Shuffle (Synced from Firebase)
                    GameTopBar(
                      currentRound: _getCurrentRound(),
                      totalRounds: _getTotalRounds(),
                      letter: _currentLetter,
                      isShuffling: _isShuffling,
                    ),
                    16.szH,

                    // Host-Selected Category Input Cards
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: activeCategories.length,
                        itemBuilder: (context, index) {
                          final cat = activeCategories[index];
                          final isLast = index == activeCategories.length - 1;
                          return CategoryInputCard(
                            emoji: cat.icon,
                            categoryName: cat.getLocalizedName(context),
                            controller: _controllers[cat.id] ?? TextEditingController(),
                            focusNode: _focusNodes[cat.id],
                            textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
                          );
                        },
                      ),
                    ),
                    12.szH,

                    // STOP / AUTOBUS COMPLETE Button — rebuilds only when text changes
                    ListenableBuilder(
                      listenable: _allControllers,
                      builder: (context, _) {
                        final isButtonEnabled =
                            !_isShuffling &&
                            _controllers.isNotEmpty &&
                            _controllers.values.every((c) => c.text.trim().isNotEmpty);
                        return CustomButton(
                          text: S.of(context).autobusComplete,
                          onPressed: isButtonEnabled ? _onAutobusCompletePressed : null,
                        );
                      },
                    ),
                    12.szH,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
