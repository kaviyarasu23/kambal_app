import 'package:flutter/material.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../shared_widget/snack_bar.dart';

class ShimmerLoadingPositions extends StatelessWidget {
  const ShimmerLoadingPositions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, i) => Divider(
              thickness: 1,
              height: 1,
            ),
        itemBuilder: (_, int i) => InkWell(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[350]!,
                highlightColor: Colors.grey[200]!,
                child: Column(
                  children: [
                    i == 0
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: sizes.pad_8,
                                          left: sizes.pad_20,
                                          right: sizes.pad_20),
                                      child: Container(
                                        height: 80,
                                        width: sizes.width,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sizes.pad_8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: sizes.text_16,
                                                width: 50,
                                                color: Colors.black45,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: sizes.text_16,
                                            width: 50,
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: horizontalDividerLine(true),
                              ),
                            ],
                          )
                        : SizedBox(),
                    Sizer(),
                    Container(
                      height: 80,
                      padding: EdgeInsets.all(sizes.pad_8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: sizes.text_16,
                                width: 100,
                                color: Colors.black45,
                              ),
                              Sizer.vertical10(),
                              Container(
                                  height: sizes.text_12,
                                  width: 50,
                                  color: Colors.black45),
                              Sizer.vertical10(),
                              Container(
                                  height: sizes.text_12,
                                  width: 80,
                                  color: Colors.black45)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: sizes.text_16,
                                  width: 60,
                                  color: Colors.black45),
                              Sizer.vertical10(),
                              Row(
                                children: [
                                  Container(
                                    height: sizes.text_12,
                                    width: 40,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                              Sizer.vertical10(),
                              Row(
                                children: [
                                  Container(
                                    height: sizes.text_12,
                                    width: 40,
                                    color: Colors.black45,
                                  ),
                                  Sizer.qtrHorizontal(),
                                  Container(
                                    height: sizes.text_12,
                                    width: 40,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        itemCount: 4);
  }
}
