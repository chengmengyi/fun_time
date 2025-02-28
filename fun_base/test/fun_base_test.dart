import 'package:flutter_test/flutter_test.dart';
import 'package:fun_base/fun_base.dart';
import 'package:fun_base/fun_base_platform_interface.dart';
import 'package:fun_base/fun_base_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFunBasePlatform
    with MockPlatformInterfaceMixin
    implements FunBasePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FunBasePlatform initialPlatform = FunBasePlatform.instance;

  test('$MethodChannelFunBase is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFunBase>());
  });

  test('getPlatformVersion', () async {
    FunBase funBasePlugin = FunBase();
    MockFunBasePlatform fakePlatform = MockFunBasePlatform();
    FunBasePlatform.instance = fakePlatform;

    expect(await funBasePlugin.getPlatformVersion(), '42');
  });
}
