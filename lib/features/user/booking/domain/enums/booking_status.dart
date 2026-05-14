enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  completed('completed'),
  rejected('rejected'),
  cancelled('cancelled'),
  expired('expired');

  final String value;
  const BookingStatus(this.value);

  static BookingStatus fromString(String status) {
    return BookingStatus.values.firstWhere(
      (e) => e.value == status.toLowerCase(),
      orElse: () => BookingStatus.pending,
    );
  }
}
