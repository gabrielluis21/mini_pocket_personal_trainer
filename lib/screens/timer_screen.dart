import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/user_exercises_data.dart';
import 'package:mini_pocket_personal_trainer/models/exercise_model.dart';
import 'package:mini_pocket_personal_trainer/painter/custom_timer_painter.dart';

class TimerScreen extends StatefulWidget {
  final UserExercises exercise;

  TimerScreen(this.exercise);

  @override
  _TimerScreenState createState() => _TimerScreenState(this.exercise);
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  final UserExercises exercise;

  _TimerScreenState(this.exercise);

  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: exercise.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: themeData.primaryColor,
                      height:
                          controller.value * MediaQuery.of(context).size.height,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.center,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: CustomTimerPainter(
                                      animation: controller,
                                      backgroundColor: Colors.white,
                                      color: themeData.indicatorColor,
                                    )),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          exercise.exerciseData.name,
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.amber),
                                        ),
                                        Text(
                                          timerString,
                                          style: TextStyle(
                                              fontSize: 112.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return FloatingActionButton.extended(
                                  onPressed: () {
                                    if (controller.isAnimating)
                                      controller.stop();
                                    else {
                                      controller
                                          .reverse(
                                              from: controller.value == 0.0
                                                  ? 1.0
                                                  : controller.value)
                                          .whenComplete(() {
                                        exercise.isDone = true;
                                        ExercisesModel.of(context)
                                            .updateExercise(exercise);
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  icon: Icon(controller.isAnimating
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  label: Text(controller.isAnimating
                                      ? "Pause"
                                      : "Play"));
                            }),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
