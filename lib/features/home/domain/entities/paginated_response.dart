/// Model representing pagination metadata
class PaginationMeta {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const PaginationMeta({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  /// Create a PaginationMeta from JSON data
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}

/// Generic class for paginated responses
class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  const PaginatedResponse({required this.data, required this.meta});

  /// Create a PaginatedResponse from JSON data
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

/// Model for infinite pagination responses
class InfinitePaginationResponse<T> {
  final List<T> data;
  final bool hasNextPage;

  const InfinitePaginationResponse({
    required this.data,
    required this.hasNextPage,
  });

  /// Create an InfinitePaginationResponse from JSON data
  factory InfinitePaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return InfinitePaginationResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList(),
      hasNextPage: json['hasNextPage'] as bool,
    );
  }
}
