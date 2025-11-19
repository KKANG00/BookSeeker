//
//  BookEntity.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

struct BookEntity {
    let title: String
    let subtitle: String
    let isbn13: String?
    let bookNumber13: String
    let price: String
    let imageURL: String?
    let url: String

    let authors: String
    let publisher: String
    let language: String
    let bookNumber10: String
    let pages: String
    let year: String
    let rating: String
    let description: String

    init(dto: BookDTO) {
        self.isbn13 = dto.isbn13

        let noInfo = "정보 없음"
        self.title = dto.title ?? ""
        self.subtitle = dto.subtitle ?? noInfo
        self.bookNumber13 = "no(13): \(dto.isbn13 ?? noInfo)"
        self.price = dto.price ?? ""
        self.imageURL = dto.image ?? ""
        self.url = dto.url ?? ""
        self.authors = "저자: \(dto.authors ?? noInfo)"
        self.publisher = "출판사: \(dto.publisher ?? noInfo)"
        self.language = "언어: \(dto.language ?? noInfo)"
        self.bookNumber10 = "no(10): \(dto.isbn10 ?? noInfo)"
        self.pages = "페이지: \(dto.pages ?? noInfo)"
        self.year = "출판년도: \(dto.year ?? noInfo)"
        self.rating = "별점: \(dto.rating ?? noInfo)"
        self.description = dto.desc ?? noInfo
    }
}
