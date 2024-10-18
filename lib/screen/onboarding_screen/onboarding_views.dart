import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:listtodo/screen/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding_items.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 300),
          child: TextButton(
              onPressed: () =>
                  pageController.jumpToPage(controller.items.length - 1),
              child: const Text(
                "Skip",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              )),
        ),
        //toolbarHeight: 100,
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 180),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: controller.items.length,
                      onDotClicked: (index) => pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeIn),
                      effect: const WormEffect(
                        dotHeight: 12,
                        dotWidth: 12,
                        activeDotColor: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: ElevatedButton(
                      onPressed: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeIn),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.black,
                      ),
                      child: const Icon(
                        Iconsax.arrow_right_3,
                        size: 30,
                        color: Colors.blue,
                        weight: 30,
                      ),
                    ),
                  )
                ],
              ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
            onPageChanged: (index) => setState(
                () => isLastPage = controller.items.length - 1 == index),
            itemCount: controller.items.length,
            controller: pageController,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    controller.items[index].image,
                    width: 300,
                    height: 250,
                  ),
                  // const SizedBox(height: 200),
                  Text(
                    controller.items[index].title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(controller.items[index].descriptions,
                      style: const TextStyle(color: Colors.grey, fontSize: 17),
                      textAlign: TextAlign.center),
                ],
              );
            }),
      ),
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
          onPressed: () async {
            final pres = await SharedPreferences.getInstance();
            pres.setBool("onboarding", true);

            if (!mounted) return;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          child: const Text(
            "Get started",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
