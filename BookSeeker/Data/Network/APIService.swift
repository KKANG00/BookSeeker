//
//  APIService.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case failedToDecode
    case networkError(Error)
    case serverError(statusCode: Int)

    var failMessage: String {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .noData:
            return "noData"
        case .failedToDecode:
            return "failedToDecode"
        case .networkError(let error):
            return "networkError: \(error)"
        case .serverError(let statusCode):
            return "serverError(\(statusCode))"
        }
    }
}

final class APIService: Sendable {
    static let shared: APIService = .init()

    private let baseURL = "https://api.itbook.store/1.0"

    func request<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        switch httpResponse.statusCode {
        case 200 ... 299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.failedToDecode
            }
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }

    private func encodingQuery(_ query: String) -> String {
        // enconding
        let processedQuery = query
            .trimmingCharacters(in: .whitespacesAndNewlines) // 앞뒤 공백 제거
            .replacingOccurrences(of: " ", with: "-") // 중간 공백 → 하이픈
        let encodedQuery = processedQuery
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

        return encodedQuery
    }

    func fetchSearchResult(query: String, page: Int = 1) async throws -> SearchResultDTO {
        let replacedQuery = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "-")
        let encodedQuery = replacedQuery
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "\(baseURL)/search/\(encodedQuery)/\(page)") else {
            throw NetworkError.invalidURL
        }
        return try await request(url: url)
    }

    func fetchBookDetails(isbn13: String) async throws -> BookDTO {
        guard let url = URL(string: "\(baseURL)/books/\(isbn13)") else {
            throw NetworkError.invalidURL
        }
        return try await request(url: url)
    }
}
