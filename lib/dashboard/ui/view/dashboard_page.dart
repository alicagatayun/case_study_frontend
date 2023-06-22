import 'dart:async';
import 'dart:developer';

import 'package:case_study_frontend/constants/api_endpoints.dart';
import 'package:case_study_frontend/constants/application_state.dart';
import 'package:case_study_frontend/constants/flutter_contstants.dart';
import 'package:case_study_frontend/dashboard/api/user_api.dart';
import 'package:case_study_frontend/dashboard/bloc/dashboard_bloc.dart';
import 'package:case_study_frontend/dashboard/repository/userstory_repository.dart';
import 'package:case_study_frontend/dashboard/story/bloc/story_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<DashboardBloc>(context).add(const GetUserRelationStories());
  }

  @override
  Widget build(BuildContext context) {
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
                              StorySplash.route(userRelations[index].story!.id),
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
                                      Endpoints.baseUrl + userRelations[index].user!.profilePhotoPath!,
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
  }
}

class StorySplash extends StatefulWidget {
  const StorySplash({super.key, required this.id});

  final String id;

  static Route<void> route(String id) {
    return MaterialPageRoute<void>(
        builder: (_) => StorySplash(
              id: id,
            ));
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

    _storyBloc.add(GetStoryDetailRequested(widget.id));

    _storyBloc.stream.listen((state) {
      if (state.loaderState == LoaderState.ready) {
        log("1 Kez Görmeliyiz.");

        const progressBarNewValueEvent = GetProgressBarNewValue(0);
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

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final bool showCircularProgress = true;
  bool startedPlaying = false;

  late VideoPlayerController _videoPlayerController;

  Future<bool> started() async {
    BlocProvider.of<StoryBloc>(context).add(const VideoLoading());

    await _videoPlayerController.initialize();
    await _videoPlayerController.play().then((value) {
      BlocProvider.of<StoryBloc>(context).add(const VideoLoaded());
    });

    startedPlaying = true;
    return true;
  }

  @override
  void dispose() {
    if (startedPlaying) _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener<StoryBloc, StoryState>(
          listener: (context, state) {
            if (state.loaderState == LoaderState.close) {
              if (startedPlaying) _videoPlayerController.dispose();
              Navigator.of(context).pop();
            }
            if (state.loaderState == LoaderState.stop) {
              if (startedPlaying) {
                _videoPlayerController.pause();
              }
            }
            if (state.loaderState == LoaderState.cont) {
              if (startedPlaying) {
                _videoPlayerController.play();
              }
            }
            if (state.loaderState == LoaderState.prev || state.loaderState == LoaderState.next) {
              if (startedPlaying) {
                startedPlaying = false;
                _videoPlayerController.dispose();
              }
            }
            BlocProvider.of<DashboardBloc>(context).add(const GetUserRelationStories());
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
                          BlocProvider.of<StoryBloc>(context).add(const PreviousStoryRequested());
                          log('Left Side Clicked');
                        } else {
                          BlocProvider.of<StoryBloc>(context).add(const NextStoryRequested());
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
                              if (state.storyDetail.isNotEmpty) {
                                if (state.storyDetail[state.currentIndex].isVideo!) {
                                  _videoPlayerController = VideoPlayerController.network(state.storyDetail[state.currentIndex].imagePath!);
                                  return FutureBuilder(
                                    future: started(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        // If the VideoPlayerController has finished initialization, use
                                        // the data it provides to limit the aspect ratio of the video.
                                        return VideoPlayer(_videoPlayerController);
                                      } else {
                                        // If the VideoPlayerController is still initializing, show a
                                        // loading spinner.
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return Image.network(
                                    Endpoints.baseUrl + state.storyDetail[state.currentIndex].imagePath!,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: double.infinity,
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
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
  bool shouldNextStoryBeShown = true;
  bool isVisible = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && shouldNextStoryBeShown) {
        log("Animation Completed for ${widget.progressBarIndex}");
        BlocProvider.of<StoryBloc>(context).add(const NextStoryRequested());
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
        shouldNextStoryBeShown = true;

        log("State is : ${state.loaderState}");

        log("Current Index: ${state.currentIndex}"
            "  Progress Bar Index Index: ${widget.progressBarIndex}");

        if (state.currentIndex != widget.progressBarIndex) {
          isVisible = true;
          controller.stop();
          if (state.loaderState == LoaderState.prev && state.currentIndex < widget.progressBarIndex) {
            controller.reset();
            controller.stop();
          }
          if (state.loaderState == LoaderState.next) {
            if (state.currentIndex > widget.progressBarIndex) {
              shouldNextStoryBeShown = false;
              controller.animateTo(1.0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
            }
          }
          if (state.loaderState == LoaderState.stop) {
            isVisible = false;
          }
          if (state.loaderState == LoaderState.cont) {
            isVisible = true;
          }
        } else {
          if (state.loaderState == LoaderState.stop) {
            isVisible = false;
            log("Controller Should Stop For This Index: ${widget.progressBarIndex}");
            controller.stop();
          } else if (state.loaderState == LoaderState.prev) {
            isVisible = true;

            controller.reset();
            controller.forward();
          } else if (state.loaderState == LoaderState.videoLoading) {
            isVisible = false;

            controller.duration = Duration(seconds: state.storyDetail[state.currentIndex].duration!);
            controller.stop();
          } else if (state.loaderState == LoaderState.videoLoaded) {
            isVisible = true;
            controller.forward();
          } else {
            isVisible = true;
            log("Controller should forwarded here");
            controller.forward();
          }
        }
      },
      child: BlocBuilder<StoryBloc, StoryState>(
        buildWhen: (prev, curr) => prev.loaderState != curr.loaderState,
        builder: (context, state) {
          if (state.currentIndex == widget.progressBarIndex && state.loaderState == LoaderState.ready) {
            controller.forward();
          }

          return AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: width,
                child: LinearProgressIndicator(
                  value: controller.value,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
