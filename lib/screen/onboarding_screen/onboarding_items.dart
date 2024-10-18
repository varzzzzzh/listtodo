import 'onboarding_info.dart';

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "Welcome to TaskMaster",
        descriptions:
            "Your personal assistant to manage and organize tasks efficiently.",
        image: "lib/assets/on_boarding_image/first.gif"),
    OnboardingInfo(
        title: "Stay Organized",
        descriptions:
            "Create, prioritize, and manage your tasks easily. Never miss a deadline again!",
        image: "lib/assets/on_boarding_image/second.gif"),
    OnboardingInfo(
        title: "Never Forget",
        descriptions:
            "Set reminders for important tasks and get notified to stay on track.",
        image: "lib/assets/on_boarding_image/third.gif"),
  ];
}
