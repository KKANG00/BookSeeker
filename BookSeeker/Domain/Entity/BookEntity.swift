//
//  BookEntity.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

struct BookEntity {
    let title: String
    let subtitle: String?
    let bookNumber13: String
    let price: String
    let imageURL: String
    let url: String

    let authors: String?
    let publisher: String?
    let language: String?
    let bookNumber10: String?
    let pages: String?
    let year: String?
    let rating: String?
    let description: String?

    init(dto: BookDTO) {
        self.title = dto.title ?? ""
        self.subtitle = dto.subtitle
        self.bookNumber13 = dto.isbn13 ?? ""
        self.price = dto.price ?? ""
        self.imageURL = dto.image ?? ""
        self.url = dto.url ?? ""
        self.authors = dto.authors
        self.publisher = dto.publisher
        self.language = dto.language
        self.bookNumber10 = dto.isbn10
        self.pages = dto.pages
        self.year = dto.year
        self.rating = dto.rating
        self.description = dto.desc
    }
}
