enum DietType {
  omnivore('Alles', '🍖'),
  vegetarian('Vegetarisch', '🥬'),
  vegan('Vegan', '🌱'),
  pescetarian('Pescetarisch', '🐟');

  const DietType(this.displayName, this.emoji);
  final String displayName;
  final String emoji;

  static DietType fromString(String value) {
    return DietType.values.firstWhere(
      (diet) => diet.name == value,
      orElse: () => DietType.omnivore,
    );
  }
}

enum AllergyType {
  nuts('Nüsse', '🥜'),
  lactose('Laktose', '🥛'),
  gluten('Gluten', '🌾'),
  seafood('Meeresfrüchte', '🦐'),
  soy('Soja', '🫘'),
  eggs('Eier', '🥚'),
  fish('Fisch', '🐠'),
  peanuts('Erdnüsse', '🥜');

  const AllergyType(this.displayName, this.emoji);
  final String displayName;
  final String emoji;

  static AllergyType? fromString(String value) {
    try {
      return AllergyType.values.firstWhere(
        (allergy) => allergy.name == value,
      );
    } catch (e) {
      return null;
    }
  }
}

enum CuisineType {
  italian('Italienisch', '🍝'),
  mexican('Mexikanisch', '🌮'),
  asian('Asiatisch', '🍜'),
  mediterranean('Mediterran', '🫒'),
  indian('Indisch', '🍛'),
  french('Französisch', '🥖'),
  thai('Thai', '🍲'),
  japanese('Japanisch', '🍱'),
  greek('Griechisch', '🧀'),
  spanish('Spanisch', '🥘'),
  american('Amerikanisch', '🍔'),
  middleEastern('Mittelöstlich', '🥙');

  const CuisineType(this.displayName, this.emoji);
  final String displayName;
  final String emoji;

  static CuisineType? fromString(String value) {
    try {
      return CuisineType.values.firstWhere(
        (cuisine) => cuisine.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
