import 'package:fun_b/hep/storage/storage_name.dart';
import 'package:fun_base/util/storage_data.dart';

StorageData<bool> showLevelFinger=StorageData<bool>(key: StorageName.showLevelFinger, defaultValue: false);
StorageData<bool> firstGetReward=StorageData<bool>(key: StorageName.firstGetReward, defaultValue: true);


StorageData<int> boxCountTimer=StorageData<int>(key: StorageName.boxCountTimer, defaultValue: 0);
StorageData<int> boxLastTimeSecond=StorageData<int>(key: StorageName.boxLastTimeSecond, defaultValue: 0);
StorageData<int> selectedCashType=StorageData<int>(key: StorageName.selectedCashTypeB, defaultValue: 0);