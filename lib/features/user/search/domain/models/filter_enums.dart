enum RatingFilter {
  all('All', null),
  five('5', 5),
  four('4', 4),
  three('3', 3),
  two('2', 2);

  final String displayName;
  final int? minRating;

  const RatingFilter(this.displayName, this.minRating);
}

enum ExperienceFilter {
  any('Any', null, null),
  lessThanOne('<1 Year', 0, 1),
  oneToThree('1-3 Years', 1, 3),
  threeToFive('3-5 Years', 3, 5),
  fivePlus('5+ Years', 5, null);

  final String displayName;
  final int? minYears;
  final int? maxYears;

  const ExperienceFilter(this.displayName, this.minYears, this.maxYears);
}
