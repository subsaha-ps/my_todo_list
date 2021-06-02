import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/screens/introduction/components/icloud_screen.dart';
import 'package:todo_app/screens/introduction/components/rich_text_widget.dart';
import 'package:todo_app/screens/introduction/components/signup_newsletter_screen.dart';
import 'package:todo_app/screens/introduction/components/slider_view.dart';
import 'package:todo_app/screens/introduction/components/welcome_screen.dart';
import 'package:todo_app/screens/task_list/tasks_screen.dart';
import 'package:todo_app/utilities/constant.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

//'Tap and Hold to pick an item up.\n\nDrag it up or down to change its priority.'
class _BodyState extends State<Body> {
  List<Map<String, dynamic>> introductionData = [
    {
      'text': RichTextWidget(
        text: 'Clear sorts items by',
        textStyle: kRichTextNormal,
        textSpanList: [
          {'text': ' priority\n\n', 'style': kRichTextBold},
          {
            'text': 'Important items are highlighted at the top....',
            'style': kRichTextNormal
          },
        ],
      ),
      'image': 'images/image1.png'
    },
    {
      'text': RichTextWidget(
        text: 'Tap and Hold',
        textStyle: kRichTextBold,
        textSpanList: [
          {'text': ' to pick an item up.\n\n', 'style': kRichTextNormal},
          {
            'text': 'Drag it up or down to change its priority.',
            'style': kRichTextNormal
          },
        ],
      ),
      'image': 'images/image2.png'
    },
    {
      'text': RichTextWidget(
          text: 'There are three navigation levels...',
          textStyle: kRichTextNormal),
      'image': 'images/image3.png'
    },
    {
      'text': RichTextWidget(
        text: 'Pinch together vertically',
        textStyle: kRichTextBold,
        textSpanList: [
          {
            'text': ' to collapse your current level and navigate up.',
            'style': kRichTextNormal
          },
        ],
      ),
      'image': 'images/image4.png'
    },
    //'Tap on a list to see its content.\n Tap on a list title to edit it....',
    {
      'text': RichTextWidget(
        text: 'Tap on a list',
        textStyle: kRichTextBold,
        textSpanList: [
          {'text': ' to see its content.\n', 'style': kRichTextNormal},
          {'text': 'Tap on a list', 'style': kRichTextBold},
          {'text': ' title to edit it....', 'style': kRichTextNormal},
        ],
      ),
      'image': 'images/image4.png'
    },
  ];

  int currentPage = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size contextSize = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            child: PageView.builder(
              controller: pageController,
              itemCount: kTotalPageNumber,
              itemBuilder: (context, index) {
                return showWidgetOnIndex(index);
              },
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
            ),
          ),
          Positioned(
            top: currentPage > 5
                ? contextSize.height * 0.95
                : contextSize.height * 0.45,
            child: currentPage > 0
                ? Container(
                    height: 20.0,
                    width: contextSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        kTotalPageNumber,
                        (index) => buildDot(index: index),
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget showWidgetOnIndex(int index) {
    switch (index) {
      case 0:
        return WelcomeScreen(onTapHandler: () {
          pageController.nextPage(
              duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
        });
      case 6:
        return ICloudScreen(
            notNowButtonPressed: notNowButtonPressed,
            iCloudButtonPressed: iCloudButtonPressed);
      case 7:
        return SignUpNewsLetterScreen(
            skipButtonPressed: skipButtonPressed,
            joinButtonPressed: joinNewsletterButtonPressed);

      default:
        return SliderView(
          textWidget: introductionData.elementAt(index - 1)['text']!,
          imagePath: introductionData.elementAt(index - 1)['image']!,
        );
    }
  }

  void showNextPage() {
    print('showNextPage');
    pageController.nextPage(
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  void notNowButtonPressed() {
    Navigator.pushNamed(context, TasksScreen.routeName);
  }

  void skipButtonPressed() {
    Navigator.pushNamed(context, TasksScreen.routeName);
  }

  void iCloudButtonPressed() {}
  void joinNewsletterButtonPressed() {}

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 6 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? kPageIndicatorDarkDotColor
            : kPageIndicatorLightDotColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

//
// Stack(
// children: <Widget>[
// // Max Size
// Container(
// child: PageView(
// children: [
//
// OnBoardingScreen(),
// ],
// ),
// ),
// Center(
// child: Container(
// color: Colors.pink,
// height: 30.0,
// width: MediaQuery.of(context).size.width,
// ),
// )
// ],
// ),
