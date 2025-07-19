/// Represents WebRTC offer data for signaling
class OfferData {
  final String sdp;
  final String type;
  final DateTime timestamp;

  const OfferData({
    required this.sdp,
    required this.type,
    required this.timestamp,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      sdp: json['sdp'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sdp': sdp,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Represents WebRTC answer data for signaling
class AnswerData {
  final String sdp;
  final String type;
  final DateTime timestamp;

  const AnswerData({
    required this.sdp,
    required this.type,
    required this.timestamp,
  });

  factory AnswerData.fromJson(Map<String, dynamic> json) {
    return AnswerData(
      sdp: json['sdp'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sdp': sdp,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Represents ICE candidate data for signaling
class IceCandidateModel {
  final String candidate;
  final String sdpMid;
  final int sdpMLineIndex;
  final DateTime timestamp;

  const IceCandidateModel({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
    required this.timestamp,
  });

  factory IceCandidateModel.fromJson(Map<String, dynamic> json) {
    return IceCandidateModel(
      candidate: json['candidate'] as String,
      sdpMid: json['sdpMid'] as String,
      sdpMLineIndex: json['sdpMLineIndex'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMLineIndex': sdpMLineIndex,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
