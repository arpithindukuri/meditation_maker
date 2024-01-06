import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
import 'package:redux/redux.dart';

const audioBarHeight = 100.0;

class AppAudioBar extends StatelessWidget {
  const AppAudioBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Container(
          // clipBehavior: Clip.,
          height: audioBarHeight,
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 16),
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.stop_rounded),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.play_arrow_rounded),
                onPressed: store.state.editingProject == null
                    ? null
                    : () async {
                        store.dispatch(PlayProjectAction(
                            project: store.state.editingProject!));
                        // String ssml =
                        //     '<speak>There was an error synthesizing the audio.</speak>';

                        // // if play editing project, set ssml to editing project's ssml
                        // final project = store.state.editingProject;
                        // if (project != null) {
                        //   ssml = project.toSSMLString();
                        // }

                        // if (Firebase.apps.isNotEmpty) {
                        //   HttpsCallable callable =
                        //       FirebaseFunctions.instanceFor(
                        //               region: 'us-central1')
                        //           .httpsCallable('synthesize');

                        //   final response =
                        //       await callable(<String, dynamic>{'ssml': ssml});
                        //   final responseMap =
                        //       jsonDecode(response.data['jsonString']);
                        //   final responseAudioContent =
                        //       responseMap['audioContent']['data'];
                        //   final audioCache = String.fromCharCodes(
                        //     Uint8List.fromList(
                        //       (responseAudioContent as List<dynamic>)
                        //           .cast<int>(),
                        //     ),
                        //   );

                        //   store.dispatch(
                        //     SetAudioCacheAction(
                        //       audioCache: audioCache,
                        //     ),
                        //   );
                        // }
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}
