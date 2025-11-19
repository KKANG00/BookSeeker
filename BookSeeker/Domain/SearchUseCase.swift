//
//  SearchUseCaseImpl.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

protocol SearchUseCaseProtocol {
    func search(query: String, page: Int) async throws -> SearchResultEntity

    func bookDetail(isbn: String) async throws -> BookEntity
}

final class SearchUseCaseImpl: SearchUseCaseProtocol {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func search(query: String, page: Int) async throws -> SearchResultEntity {
        let dto = try await repository.searchBooks(query: query, page: page)

        return .init(dto: dto)
    }

    func bookDetail(isbn: String) async throws -> BookEntity {
        let dto = try await repository.fetchBookDetail(isbn13: isbn)

        return .init(dto: dto)
    }
}
