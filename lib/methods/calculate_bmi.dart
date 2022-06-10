String calculateBmi({
  required num heightInCm,
  required num weightInKg,
}) {
  final heightInMetres = heightInCm / 100;
  final result = weightInKg / (heightInMetres * heightInMetres);
  return result.toString();
}
