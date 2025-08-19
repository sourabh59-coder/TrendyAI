import 'dart:ui';

import 'package:dresti_frontend/src/fetcher/fetcher.dart';
import 'package:dresti_frontend/src/screens/expand_view_screen.dart';
import 'package:dresti_frontend/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gif/gif.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  String token;
  SearchScreen({super.key, required this.token});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  GifController? _controller;
  final TextEditingController _contentController = TextEditingController();
  bool showProgress = false;

  @override
  void initState() {
    _controller = GifController(vsync: this);
    super.initState();
  }

  @override
  dispose() {
    _controller!.dispose(); // you need this
    _contentController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> statusList = [
    {
      'text': 'Thinking',
      'opacity': 1.0,
      'fontSize': 'fontSize_16',
      'fontWeight': 'fontWeight_500',
    },
    {
      'text': 'Gathering Information',
      'opacity': 0.5,
      'fontSize': 'fontSize_18',
      'fontWeight': 'fontWeight_500',
    },
    {
      'text': 'Compiling',
      'opacity': 0.5,
      'fontSize': 'fontSize_16',
      'fontWeight': 'fontWeight_500',
    },
  ];

  // void _startAnimation() {
  //   int index = 0; // Track the current item to highlight
  //   Timer.periodic(Duration(seconds: 10), (timer) {
  //     if (showProgress) {
  //       setState(() {
  //         // Reset all items to low opacity and smaller font size
  //         for (var item in statusList) {
  //           item['opacity'] = 0.5;
  //           item['fontSize'] = 'fontSize_16';
  //         }

  //         // Highlight the current item
  //         final currentItem = statusList[index];
  //         currentItem['opacity'] = 1.0;
  //         currentItem['fontSize'] = 'fontSize_18';

  //         // Move to the next item
  //         index = (index + 1) % statusList.length; // Cycle through items
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              child: Transform.rotate(
                angle: 1.57,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Gif(
                    image:
                        const AssetImage("assets/gif/Rings Gradient Torus.gif"),
                    controller: _controller,
                    //fps: 30,
                    //duration: const Duration(seconds: 3),
                    autostart: Autostart.no,

                    onFetchCompleted: () {
                      _controller?.reset();
                      _controller?.forward();
                    },
                  ),
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(
              color: Color(0xff090909).withOpacity(0.6),
            ),
          ),
          Positioned(
            top: 126,
            child: Container(
              // color: Colors.red,
              width: 150,
              height: 62,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: 33,
                      height: 30,
                      color: Colors.white.withOpacity(0.1),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/sparkles.svg",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Dresstination AI",
                    style: Styles.customTextStyle(
                        'fontSize_18', 'fontWeight_600',
                        color: Color(0xffFFFFFF)),
                  )
                ],
              ),
            ),
          ),
          if (!showProgress)
            Positioned(
                top: 345,
                left: 26,
                child: Container(
                  height: 190,
                  width: 341,
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 30),
                  decoration: BoxDecoration(
                    border: const GradientBoxBorder(
                      gradient: LinearGradient(
                          colors: [Color(0xFF294DCB), Color(0xFF75084E)]),
                      width: 1,
                    ),

                    color: Colors.black
                        .withOpacity(0.6), // Background color with 60% opacity
                    borderRadius:
                        BorderRadius.circular(20.0), // Border radius of 20px
                  ),
                  child: TextField(
                    controller: _contentController,
                    autofocus: true,
                    cursorColor: const Color(0xfff0f0f7),
                    textAlign: TextAlign.center,

                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText:
                          'I am a young adult girl, give me suggestions for a cousin’s wedding taking place in cold weather of Switzerland',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0), // Padding inside the TextField
                    ),
                    style: Styles.customTextStyle(
                        'fontSize_22', 'fontWeight_600',
                        color: const Color(0xfff0f0f7)), // Text color
                  ),
                )),
          if (!showProgress)
            Positioned(
              top: 555,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(148, 54),
                  backgroundColor: Color(0xffF0F0F7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42),
                      side:
                          const BorderSide(width: 1, color: Color(0xff000000))),
                ),
                onPressed: () async {
                  final String inputContent = _contentController.text;

                  if (inputContent.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter your recommended fashion details!',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    setState(() {
                      showProgress = true;
                    });

                    // _startAnimation();
                    // SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();
                    // String? authToken = prefs.getString('authToken');
                    // print("Auth token: $authToken");

                    Fetcher fetcher = Fetcher();
                    String? outfitId =
                        await fetcher.getOutfitId(widget.token, inputContent);
                    if (outfitId != null) {
                      print('Outfit ID: $outfitId');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpandView(
                            token: widget.token,
                            outfitId: outfitId,
                          ),
                        ),
                      );
                    } else {
                      print('Failed to retrieve outfit ID');
                    }
                  }
                },
                child: Text(
                  "GENERATE",
                  style: Styles.customTextStyle(
                    'fontSize_16',
                    'fontWeight_600',
                  ),
                ),
              ),
            ),
          if (showProgress)
            Positioned(
              top: 611,
              child: Container(
                width: 230,
                height: 99,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: statusList.length,
                  itemBuilder: (context, index) {
                    final item = statusList[index];
                    return Opacity(
                      opacity: item['opacity'],
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            // SvgPicture.asset(item['image']),
                            SizedBox(
                                height: 20,
                                width: 20,
                                child: Lottie.asset(
                                    "assets/lottie/roundloader.json",
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.fill)),
                            const SizedBox(width: 13),
                            Text(
                              item['text'],
                              style: Styles.customTextStyle(
                                item['fontSize'],
                                item['fontWeight'],
                                color: const Color(0xfff0f0f7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    ));
  }
}
