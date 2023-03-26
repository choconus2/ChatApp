import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
   const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeDefault = 60.0;
    return SizedBox(
      width: sizeDefault,
      height: sizeDefault,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: const Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcATop,
            ),
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          ),
        ),
      ),
    );
  }
}
