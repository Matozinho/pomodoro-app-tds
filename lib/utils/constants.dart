import 'package:flutter/material.dart';
import 'package:pomodoro/model/pomodoro_status.dart';

const pomodoroTotalTime = 25 * 60;
const shortBreakTime = 5 * 60;
const longBreakTime = 15 * 60;

// const pomodoroTotalTime = 3;
// const shortBreakTime = 3;
// const longBreakTime = 6;

const pomodoroiPerSet = 4;


const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runningPomodoro: 'Pomodoro is running, time to be focused',
  PomodoroStatus.pausedPomodoro: 'Ready for a focused pomodoro?',
  PomodoroStatus.runningShortBreak: 'Short break running, time to relax',
  PomodoroStatus.pausedShortBreak: 'Let\'s have a short break?',
  PomodoroStatus.runningLongBreak: 'Long break running, time to relax',
  PomodoroStatus.pausedLongBreak: 'Let\'s have a long break?',
  PomodoroStatus.setFinished:
      'Congrats, you deserve a long break. Ready to start?'
};

const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runningPomodoro: Colors.green,
  PomodoroStatus.pausedPomodoro: Colors.orange,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak: Colors.orange,
  PomodoroStatus.runningLongBreak: Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.orange,
  PomodoroStatus.setFinished: Colors.orange,
};
