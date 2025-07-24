class Constants {
  static const List<String> eventStatus = [
    "upcoming",
    "ongoing",
    "completed",
    "missed",
    "cancelled",
  ];

  static const List<String> todoStatus = ["pending", "completed"];

  static const String greetingMorning = "Good Morning";
  static const String greetingAfternoon = "Good Afternoon";
  static const String greetingEvening = "Good Evening";

  static const Map<int, String> milestoneMessages = {
    0: "Get started with your plan for today!",
    1: "You’re off to a great start!",
    26: "You're making progress, keep it up!",
    50: "Halfway there, keep going!",
    75: "Almost there, just a little more!",
    100: "You’ve completed everything for today!",
  };

  static const List<String> repeatOptions = ["never", "daily", "weekly", "monthly", "yearly"];

  static const List<String> priority = ["Low", "Medium", "High"];
}
