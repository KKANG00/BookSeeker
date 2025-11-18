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

    func request<T>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
        where T: Decodable {
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let error {
                completion(.failure(NetworkError.invalidURL))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data else {
                completion(.failure(NetworkError.noData))
                return
            }

            switch httpResponse.statusCode {
            case 200 ... 299:
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(NetworkError.failedToDecode))
                }
            default: completion(.failure(NetworkError
                        .serverError(statusCode: httpResponse.statusCode)
                ))
            }
        }

        task.resume()
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

    func fetchSearchResult(
        query: String,
        page: Int = 1,
        completion: @escaping (Result<SearchResponse, Error>) -> Void
    ) {
        let encodedQuery = encodingQuery(query)
        guard let url = URL(string: "\(baseURL)/search/\(encodedQuery)/\(page)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        request(url: url) { (result: Result<SearchResponse, Error>) in
            completion(result)
        }
    }

    func fetchBookDetails(
        isbn13: String,
        completion: @escaping (Result<BookResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/books/\(isbn13)") else {
            // invalidURL
            return
        }

        request(url: url) { (result: Result<BookResponse, Error>) in
            completion(result)
        }
    }
}
