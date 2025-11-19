//
//  SearchResponse.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

struct SearchResultDTO: Decodable {
    let total: String?
    let page: String?
    let books: [BookDTO]
}
