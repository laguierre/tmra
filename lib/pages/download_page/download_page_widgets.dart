import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constants.dart';

class InfoLine extends StatelessWidget {
  const InfoLine({Key? key, required this.text, required this.boldText})
      : super(key: key);
  final String text, boldText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Text(text,
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              //fontSize: kFontSize - 2,
            )),
        Text(boldText,
            textScaleFactor: 1.0,
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                //fontSize: kFontSize - 2,

                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.receivedDataPercent,
    required this.receivedData,
    required this.totalData,
  });

  final double receivedDataPercent;
  final int receivedData;
  final int totalData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearPercentIndicator(
          padding: const EdgeInsets.all(0),
          animateFromLastPercent: true,
          barRadius: const Radius.circular(20),
          lineHeight: 15,
          percent: receivedDataPercent,
          backgroundColor: Colors.white,
          progressColor: Colors.yellowAccent,
        ),
        const SizedBox(height: 20),
        Text("Porcentaje: ${(receivedDataPercent * 100).toStringAsFixed(1)}%",
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text("Recibido: $receivedData / Total: $totalData",
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.function,
      required this.icon,
      required this.text,
      this.kPadding = 15})
      : super(key: key);

  final VoidCallback function;
  final String icon;
  final String text;
  final double kPadding;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.yellowAccent,
              borderRadius: BorderRadius.circular(15)),
          width: MediaQuery.of(context).size.width * 0.45 - kPadding,
          child: IconButton(
              onPressed: function,
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(icon, color: Colors.black),
                  const SizedBox(width: 10),
                  Expanded(
                    // child: AutoSizeText(text,
                    //     stepGranularity: 0.1,
                    //     maxLines: 1,
                    //     maxFontSize: 24,
                    //     minFontSize: 16,
                    //     style: const TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //     )),
                    child: Text(text,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              )),
        ),
      ],
    ));
  }
}

class CustomFieldText extends StatelessWidget {
  const CustomFieldText({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: TextField(
            textAlign: TextAlign.right,
            onChanged: (text) {},
            controller: textEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 20.sp,
                  color: Colors.grey, decoration: TextDecoration.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              isDense: true,
            ),
            style: TextStyle(
              fontSize: 24.sp,
              decoration: TextDecoration.none,
              color: Colors.black,
            )));
  }
}
