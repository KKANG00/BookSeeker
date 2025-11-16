//
//  SearchResponse.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

struct SearchResponse: Decodable {
    let total: String
    let page: String
    let books: [BookResponse]
}
