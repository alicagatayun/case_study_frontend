import 'dart:async';
import 'dart:developer';

import 'package:case_study_frontend/constants/application_state.dart';
import 'package:case_study_frontend/constants/flutter_contstants.dart';
import 'package:case_study_frontend/dashboard/api/user_api.dart';
import 'package:case_study_frontend/dashboard/bloc/dashboard_bloc.dart';
import 'package:case_study_frontend/dashboard/repository/userstory_repository.dart';
import 'package:case_study_frontend/dashboard/story/bloc/story_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<DashboardBloc>(context).add(const GetUserRelationStories());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                const Text(
                  "Instagram",
                  style: TextStyle(color: Colors.black),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.heart_broken,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.message,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  buildWhen: (prev, curr) => prev.applicationState != curr.applicationState,
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.userRelations.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var userRelations = state.userRelations;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                log('Story Clicked');

                                Navigator.of(context).push(
                                  StorySplash.route(),
                                );
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
                                  child: Container(
                                    decoration: userRelations[index].allSeen!
                                        ? null
                                        : BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.pink,
                                              width: 2,
                                            ),
                                          ),
                                    child: CircleAvatar(
                                      radius: 32,
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://loremflickr.com/320/240',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(userRelations[index].user!.name.toString()),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              const Expanded(
                flex: 6,
                child: Center(child: Text("TODO: Fill the place with dummy data, later.")),
              )
            ],
          ),
        );
      },
    );
  }
}

class StorySplash extends StatefulWidget {
  const StorySplash({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const StorySplash());
  }

  @override
  State<StorySplash> createState() => _StorySplashState();
}

class _StorySplashState extends State<StorySplash> {
  late StoryBloc _storyBloc;

  @override
  void initState() {
    super.initState();
    _initializeStoryBloc();
  }

  Future<void> _initializeStoryBloc() async {
    _storyBloc = StoryBloc(
      userStoryRepository: UserStoryRepository(
        UserStoryApi(),
      ),
    );

    _storyBloc.add(GetStoryDetailRequested(''));

    _storyBloc.stream.listen((state) {
      if (state is StoryState) {
        final progressBarNewValueEvent = GetProgressBarNewValue(0);
        _storyBloc.add(progressBarNewValueEvent);
      }
    });
  }

  @override
  void dispose() {
    _storyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryBloc>.value(
      value: _storyBloc,
      child: const StoryView(),
    );
  }
}

class StoryView extends StatelessWidget {
  const StoryView({super.key});

  final bool showCircularProgress = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener<StoryBloc, StoryState>(
          listener: (context, state) {
            if (state.loaderState == LoaderState.close) {
              Navigator.of(context).pop();
            }
            if (state.loaderState == LoaderState.stop) {}
          },
          child: BlocBuilder<StoryBloc, StoryState>(
            buildWhen: (prev, curr) => prev.applicationState != curr.applicationState,
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                textDirection: TextDirection.rtl,
                fit: StackFit.loose,
                clipBehavior: Clip.hardEdge,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double tapPositionX = details.globalPosition.dx;

                        if (tapPositionX < screenWidth / 2) {
                          log('Left side clicked');
                        } else {
                          log('Right side clicked');
                        }
                      },
                      onLongPress: () {
                        BlocProvider.of<StoryBloc>(context).add(const StopStoryRequested());
                      },
                      onLongPressEnd: (_) {
                        BlocProvider.of<StoryBloc>(context).add(const ContinueStoryRequested());
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: BlocBuilder<StoryBloc, StoryState>(
                            buildWhen: (prev, curr) => prev.currentIndex != curr.currentIndex,
                            builder: (context, state) {
                              return state.storyDetail.isNotEmpty
                                  ? Image.asset(
                                      state.storyDetail[state.currentIndex].imagePath!,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : const CircularProgressIndicator();
                            },
                          )),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    right: 10,
                    child: SizedBox(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 4),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.progressBarList.length,
                          itemBuilder: (context, progressBarIndex) {
                            return CustomLinearProgressIndicator(
                              progressBarIndex: progressBarIndex,
                              count: state.progressBarList.length,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("TODO: Fix"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomLinearProgressIndicator extends StatefulWidget {
  const CustomLinearProgressIndicator({
    required this.progressBarIndex,
    required this.count,
    super.key,
  });

  final int progressBarIndex;
  final int count;

  @override
  State<CustomLinearProgressIndicator> createState() => _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState extends State<CustomLinearProgressIndicator> with TickerProviderStateMixin {
  late AnimationController controller;
  bool shouldStop = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        BlocProvider.of<StoryBloc>(context).add(NextStoryRequested(widget.progressBarIndex));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - widget.count * 8 - 12;
    width /= widget.count;
    return BlocListener<StoryBloc, StoryState>(
      listener: (context, state) {
        if (state.loaderState == LoaderState.stop) {
          controller.stop();
          shouldStop = true;
        }
        if (state.loaderState == LoaderState.cont) {
          shouldStop = false;
        }
      },
      child: BlocBuilder<StoryBloc, StoryState>(
        buildWhen: (prev, curr) => prev.loaderState != curr.loaderState,
        builder: (context, state) {
          if (state.progressBarList[widget.progressBarIndex] == true && !shouldStop) {
            controller.forward();
          } else {
            controller.stop();
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: width,
              child: LinearProgressIndicator(
                value: controller.value,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
