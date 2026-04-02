/// Maps room-lobby chip labels to [WordRepository] / words.json category ids.
const Map<String, String> kLobbyCategoryLabelToId = {
  'Traditional Food': 'food',
  'Heritage Sites': 'places',
  'Ethiopian Culture': 'culture',
  'Sports': 'sports',
};

String resolveCategoryIdFromLobby(List<String> selectedLabels) {
  if (selectedLabels.isEmpty) return 'food';
  for (final label in selectedLabels) {
    final id = kLobbyCategoryLabelToId[label];
    if (id != null) return id;
  }
  return 'food';
}
