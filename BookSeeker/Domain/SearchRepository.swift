//
//  SearchRepository.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchBooks(
        query: String,
        page: Int
    ) async throws -> SearchResultDTO

    func fetchBookDetail(
        isbn13: String
    ) async throws -> BookDTO
}

final class SearchRepository: SearchRepositoryProtocol {
    private let apiService: APIService

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }

    func searchBooks(query: String, page: Int) async throws -> SearchResultDTO {
        let result = try await apiService.fetchSearchResult(query: query, page: page)
        return result
    }

    func fetchBookDetail(isbn13: String) async throws -> BookDTO {
        let result = try await apiService.fetchBookDetails(isbn13: isbn13)
        return result
    }
}
