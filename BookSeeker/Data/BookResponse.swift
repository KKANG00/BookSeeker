//
//  BookResponse.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

import Foundation

struct BookDTO: Decodable {
    let title: String?
    let subtitle: String?
    let isbn13: String?
    let price: String?
    let image: String?
    let url: String?

    // details
    let authors: String?
    let publisher: String?
    let language: String?
    let isbn10: String?
    let pages: String?
    let year: String?
    let rating: String?
    let desc: String?
}
