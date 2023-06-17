import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/tab_controller_provider.dart';
import 'stickyheader.dart';

class FixedTabHeader extends ConsumerWidget {
  const FixedTabHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spotHeader = ref.watch(tabControllProvider).spotIndicesHeader;
    return Row(
      children: [
        Expanded(
            child: StickyHeader(
          data: spotHeader[0],
        )),
        Expanded(
            child: StickyHeader(
          data: spotHeader[1],
        )),
      ],
    );
  }
}
