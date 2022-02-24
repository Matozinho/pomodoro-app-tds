import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro/screens/widget/progress_icons.dart';
import 'package:pomodoro/screens/widget/custom_button.dart';
import 'package:pomodoro/model/pomodoro_status.dart';
import 'package:pomodoro/services/database_services.dart';
import 'package:pomodoro/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalDrawerKey;

  const HomeScreen({Key? key, required this.globalDrawerKey}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

const _btnTextStart = 'Iniciar Pomodoro';
const _btnTextResumePomodoro = 'Pausar Pomodoro';
const _btnTextResumeBreak = 'Pausar Descanso';
const _btnTextStartShortBreak = 'Iniciar Descanso Curto';
const _btnTextStartLongBreak = 'Iniciar Descanso Longo';
const _btnTextStartNewSet = 'Iniciar novo Set';
const _btnTextPause = 'Pausar';
const _btnTextReset = 'Resetar';

class _HomeState extends State<HomeScreen> {
  static AudioCache player = AudioCache();
  int remainingTime = pomodoroTotalTime;
  String mainBtnText = _btnTextStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer? _timer;
  int pomodoroNum = 0;
  int setNum = 0;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    player.load('bell.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Stack(
          children: [
            IconButton(
              onPressed: () {
                widget.globalDrawerKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'PomodoroApp',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 220.0,
                          lineWidth: 15.0,
                          percent: _getPomodoroPercentage(),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            _secondsToFormatedString(remainingTime),
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                          progressColor: statusColor[pomodoroStatus],
                        ),
                        const SizedBox(height: 10),
                        ProgressIcons(
                          total: pomodoroiPerSet,
                          done: pomodoroNum - (setNum * pomodoroiPerSet),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          onTap: _mainButtonPressed,
                          text: mainBtnText,
                        ),
                        CustomButton(
                          onTap: _resetButtonPressed,
                          text: _btnTextReset,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        pomodoroStatus = PomodoroStatus.pausedShortBreak;
        _pauseBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        pomodoroStatus = PomodoroStatus.pausedLongBreak;
        _pauseBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _getPomodoroPercentage() {
    int totalTime;

    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }

    return (totalTime - remainingTime) / totalTime;
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 0) {
        setState(() {
          remainingTime = remainingTime - 1;
          mainBtnText = _btnTextPause;
        });
      } else {
        _playSound();
        pomodoroNum = pomodoroNum + 1;
        _cancelTimer();
        DatabaseService().increaseTotalTime(pomodoroTotalTime);
        // TODO: make push to conquest screen if has a new Conquest
        await DatabaseService().validateTimeConquest();

        if (pomodoroNum % pomodoroiPerSet == 0) {
          pomodoroStatus = PomodoroStatus.pausedLongBreak;
          setState(() {
            remainingTime = longBreakTime;
            mainBtnText = _btnTextStartLongBreak;
          });
        } else {
          pomodoroStatus = PomodoroStatus.pausedShortBreak;
          setState(() {
            remainingTime = shortBreakTime;
            mainBtnText = _btnTextStartShortBreak;
          });
        }
      }
    });
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    _cancelTimer();

    setState(() {
      mainBtnText = _btnTextPause;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _playSound();
        remainingTime = pomodoroTotalTime;
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.pausedPomodoro;
        setState(() {
          mainBtnText = _btnTextStart;
        });
      }
    });
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    _cancelTimer();

    setState(() {
      mainBtnText = _btnTextPause;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _playSound();
        remainingTime = pomodoroTotalTime;
        _cancelTimer();
        pomodoroStatus = PomodoroStatus.setFinished;
        setState(() {
          mainBtnText = _btnTextStartNewSet;
        });
      }
    });
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumeBreak;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  _playSound() {
    player.play('bell.mp3');
  }
}
