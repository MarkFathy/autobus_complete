import 'dart:async';
import 'dart:math';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
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

  const GameBoardScreen({
    super.key,
    this.targetLetter,
    this.categories,
    this.currentRound,
    this.totalRounds,
  });

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  String _currentLetter = '؟';
  bool _isShuffling = true;
  Timer? _shuffleTimer;

  static const List<String> _arabicLetters = [
    'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش',
    'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'هـ', 'و', 'ي'
  ];

  static const List<String> _englishLetters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ];

  @override
  void initState() {
    super.initState();
    final activeCategories = _getActiveCategories();
    for (final cat in activeCategories) {
      _controllers[cat.id] = TextEditingController();
      _focusNodes[cat.id] = FocusNode();
    }

    // Start shuffle animation after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLetterShuffle();
    });
  }

  List<RoomCategoryEntity> _getActiveCategories() {
    if (widget.categories != null && widget.categories!.isNotEmpty) {
      return widget.categories!;
    }
    final room = sl<RoomCubit>().currentRoom;
    if (room != null && room.categories.isNotEmpty) {
      return room.categories;
    }
    return _defaultCategories;
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final letters = isArabic ? _arabicLetters : _englishLetters;
    final random = Random();
    final backendTargetLetter = _getBackendTargetLetter();

    int tickCount = 0;
    const maxTicks = 30; // ~2.4 seconds of shuffle (30 * 80ms)

    _shuffleTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      tickCount++;
      if (tickCount < maxTicks) {
        setState(() {
          _currentLetter = letters[random.nextInt(letters.length)];
        });
      } else {
        timer.cancel();
        // Land on exact target letter from Firebase Backend across all devices
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

  bool get _areAllFieldsFilled {
    if (_controllers.isEmpty) return false;
    return _controllers.values.every((c) => c.text.trim().isNotEmpty);
  }

  List<RoomCategoryEntity> get _defaultCategories => [
        const RoomCategoryEntity(id: 'boy',     nameAr: 'ولد',   nameEn: 'Boy',     icon: '👦'),
        const RoomCategoryEntity(id: 'girl',    nameAr: 'بنت',   nameEn: 'Girl',    icon: '👧'),
        const RoomCategoryEntity(id: 'object',  nameAr: 'جماد',  nameEn: 'Object',  icon: '📦'),
        const RoomCategoryEntity(id: 'plant',   nameAr: 'نبات',  nameEn: 'Plant',   icon: '🌿'),
        const RoomCategoryEntity(id: 'food',    nameAr: 'أكلة',  nameEn: 'Food',    icon: '🍔'),
        const RoomCategoryEntity(id: 'animal',  nameAr: 'حيوان', nameEn: 'Animal',  icon: '🦁'),
        const RoomCategoryEntity(id: 'country', nameAr: 'بلد',   nameEn: 'Country', icon: '🚩'),
      ];

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

    final Map<String, String> answers = {};
    _controllers.forEach((catId, controller) {
      answers[catId] = controller.text.trim();
    });
    sl<RoomCubit>().submitRoundAnswers(answers);
  }

  void _onAutobusCompletePressed() {
    _submitCurrentAnswers();
    Go.offNamed(NamedRoutes.scoring);
  }

  @override
  Widget build(BuildContext context) {
    final activeCategories = _getActiveCategories();
    final isButtonEnabled = !_isShuffling && _areAllFieldsFilled;

    return BlocProvider.value(
      value: sl<RoomCubit>(),
      child: BlocListener<RoomCubit, RoomState>(
        listener: (context, state) {
          final room = sl<RoomCubit>().currentRoom;
          if (room?.status == 'scoring') {
            _submitCurrentAnswers();
            Go.offNamed(NamedRoutes.scoring);
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
                          return CategoryInputCard(
                            emoji: cat.icon,
                            categoryName: cat.getLocalizedName(context),
                            controller: _controllers[cat.id] ?? TextEditingController(),
                            focusNode: _focusNodes[cat.id],
                            onChanged: (value) {
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    12.szH,

                    // STOP / AUTOBUS COMPLETE Button
                    CustomButton(
                      text: S.of(context).autobusComplete,
                      onPressed: isButtonEnabled ? _onAutobusCompletePressed : null,
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
