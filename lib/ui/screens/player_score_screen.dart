import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hangman/blocs/blocs.dart';
import 'package:hangman/blocs/event_state/event_state.dart';
import 'package:hangman/models/models.dart';
import 'package:hangman/ui/utils/pallette.dart';
import 'package:hangman/ui/utils/responsive.dart';
import 'package:hangman/ui/widgets/widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PlayerScoreScreen extends StatefulWidget {
  const PlayerScoreScreen({Key? key}) : super(key: key);

  @override
  _PlayerScoreScreenState createState() => _PlayerScoreScreenState();
}

class _PlayerScoreScreenState extends State<PlayerScoreScreen> {
  late PlayerScoreBloc _playerScoreBloc;
  late UserBloc _userBloc;
  final bool _isWeb = Responsive.getPlatform() == OS.web;
  final AutoScrollController _scrollController = AutoScrollController();
  final EdgeInsets _screenPadding = Responsive.getPlatform() == OS.android ||
          Responsive.getPlatform() == OS.ios
      ? const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 10.0, right: 10.0)
      : const EdgeInsets.all(30.0);
  double _toTopOpacity = 0.0;

  @override
  void initState() {
    _playerScoreBloc = BlocProvider.of<PlayerScoreBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    // fetch data from firebase database
    _playerScoreBloc.add(PlayerScoreFetch());

    // re-retrieve user data
    _userBloc.add(UserReRetrieveData());

    _scrollController.addListener(() {
      if (_scrollController.offset > 100) {
        setState(() => _toTopOpacity = 1.0);
      } else {
        setState(() => _toTopOpacity = 0.0);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _toScorePositionAction() {
    _scrollController.scrollToIndex(100);
  }

  void _toTop() {
    _scrollController.scrollToIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: _screenPadding,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 20.0),
              sliver: _buildHeader(),
            ),
            BlocBuilder<PlayerScoreBloc, PlayerScoreState>(
              builder: (context, state) {
                if (state is PlayerScoreFetchSuccess) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        User user = state.users[index];

                        return AutoScrollTag(
                          controller: _scrollController,
                          key: ValueKey(index),
                          index: index,
                          child: Padding(
                            padding: _isWeb
                                ? EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal:
                                        MediaQuery.of(context).size.width * 0.1,
                                  )
                                : const EdgeInsets.symmetric(vertical: 5.0),
                            child: InfoScoreBar(
                              rank: (index + 1).toString(),
                              user: user,
                            ),
                          ),
                        );
                      },
                      childCount: state.users.length,
                    ),
                  );
                }

                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _toTopOpacity,
        duration: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: _toTop,
          elevation: 15.0,
          backgroundColor: Pallette.buttonColor1,
          child: const Icon(
            Icons.expand_less,
            size: 40.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: BlocBuilder<PlayerScoreBloc, PlayerScoreState>(
        builder: (context, playerScoreState) {
          if (playerScoreState is PlayerScoreFetchSuccess) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserRetrieveData) {
                  // search user position
                  List<User> users = playerScoreState.users;
                  User user = state.user;
                  int pos = users.indexWhere((elm) => elm.id == user.id);

                  return Padding(
                    padding: _isWeb
                        ? EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                          )
                        : const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        const HeaderBar(label: 'Skor Pemain'),
                        Stack(
                          children: [
                            Column(
                              children: [
                                const Text('Tap untuk melihat posisi mu'),
                                const SizedBox(height: 7.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  height: 35.0,
                                  decoration: const BoxDecoration(
                                    color: Pallette.backgroundColor2,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(pos == -1
                                            ? '-'
                                            : (pos + 1).toString()),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          user.name,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          user.highScore.toString(),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _toScorePositionAction,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
