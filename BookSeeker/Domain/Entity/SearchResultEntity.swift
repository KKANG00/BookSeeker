//
//  SearchResultEntity.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

struct SearchResultEntity {
    let total: String
    let page: String?
    let books: [BookEntity]

    init(dto: SearchResultDTO) {
        self.total = dto.total ?? "0"
        self.page = dto.page
        self.books = dto.books.map {
            .init(dto: $0)
        }
    }
}
