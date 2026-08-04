import 'dart:math';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/helpers/app_letters.dart';
import 'package:autobus_complete/src/features/room/data/models/room_model.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RoomRemoteDataSource {
  Future<List<RoomCategoryModel>> getCategories();
  Future<String> createRoom({required int rounds, required List<RoomCategoryEntity> categories});
  Future<void> joinRoom({required String roomCode});
  Stream<RoomModel?> listenToRoom({required String roomCode});
  Future<void> toggleReadyStatus({required String roomCode});
  Future<void> updateRoomSettings({
    required String roomCode,
    required int rounds,
    required List<RoomCategoryEntity> categories,
  });
  Future<void> startGame({required String roomCode});
  Future<void> startNextRound({required String roomCode});
  Future<void> submitRoundAnswers({required String roomCode, required Map<String, String> answers});
  Future<void> updateCategoryScore({
    required String roomCode,
    required String playerId,
    required String categoryId,
    required int score,
  });
  Future<void> endGame({required String roomCode});
  Future<void> playAgain({required String roomCode});
  Future<void> leaveRoom({required String roomCode});
  Future<void> makeHost({required String roomCode, required String newHostId});
  Future<void> kickPlayer({required String roomCode, required String playerId});
  Future<void> updatePlayerHeartbeat({required String roomCode});
  Future<void> cleanStalePlayers({required String roomCode, required int timeoutSeconds});
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  RoomRemoteDataSourceImpl({required this.firestore, required this.firebaseAuth});

  String _generateRandom6DigitCode() {
    final random = Random();
    final code = random.nextInt(900000) + 100000;
    return code.toString();
  }

  @override
  Future<List<RoomCategoryModel>> getCategories() async {
    try {
      final snapshot = await firestore.collection('categories').get();
      if (snapshot.docs.isNotEmpty) {
        final list = snapshot.docs.map((doc) => RoomCategoryModel.fromJson({'id': doc.id, ...doc.data()})).toList();
        final ordered = RoomCategoryEntity.getOrderedCategories(list);
        return ordered
            .map((e) => RoomCategoryModel(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn, icon: e.icon))
            .toList();
      }
    } on Object catch (_) {}

    final defaultCategories = RoomCategoryEntity.defaultCategories
        .map((e) => RoomCategoryModel(id: e.id, nameAr: e.nameAr, nameEn: e.nameEn, icon: e.icon))
        .toList();

    try {
      for (final c in defaultCategories) {
        await firestore.collection('categories').doc(c.id).set({
          'nameAr': c.nameAr,
          'nameEn': c.nameEn,
          'icon': c.icon,
        });
      }
    } on Object catch (_) {}

    return defaultCategories;
  }

  @override
  Future<String> createRoom({required int rounds, required List<RoomCategoryEntity> categories}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }

    var roomCode = _generateRandom6DigitCode();
    var docSnapshot = await firestore.collection('rooms').doc(roomCode).get();

    var attempts = 0;
    while (docSnapshot.exists && attempts < 10) {
      roomCode = _generateRandom6DigitCode();
      docSnapshot = await firestore.collection('rooms').doc(roomCode).get();
      attempts++;
    }

    // Fetch user profile from Firestore to get full name and photoUrl
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    final userName = (userData?['name'] as String?)?.isNotEmpty ?? false
        ? userData!['name'] as String
        : (user.displayName ?? 'Host');
    final userPhotoUrl = (userData != null && userData.containsKey('photoUrl'))
        ? userData['photoUrl'] as String?
        : user.photoURL;

    final categoryModels = categories.map(RoomCategoryModel.fromEntity).toList();

    final now = DateTime.now().millisecondsSinceEpoch;
    final hostPlayer = RoomPlayerModel(
      id: user.uid,
      name: userName,
      photoUrl: userPhotoUrl,
      isHost: true,
      isReady: true,
      lastSeen: now,
    );

    final roomModel = RoomModel(
      roomCode: roomCode,
      hostId: user.uid,
      status: 'waiting',
      rounds: rounds,
      currentRound: 1,
      categories: categoryModels,
      players: [hostPlayer],
    );

    final roomData = roomModel.toJson();
    roomData['lastSeenMap'] = {user.uid: now};

    await firestore.collection('rooms').doc(roomCode).set(roomData);

    return roomCode;
  }

  @override
  Future<void> joinRoom({required String roomCode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }

    final docRef = firestore.collection('rooms').doc(roomCode);
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    final userName = (userData?['name'] as String?)?.isNotEmpty ?? false
        ? userData!['name'] as String
        : (user.displayName ?? 'Player');
    final userPhotoUrl = (userData != null && userData.containsKey('photoUrl'))
        ? userData['photoUrl'] as String?
        : user.photoURL;

    final now = DateTime.now().millisecondsSinceEpoch;

    await firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        throw Exception('Room not found');
      }

      final room = RoomModel.fromJson(docSnapshot.data()!);
      if (room.status != 'waiting') {
        throw Exception('Game has already started');
      }

      final stalePlayerIds = <String>{};
      for (final p in room.players) {
        if (p.id != user.uid && p.lastSeen != null && (now - p.lastSeen!) > 10000) {
          stalePlayerIds.add(p.id);
        }
      }

      final activePlayers = room.players.where((p) => !stalePlayerIds.contains(p.id)).toList();

      if (activePlayers.isEmpty) {
        // All previous players were stale and dead! Reset room with joining user as Host
        final newHostPlayer = RoomPlayerModel(
          id: user.uid,
          name: userName,
          photoUrl: userPhotoUrl,
          isHost: true,
          isReady: true,
          lastSeen: now,
        );

        transaction.update(docRef, {
          'hostId': user.uid,
          'status': 'waiting',
          'players': [newHostPlayer.toJson()],
          'lastSeenMap': {user.uid: now},
        });
        return;
      }

      final existingPlayerIndex = activePlayers.indexWhere((p) => p.id == user.uid);
      if (existingPlayerIndex != -1) {
        final updatedPlayersList = activePlayers.map((p) {
          if (p.id == user.uid) {
            return RoomPlayerModel(
              id: p.id,
              name: userName,
              photoUrl: userPhotoUrl ?? p.photoUrl,
              isHost: p.isHost,
              isReady: p.isReady,
              score: p.score,
              lastSeen: p.lastSeen ?? now,
            );
          }
          return RoomPlayerModel.fromEntity(p);
        }).toList();

        final updateData = <String, dynamic>{
          'players': updatedPlayersList.map((p) => RoomPlayerModel.fromEntity(p).toJson()).toList(),
          'lastSeenMap.${user.uid}': now,
        };
        for (final staleId in stalePlayerIds) {
          updateData['lastSeenMap.$staleId'] = FieldValue.delete();
        }

        transaction.update(docRef, updateData);
        return;
      }

      if (activePlayers.length >= 12) {
        throw Exception(S.current.roomIsFull);
      }

      final newPlayer = RoomPlayerModel(
        id: user.uid,
        name: userName,
        photoUrl: userPhotoUrl,
        lastSeen: now,
      );

      final updatedPlayers = activePlayers
          .map(RoomPlayerModel.fromEntity)
          .toList()
        ..add(newPlayer);

      final updateData = <String, dynamic>{
        'players': updatedPlayers.map((p) => p.toJson()).toList(),
        'lastSeenMap.${user.uid}': now,
      };
      for (final staleId in stalePlayerIds) {
        updateData['lastSeenMap.$staleId'] = FieldValue.delete();
      }

      transaction.update(docRef, updateData);
    });
  }

  @override
  Stream<RoomModel?> listenToRoom({required String roomCode}) =>
      firestore.collection('rooms').doc(roomCode).snapshots().map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          return null;
        }
        return RoomModel.fromJson(snapshot.data()!);
      });

  @override
  Future<void> toggleReadyStatus({required String roomCode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection('rooms').doc(roomCode);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;

      final room = RoomModel.fromJson(snapshot.data()!);
      final updatedPlayers = room.players.map((p) {
        if (p.id == user.uid && !p.isHost) {
          return RoomPlayerModel(
            id: p.id,
            name: p.name,
            photoUrl: p.photoUrl,
            isHost: p.isHost,
            isReady: !p.isReady,
            score: p.score,
            lastSeen: p.lastSeen,
          );
        }
        return RoomPlayerModel.fromEntity(p);
      }).toList();

      transaction.update(docRef, {
        'players': updatedPlayers.map((p) => p.toJson()).toList(),
      });
    });
  }

  @override
  Future<void> updateRoomSettings({
    required String roomCode,
    required int rounds,
    required List<RoomCategoryEntity> categories,
  }) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    final categoryModels = categories.map(RoomCategoryModel.fromEntity).toList();

    await docRef.update({'rounds': rounds, 'categories': categoryModels.map((c) => c.toJson()).toList()});
  }

  @override
  Future<void> startGame({required String roomCode}) async {
    final arabicLetters = [
      'أ',
      'ب',
      'ت',
      'ث',
      'ج',
      'ح',
      'خ',
      'د',
      'ذ',
      'ر',
      'ز',
      'س',
      'ش',
      'ص',
      'ض',
      'ط',
      'ظ',
      'ع',
      'غ',
      'ف',
      'ق',
      'ك',
      'ل',
      'م',
      'ن',
      'هـ',
      'و',
      'ي',
    ];
    final randomLetter = (List<String>.from(arabicLetters)..shuffle()).first;

    await firestore.collection('rooms').doc(roomCode).update({
      'status': 'playing',
      'currentRound': 1,
      'currentLetter': randomLetter,
      'usedLetters': [randomLetter],
    });
  }

  @override
  Future<void> startNextRound({required String roomCode}) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() ?? {};
    final currentRound = (data['currentRound'] as int? ?? 1) + 1;
    final used = (data['usedLetters'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    final rawPlayers =
        (data['players'] as List<dynamic>?)?.map((p) => RoomPlayerModel.fromJson(p as Map<String, dynamic>)).toList() ??
        [];

    final rawAnswers = data['roundAnswers'] as Map<String, dynamic>? ?? {};
    final rawScores = data['roundScores'] as Map<String, dynamic>? ?? {};
    final categoriesList = (data['categories'] as List<dynamic>?) ?? [];

    // Accumulate points earned in the finished round to cumulative score
    final updatedPlayers = rawPlayers.map((player) {
      var roundEarned = 0;
      final playerAnswersMap = rawAnswers[player.id] as Map<String, dynamic>? ?? {};
      final playerScoresMap = rawScores[player.id] as Map<String, dynamic>? ?? {};

      for (final cat in categoriesList) {
        final catId = (cat is Map<String, dynamic>)
            ? cat['id'] as String?
            : (cat is RoomCategoryModel ? cat.id : cat.toString());
        if (catId == null) continue;

        final answer = (playerAnswersMap[catId] as String?) ?? '';
        if (answer.trim().isEmpty) {
          continue;
        }

        if (playerScoresMap.containsKey(catId)) {
          roundEarned += (playerScoresMap[catId] as num?)?.toInt() ?? 0;
        } else {
          roundEarned += 10;
        }
      }

      return RoomPlayerModel(
        id: player.id,
        name: player.name,
        photoUrl: player.photoUrl,
        isHost: player.isHost,
        isReady: player.isReady,
        score: player.score + roundEarned,
        lastSeen: player.lastSeen,
      );
    }).toList();

    final available = AppLetters.arabicLetters.where((l) => !used.contains(l)).toList();
    final nextLetter = available.isNotEmpty
        ? (List<String>.from(available)..shuffle()).first
        : (List<String>.from(AppLetters.arabicLetters)..shuffle()).first;

    final updatedUsed = List<String>.from(used)..add(nextLetter);

    await docRef.update({
      'status': 'playing',
      'currentRound': currentRound,
      'currentLetter': nextLetter,
      'usedLetters': updatedUsed,
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
      'roundAnswers': {},
      'roundScores': {},
    });
  }

  @override
  Future<void> submitRoundAnswers({required String roomCode, required Map<String, String> answers}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection('rooms').doc(roomCode);
    await docRef.update({'roundAnswers.${user.uid}': answers, 'status': 'scoring'});
  }

  @override
  Future<void> updateCategoryScore({
    required String roomCode,
    required String playerId,
    required String categoryId,
    required int score,
  }) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    await docRef.update({'roundScores.$playerId.$categoryId': score});
  }

  @override
  Future<void> endGame({required String roomCode}) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() ?? {};
    final rawPlayers =
        (data['players'] as List<dynamic>?)?.map((p) => RoomPlayerModel.fromJson(p as Map<String, dynamic>)).toList() ??
        [];

    final rawAnswers = data['roundAnswers'] as Map<String, dynamic>? ?? {};
    final rawScores = data['roundScores'] as Map<String, dynamic>? ?? {};
    final categoriesList = (data['categories'] as List<dynamic>?) ?? [];

    // Accumulate final round's scores to total cumulative score for each player
    final updatedPlayers = rawPlayers.map((player) {
      var roundEarned = 0;
      final playerAnswersMap = rawAnswers[player.id] as Map<String, dynamic>? ?? {};
      final playerScoresMap = rawScores[player.id] as Map<String, dynamic>? ?? {};

      for (final cat in categoriesList) {
        final catId = (cat is Map<String, dynamic>)
            ? cat['id'] as String?
            : (cat is RoomCategoryModel ? cat.id : cat.toString());
        if (catId == null) continue;

        final answer = (playerAnswersMap[catId] as String?) ?? '';
        if (answer.trim().isEmpty) {
          continue;
        }

        if (playerScoresMap.containsKey(catId)) {
          roundEarned += (playerScoresMap[catId] as num?)?.toInt() ?? 0;
        } else {
          roundEarned += 10;
        }
      }

      return RoomPlayerModel(
        id: player.id,
        name: player.name,
        photoUrl: player.photoUrl,
        isHost: player.isHost,
        isReady: player.isReady,
        score: player.score + roundEarned,
        lastSeen: player.lastSeen,
      );
    }).toList();

    await docRef.update({
      'status': 'finished',
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
      'roundAnswers': {},
      'roundScores': {},
    });
  }

  @override
  Future<void> playAgain({required String roomCode}) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() ?? {};
    final rawPlayers =
        (data['players'] as List<dynamic>?)?.map((p) => RoomPlayerModel.fromJson(p as Map<String, dynamic>)).toList() ??
        [];

    final resetPlayers = rawPlayers
        .map(
          (player) => RoomPlayerModel(
            id: player.id,
            name: player.name,
            photoUrl: player.photoUrl,
            isHost: player.isHost,
            isReady: player.isHost,
            lastSeen: player.lastSeen,
          ),
        )
        .toList();

    await docRef.update({
      'status': 'waiting',
      'currentRound': 1,
      'currentLetter': 'أ',
      'usedLetters': [],
      'players': resetPlayers.map((p) => p.toJson()).toList(),
      'roundAnswers': {},
      'roundScores': {},
    });
  }

  @override
  Future<void> leaveRoom({required String roomCode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection('rooms').doc(roomCode);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;

      final room = RoomModel.fromJson(snapshot.data()!);
      final remainingPlayers = room.players.where((p) => p.id != user.uid).toList();

      if (remainingPlayers.isEmpty) {
        transaction.delete(docRef);
        return;
      }

      // ponytail: simplified host transfer & game finish logic when players leave
      final isHostLeaving = room.hostId == user.uid;
      final newHost = isHostLeaving ? remainingPlayers.first : null;
      final updatedHostId = isHostLeaving ? newHost!.id : room.hostId;

      final updatedPlayers = remainingPlayers.map((p) {
        final isNewHost = p.id == updatedHostId;
        return RoomPlayerModel(
          id: p.id,
          name: p.name,
          photoUrl: p.photoUrl,
          isHost: isNewHost,
          isReady: isNewHost || p.isReady,
          score: p.score,
          lastSeen: p.lastSeen,
        );
      }).toList();

      final updateData = <String, dynamic>{
        'hostId': updatedHostId,
        'players': updatedPlayers.map((p) => p.toJson()).toList(),
        'lastSeenMap.${user.uid}': FieldValue.delete(),
      };

      if (remainingPlayers.length == 1 && (room.status == 'playing' || room.status == 'scoring')) {
        updateData['status'] = 'finished';
      }

      transaction.update(docRef, updateData);
    });
  }

  @override
  Future<void> makeHost({required String roomCode, required String newHostId}) async {
    final docRef = firestore.collection('rooms').doc(roomCode);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;

      final room = RoomModel.fromJson(snapshot.data()!);
      final updatedPlayers = room.players.map((p) {
        final isNewHost = p.id == newHostId;
        return RoomPlayerModel(
          id: p.id,
          name: p.name,
          photoUrl: p.photoUrl,
          isHost: isNewHost,
          isReady: isNewHost || p.isReady,
          score: p.score,
          lastSeen: p.lastSeen,
        );
      }).toList();

      transaction.update(docRef, {'hostId': newHostId, 'players': updatedPlayers.map((p) => p.toJson()).toList()});
    });
  }

  @override
  Future<void> kickPlayer({required String roomCode, required String playerId}) async {
    final docRef = firestore.collection('rooms').doc(roomCode);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;

      final room = RoomModel.fromJson(snapshot.data()!);
      final remainingPlayers = room.players.where((p) => p.id != playerId).toList();

      transaction.update(docRef, {
        'players': remainingPlayers.map((p) => RoomPlayerModel.fromEntity(p).toJson()).toList(),
        'lastSeenMap.$playerId': FieldValue.delete(),
      });
    });
  }

  @override
  Future<void> updatePlayerHeartbeat({required String roomCode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection('rooms').doc(roomCode);
    final now = DateTime.now().millisecondsSinceEpoch;

    await docRef.update({
      'lastSeenMap.${user.uid}': now,
    });
  }

  @override
  Future<void> cleanStalePlayers({required String roomCode, required int timeoutSeconds}) async {
    final docRef = firestore.collection('rooms').doc(roomCode);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;

      final room = RoomModel.fromJson(snapshot.data()!);
      final now = DateTime.now().millisecondsSinceEpoch;
      final timeoutMs = timeoutSeconds * 1000;

      final stalePlayerIds = <String>{};
      for (final p in room.players) {
        if (p.lastSeen != null && (now - p.lastSeen!) > timeoutMs) {
          stalePlayerIds.add(p.id);
        }
      }

      if (stalePlayerIds.isEmpty) return;

      final remainingPlayers = room.players.where((p) => !stalePlayerIds.contains(p.id)).toList();

      if (remainingPlayers.isEmpty) {
        transaction.delete(docRef);
        return;
      }

      final isHostStale = stalePlayerIds.contains(room.hostId);
      final updatedHostId = isHostStale ? remainingPlayers.first.id : room.hostId;

      final updatedPlayers = remainingPlayers.map((p) {
        final isNewHost = p.id == updatedHostId;
        return RoomPlayerModel(
          id: p.id,
          name: p.name,
          photoUrl: p.photoUrl,
          isHost: isNewHost,
          isReady: isNewHost || p.isReady,
          score: p.score,
          lastSeen: p.lastSeen,
        );
      }).toList();

      final updateData = <String, dynamic>{
        'hostId': updatedHostId,
        'players': updatedPlayers.map((p) => p.toJson()).toList(),
      };

      for (final staleId in stalePlayerIds) {
        updateData['lastSeenMap.$staleId'] = FieldValue.delete();
      }

      if (remainingPlayers.length == 1 && (room.status == 'playing' || room.status == 'scoring')) {
        updateData['status'] = 'finished';
      }

      transaction.update(docRef, updateData);
    });
  }
}
