import 'package:adaptive_app/src/adaptive_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class Playlists extends StatelessWidget {
  const Playlists({super.key, required this.playlistSelected});

  final PlaylistsListSelected playlistSelected;

  @override
  Widget build(BuildContext context) {
    return Consumer<FlutterDevPlaylists>(
      builder: (context, flutterDev, child) {
        final playlists = flutterDev.playlists;
        if (playlists.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return _PlaylistsListView(
          items: playlists,
          playlistSelected: playlistSelected,
        );
      },
    );
  }
}

typedef PlaylistsListSelected = void Function(Playlist playlist);

class _PlaylistsListView extends StatefulWidget {
  const _PlaylistsListView({
    required this.items,
    required this.playlistSelected,
  });

  final List<Playlist> items;
  final PlaylistsListSelected playlistSelected;

  @override
  State<_PlaylistsListView> createState() => _PlaylistsListViewState();
}

class _PlaylistsListViewState extends State<_PlaylistsListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        var playlist = widget.items[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: AdaptiveImage.network(
              playlist.snippet!.thumbnails!.default_!.url!,
            ),
            title: Text(playlist.snippet!.title!),
            subtitle: Text(
              playlist.snippet!.description!,
            ),
            onTap: () {
              widget.playlistSelected(playlist);
            },
          ),
        );
      },
    );
  }
}

/**
 * There is a lot of change in this file. Apart from the aforementioned introduction of a playlistSelected callback, and the elimination of the Scaffold widget, the _PlaylistsListView widget is converted from stateless to stateful. This change is required due to the introduction of an owned ScrollController that has to be constructed and destroyed.

The introduction of a ScrollController is interesting because it is required because on a wide layout you have two ListView widgets side by side. On a mobile phone it is traditional to have a single ListView, and thus there can be a single long-lived ScrollController that all ListViews attach to, and detach from, during their individual life cycles. Desktop is different, in a world where multiple ListViews side by side make sense.
 */