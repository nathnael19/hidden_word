/// Maps room-lobby chip labels to [WordRepository] / words.json category ids.
const Map<String, String> kLobbyCategoryLabelToId = {
  'Traditional Food': 'food',
  'Heritage Sites': 'places',
  'Ethiopian Culture': 'culture',
  'Sports': 'sports',
};

List<String> resolveCategoryIdsFromLobby(List<String> selectedLabels) {
  if (selectedLabels.isEmpty) return ['food'];
  final ids = selectedLabels
      .map((l) => kLobbyCategoryLabelToId[l])
      .whereType<String>()
      .toList();
  return ids.isEmpty ? ['food'] : ids;
}
