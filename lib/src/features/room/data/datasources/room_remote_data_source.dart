import 'dart:math';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/features/room/data/models/room_model.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RoomRemoteDataSource {
  Future<List<RoomCategoryModel>> getCategories();
  Future<String> createRoom({
    required int rounds,
    required List<RoomCategoryEntity> categories,
  });
  Future<void> joinRoom({required String roomCode});
  Stream<RoomModel?> listenToRoom({required String roomCode});
  Future<void> toggleReadyStatus({required String roomCode});
  Future<void> updateRoomSettings({
    required String roomCode,
    required int rounds,
    required List<RoomCategoryEntity> categories,
  });
  Future<void> startGame({required String roomCode});
  Future<void> leaveRoom({required String roomCode});
  Future<void> makeHost({
    required String roomCode,
    required String newHostId,
  });
  Future<void> kickPlayer({
    required String roomCode,
    required String playerId,
  });
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  RoomRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

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
        return snapshot.docs
            .map((doc) => RoomCategoryModel.fromJson({'id': doc.id, ...doc.data()}))
            .toList();
      }
    } catch (_) {}

    // Seed defaults into Firestore on first run
    const defaultCategories = [
      RoomCategoryModel(id: 'boy',     nameAr: 'ولد',   nameEn: 'Boy',     icon: '👦'),
      RoomCategoryModel(id: 'girl',    nameAr: 'بنت',   nameEn: 'Girl',    icon: '👧'),
      RoomCategoryModel(id: 'object',  nameAr: 'جماد',  nameEn: 'Object',  icon: '📦'),
      RoomCategoryModel(id: 'plant',   nameAr: 'نبات',  nameEn: 'Plant',   icon: '🌿'),
      RoomCategoryModel(id: 'food',    nameAr: 'أكلة',  nameEn: 'Food',    icon: '🍔'),
      RoomCategoryModel(id: 'animal',  nameAr: 'حيوان', nameEn: 'Animal',  icon: '🦁'),
      RoomCategoryModel(id: 'country', nameAr: 'بلد',   nameEn: 'Country', icon: '🚩'),
    ];

    try {
      for (final c in defaultCategories) {
        await firestore.collection('categories').doc(c.id).set({
          'nameAr': c.nameAr,
          'nameEn': c.nameEn,
          'icon': c.icon,
        });
      }
    } catch (_) {}

    return defaultCategories;
  }

  @override
  Future<String> createRoom({
    required int rounds,
    required List<RoomCategoryEntity> categories,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }

    String roomCode = _generateRandom6DigitCode();
    var docSnapshot = await firestore.collection('rooms').doc(roomCode).get();

    int attempts = 0;
    while (docSnapshot.exists && attempts < 10) {
      roomCode = _generateRandom6DigitCode();
      docSnapshot = await firestore.collection('rooms').doc(roomCode).get();
      attempts++;
    }

    // Fetch user profile from Firestore to get full name and photoUrl
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    final userName = (userData?['name'] as String?)?.isNotEmpty == true
        ? userData!['name'] as String
        : (user.displayName ?? 'Host');
    final userPhotoUrl = userData?['photoUrl'] as String? ?? user.photoURL;

    final categoryModels = categories
        .map((c) => RoomCategoryModel.fromEntity(c))
        .toList();

    final hostPlayer = RoomPlayerModel(
      id: user.uid,
      name: userName,
      photoUrl: userPhotoUrl,
      isHost: true,
      isReady: true,
      score: 0,
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

    await firestore
        .collection('rooms')
        .doc(roomCode)
        .set(roomModel.toJson());

    return roomCode;
  }

  @override
  Future<void> joinRoom({required String roomCode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }

    final docRef = firestore.collection('rooms').doc(roomCode);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception("Room not found");
    }

    final room = RoomModel.fromJson(docSnapshot.data()!);
    if (room.status != 'waiting') {
      throw Exception("Game has already started");
    }

    // Fetch user profile from Firestore to get full name and photoUrl
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    final userName = (userData?['name'] as String?)?.isNotEmpty == true
        ? userData!['name'] as String
        : (user.displayName ?? 'Player');
    final userPhotoUrl = userData?['photoUrl'] as String? ?? user.photoURL;

    final existingPlayerIndex = room.players.indexWhere((p) => p.id == user.uid);
    if (existingPlayerIndex != -1) {
      // Update existing player's photoUrl or name if it changed
      final updatedPlayersList = room.players.map((p) {
        if (p.id == user.uid) {
          return RoomPlayerModel(
            id: p.id,
            name: userName,
            photoUrl: userPhotoUrl ?? p.photoUrl,
            isHost: p.isHost,
            isReady: p.isReady,
            score: p.score,
          );
        }
        return p;
      }).toList();

      await docRef.update({
        'players': updatedPlayersList
            .map((p) => RoomPlayerModel.fromEntity(p).toJson())
            .toList(),
      });
      return;
    }

    if (room.players.length >= 6) {
      throw Exception("Room is full");
    }

    final newPlayer = RoomPlayerModel(
      id: user.uid,
      name: userName,
      photoUrl: userPhotoUrl,
      isHost: false,
      isReady: false,
      score: 0,
    );

    final updatedPlayers = List<RoomPlayerModel>.from(
      room.players.map((p) => RoomPlayerModel.fromJson({
            'id': p.id,
            'name': p.name,
            'photoUrl': p.photoUrl,
            'isHost': p.isHost,
            'isReady': p.isReady,
            'score': p.score,
          })),
    )..add(newPlayer);

    await docRef.update({
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
    });
  }

  @override
  Stream<RoomModel?> listenToRoom({required String roomCode}) {
    return firestore
        .collection('rooms')
        .doc(roomCode)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return RoomModel.fromJson(snapshot.data()!);
    });
  }

  @override
  Future<void> toggleReadyStatus({required String roomCode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection('rooms').doc(roomCode);
    final snapshot = await docRef.get();
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
        );
      }
      return RoomPlayerModel(
        id: p.id,
        name: p.name,
        photoUrl: p.photoUrl,
        isHost: p.isHost,
        isReady: p.isReady,
        score: p.score,
      );
    }).toList();

    await docRef.update({
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
    });
  }

  @override
  Future<void> updateRoomSettings({
    required String roomCode,
    required int rounds,
    required List<RoomCategoryEntity> categories,
  }) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    final categoryModels =
        categories.map((c) => RoomCategoryModel.fromEntity(c)).toList();

    await docRef.update({
      'rounds': rounds,
      'categories': categoryModels.map((c) => c.toJson()).toList(),
    });
  }

  @override
  Future<void> startGame({required String roomCode}) async {
    final arabicLetters = [
      'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش',
      'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'هـ', 'و', 'ي'
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
  Future<void> leaveRoom({required String roomCode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final docRef = firestore.collection('rooms').doc(roomCode);
    final snapshot = await docRef.get();
    if (!snapshot.exists || snapshot.data() == null) return;

    final room = RoomModel.fromJson(snapshot.data()!);
    final remainingPlayers =
        room.players.where((p) => p.id != user.uid).toList();

    if (remainingPlayers.isEmpty) {
      await docRef.delete();
    } else if (room.hostId == user.uid) {
      // Exiting user was the Host -> Transfer Host to the first remaining player!
      final newHost = remainingPlayers.first;
      final updatedPlayers = remainingPlayers.map((p) {
        final isNewHost = p.id == newHost.id;
        return RoomPlayerModel(
          id: p.id,
          name: p.name,
          photoUrl: p.photoUrl,
          isHost: isNewHost,
          isReady: isNewHost ? true : p.isReady,
          score: p.score,
        );
      }).toList();

      await docRef.update({
        'hostId': newHost.id,
        'players': updatedPlayers.map((p) => p.toJson()).toList(),
      });
    } else {
      await docRef.update({
        'players': remainingPlayers
            .map((p) => RoomPlayerModel.fromEntity(p).toJson())
            .toList(),
      });
    }
  }

  @override
  Future<void> makeHost({
    required String roomCode,
    required String newHostId,
  }) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    final snapshot = await docRef.get();
    if (!snapshot.exists || snapshot.data() == null) return;

    final room = RoomModel.fromJson(snapshot.data()!);
    final updatedPlayers = room.players.map((p) {
      final isNewHost = p.id == newHostId;
      return RoomPlayerModel(
        id: p.id,
        name: p.name,
        photoUrl: p.photoUrl,
        isHost: isNewHost,
        isReady: isNewHost ? true : p.isReady,
        score: p.score,
      );
    }).toList();

    await docRef.update({
      'hostId': newHostId,
      'players': updatedPlayers.map((p) => p.toJson()).toList(),
    });
  }

  @override
  Future<void> kickPlayer({
    required String roomCode,
    required String playerId,
  }) async {
    final docRef = firestore.collection('rooms').doc(roomCode);
    final snapshot = await docRef.get();
    if (!snapshot.exists || snapshot.data() == null) return;

    final room = RoomModel.fromJson(snapshot.data()!);
    final remainingPlayers =
        room.players.where((p) => p.id != playerId).toList();

    await docRef.update({
      'players': remainingPlayers
          .map((p) => RoomPlayerModel.fromEntity(p).toJson())
          .toList(),
    });
  }
}
