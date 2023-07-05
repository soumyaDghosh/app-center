import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '/l10n.dart';
import 'category_page.dart';

class GamesPage extends CategoryPage {
  const GamesPage({super.key}) : super(category: 'games');

  static IconData get icon => YaruIcons.send;
  static String label(BuildContext context) =>
      AppLocalizations.of(context).gamesPageLabel;
}