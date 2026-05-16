enum BookingTabType {
  upcoming('Upcoming'),
  completed('Completed'),
  cancelled('Cancelled');

  final String label;
  const BookingTabType(this.label);
}
