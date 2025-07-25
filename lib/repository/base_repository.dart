import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planora/utils/app_config.dart';

abstract class BaseRepository<T, ID> {
  final String boxName;
  final String collectionName;
  late final Box<T> _box;
  late final CollectionReference _collection;
  
  BaseRepository({
    required this.boxName,
    required this.collectionName,
  }) {
    _box = Hive.box<T>(boxName);
    _collection = FirebaseFirestore.instance.collection(collectionName);
  }
  
  T fromDocument(DocumentSnapshot doc);
  
  Map<String, dynamic> toMap(T item);
  
  ID getId(T item);
  
  Future<void> saveLocally(T item) async {
    await _box.put(getId(item).toString(), item);
  }
  
  Future<void> saveToCloud(T item) async {
    if (AppConfig.isCloudSyncEnabled) {
      try {
        await _collection.doc(getId(item).toString()).set(toMap(item));
      } catch (e) {
        debugPrint('Error saving to cloud: $e');
      }
    }
  }
  
  Future<void> save(T item) async {
    await saveLocally(item);
    await saveToCloud(item);
  }
  
  Future<T?> get(ID id) async {
    T? item = _box.get(id.toString());
    if (item == null && AppConfig.isCloudSyncEnabled) {
      try {
        final doc = await _collection.doc(id.toString()).get();
        if (doc.exists) {
          item = fromDocument(doc);
          await saveLocally(item as T);
        }
      } catch (e) {
        debugPrint('Error fetching from cloud: $e');
      }
    }
    
    return item;
  }
  
  Future<List<T>> getAll() async {
    final localItems = _box.values.toList();
    
    if (AppConfig.isCloudSyncEnabled) {
      try {
        final querySnapshot = await _collection.get();
        final cloudItems = querySnapshot.docs.map((doc) => fromDocument(doc)).toList();
        
        final mergedItems = <ID, T>{};
        
        for (var item in localItems) {
          mergedItems[getId(item)] = item;
        }
        
        for (var item in cloudItems) {
          mergedItems[getId(item)] = item;
        }
        
        return mergedItems.values.toList();
      } catch (e) {
        debugPrint('Error fetching all from cloud: $e');
      }
    }
    
    return localItems;
  }
  
  Future<void> delete(ID id) async {
    await _box.delete(id.toString());
    
    if (AppConfig.isCloudSyncEnabled) {
      try {
        await _collection.doc(id.toString()).delete();
      } catch (e) {
        debugPrint('Error deleting from cloud: $e');
      }
    }
  }
  
  Stream<List<T>> watchAll() {
    if (AppConfig.isCloudSyncEnabled) {
      return _collection.snapshots().asyncMap((snapshot) async {
        final cloudItems = snapshot.docs.map((doc) => fromDocument(doc)).toList();
        
        for (var item in cloudItems) {
          await saveLocally(item);
        }
        
        return cloudItems;
      });
    } else {
      return _box.watch().map((_) => _box.values.toList());
    }
  }
}
