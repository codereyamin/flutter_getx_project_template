class AppBrandData {
  final String name;
  final String image;
  final bool isSelected;

  AppBrandData({
    required this.name,
    required this.image,
    required this.isSelected,
  });

  AppBrandData copyWith({String? name, String? image, bool? isSelected}) {
    return AppBrandData(
      image: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      name: name ?? this.name,
    );
  }
}
