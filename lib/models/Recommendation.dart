class Recommendation {
  final String? name, source, text;

  Recommendation({this.name, this.source, this.text});
}

final List<Recommendation> demo_recommendations = [
  Recommendation(
      name: "ADDITIONAL INFORMATION",
      source: "",
      text:
          "- I am a sociable person, able to communicate well. \n- I have an interest in technology, especially new technologies.\n- I am not afraid of difficulties, always try to find ways to solve difficult problems. \n- I always wanted to improve myself. \n- I was studious, easy to acquire new knowledge."),
  Recommendation(
      name: "OBJECTIVE",
      source: "Short term",
      text:
          " - I finding a software development job from Flutter so that I could give the experience of software creation \n- I will become a Senior developer with flutter . \n- I  giving the company some cable value that I can create."),
  Recommendation(
      name: "OBJECTIVE",
      source: "Long term",
      text:
          "- I having the knowledge sufficient to take myself on Freelance projects to implement. \n- I will become a Project manager . \n- I will become a lead to manager a team specializing in mobile software development"),
];
