import 'dart:convert';
import 'package:uuid/uuid.dart';


class ThoughtChallenge {
  String id = const Uuid().v4();
  String negativeThought;
  List<String> evidenceFor;
  List<String> evidenceAgainst;
  String cognitiveReframingTechnique;
  String reframedThought;
  double progress;

  ThoughtChallenge({
    required this.id,
    required this.negativeThought,
    this.evidenceFor = const [],
    this.evidenceAgainst = const [],
    this.cognitiveReframingTechnique = '',
    this.reframedThought = '',
    this.progress = 0.0,
  });

  void updateProgress(double newProgress) {
    progress = newProgress;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'negativeThought': negativeThought,
      // Convert lists to a JSON string
      'evidenceFor': jsonEncode(evidenceFor),
      'evidenceAgainst': jsonEncode(evidenceAgainst),
      'cognitiveReframingTechnique': cognitiveReframingTechnique,
      'reframedThought': reframedThought,
      'progress': progress,
    };
  }

  factory ThoughtChallenge.fromJson(Map<String, dynamic> json) {
    return ThoughtChallenge(
      id: json['id'],
      negativeThought: json['negativeThought'],
      // Decode the JSON string back into a List<String>
      evidenceFor: jsonDecode(json['evidenceFor']).cast<String>(),
      evidenceAgainst: jsonDecode(json['evidenceAgainst']).cast<String>(),
      cognitiveReframingTechnique: json['cognitiveReframingTechnique'],
      reframedThought: json['reframedThought'],
      progress: json['progress'].toDouble(),
    );
  }
}
