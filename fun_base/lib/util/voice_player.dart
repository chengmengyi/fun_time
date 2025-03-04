import 'package:audioplayers/audioplayers.dart';
import 'package:fun_base/util/storage_data.dart';

StorageData<bool> playBgStorage=StorageData(key: "playBgStorage", defaultValue: true);
StorageData<bool> playGkStorage=StorageData(key: "playGkStorage", defaultValue: true);

class VoicePlayer {
  factory VoicePlayer()=>_getInstance();
  static VoicePlayer get instance => _getInstance ();
  static VoicePlayer? _instance;
  static VoicePlayer _getInstance(){
    _instance??=VoicePlayer._internal();
    return _instance!;
  }

  final _bgAudioPlayer=AudioPlayer();
  final _voiceAudioPlayer=AudioPlayer();

  VoicePlayer._internal(){
    _voiceAudioPlayer.onPlayerStateChanged.listen((event) {
      if(playBgStorage.getData()){
        if(event==PlayerState.playing){
          _bgAudioPlayer.pause();
        }else if(event==PlayerState.completed){
          _bgAudioPlayer.resume();
        }
      }
    });
  }

  playBgMp3(){
    if(playBgStorage.getData()){
      _bgAudioPlayer.setReleaseMode(ReleaseMode.loop);
      _bgAudioPlayer.play(AssetSource("bg.MP3"));
    }
  }

  playVoiceMp3(){
    if(playGkStorage.getData()){
      _voiceAudioPlayer.play(AssetSource("GK.MP3"));
    }
  }

  setPlayOrStopBg(){
    if(playBgStorage.getData()){
      playBgStorage.saveData(false);
      _bgAudioPlayer.stop();
    }else{
      playBgStorage.saveData(true);
      playBgMp3();
    }
  }

  setPlayOrStopVoice(){
    playGkStorage.saveData(!playGkStorage.getData());
  }
}