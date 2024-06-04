import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:split_view/split_view.dart';

import 'playlist_details.dart';
import 'playlists.dart';

class AdaptivePlaylists extends StatelessWidget {
  const AdaptivePlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetPlatform = Theme.of(context).platform;

    if (targetPlatform == TargetPlatform.android ||
        targetPlatform == TargetPlatform.iOS ||
        screenWidth <= 600) {
      return const NarrowDisplayPlaylists();
    } else {
      return const WideDisplayPlaylists();
    }
  }
}

class NarrowDisplayPlaylists extends StatelessWidget {
  const NarrowDisplayPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlutterDev Playlists')),
      body: Playlists(
        playlistSelected: (playlist) {
          context.go(
            Uri(
              path: '/playlist/${playlist.id}',
              queryParameters: <String, String>{
                'title': playlist.snippet!.title!
              },
            ).toString(),
          );
        },
      ),
    );
  }
}

class WideDisplayPlaylists extends StatefulWidget {
  const WideDisplayPlaylists({super.key});

  @override
  State<WideDisplayPlaylists> createState() => _WideDisplayPlaylistsState();
}

class _WideDisplayPlaylistsState extends State<WideDisplayPlaylists> {
  Playlist? selectedPlaylist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: switch (selectedPlaylist?.snippet?.title) {
          String title => Text('FlutterDev Playlist: $title'),
          _ => const Text('FlutterDev Playlists'),
        },
      ),
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        children: [
          Playlists(playlistSelected: (playlist) {
            setState(() {
              selectedPlaylist = playlist;
            });
          }),
          switch ((selectedPlaylist?.id, selectedPlaylist?.snippet?.title)) {
            (String id, String title) =>
              PlaylistDetails(playlistId: id, playlistName: title),
            _ => const Center(child: Text('Select a playlist')),
          },
        ],
      ),
    );
  }
}

/**
 * This file is interesting for several reasons. First, it's using both the width of the window (using MediaQuery.of(context).size.width), and you are inspecting the theme (using Theme.of(context).platform) to decide whether to display a wide layout with the SplitView widget, or a narrow display without it.

Second, this section deals with the hard-coded handling of navigation. It surfaces a callback argument in the Playlists widget. That callback notifies the surrounding code that the user has selected a playlist. The code then needs to perform the work to display that playlist. This changes the need for the Scaffold in the Playlists and PlaylistDetails widgets. Now that they aren't top level, you must remove the Scaffold from those widgets.
 */
