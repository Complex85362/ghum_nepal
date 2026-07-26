class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String coverImageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.coverImageUrl,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': slug,
      'coverImageUrl': coverImageUrl,
    };
  }
}