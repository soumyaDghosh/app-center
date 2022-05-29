import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapd/snapd.dart';
import 'package:software/pages/common/apps_model.dart';
import 'package:software/pages/common/snap_model.dart';
import 'package:software/pages/explore/app_banner.dart';
import 'package:software/pages/explore/app_dialog.dart';
import 'package:software/services/color_generator.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru_colors/yaru_colors.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class AppBannerCarousel extends StatelessWidget {
  const AppBannerCarousel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.watch<AppsModel>();
    final size = MediaQuery.of(context).size;
    return model.featuredSnaps.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: YaruCarousel(
              viewportFraction: 1,
              placeIndicator: false,
              autoScrollDuration: const Duration(seconds: 3),
              width: size.width,
              height: 178,
              autoScroll: true,
              children: [
                for (final snap in model.featuredSnaps)
                  _AppBannerCarouselItem.create(context, snap)
              ],
            ),
          )
        : const SizedBox();
  }
}

class _AppBannerCarouselItem extends StatefulWidget {
  const _AppBannerCarouselItem({
    Key? key,
    required this.snap,
  }) : super(key: key);

  final Snap snap;

  static Widget create(BuildContext context, Snap snap) {
    return ChangeNotifierProvider<SnapModel>(
      create: (_) => SnapModel(
        huskSnapName: snap.name,
        client: getService<SnapdClient>(),
        colorGenerator: getService<ColorGenerator>(),
      ),
      child: _AppBannerCarouselItem(snap: snap),
    );
  }

  @override
  State<_AppBannerCarouselItem> createState() => _AppBannerCarouselItemState();
}

class _AppBannerCarouselItemState extends State<_AppBannerCarouselItem> {
  @override
  void initState() {
    super.initState();
    context.read<SnapModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SnapModel>();
    return AppBanner(
      snap: widget.snap,
      surfaceTintColor: model.surfaceTintColor,
      onTap: () => showDialog(
        barrierColor: Theme.of(context).brightness == Brightness.light
            ? YaruColors.warmGrey.withOpacity(0.8)
            : Colors.black.withOpacity(0.7),
        context: context,
        builder: (context) => ChangeNotifierProvider.value(
          value: model,
          child: const AppDialog(),
        ),
      ),
    );
  }
}
