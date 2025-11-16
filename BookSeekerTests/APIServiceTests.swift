//
//  APIServiceTests.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

@testable import BookSeeker
import XCTest

class APIServiceTests: XCTestCase {
    func testSerachReponseDecoding() throws {
        // given
        let json = """
        {
            "error": "0",
            "total": "86",
            "page": "1",
            "books": [
                {
                    "title": "Microsoft Money 2006 For Dummies",
                    "subtitle": "",
                    "isbn13": "9780471758099",
                    "price": "$0.00",
                    "image": "https://itbook.store/img/books/9780471758099.png",
                    "url": "https://itbook.store/books/9780471758099"
                }
            ]
        }
        """

        // when
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        // then
        do {
            let search = try decoder.decode(SearchResponse.self, from: jsonData)

            XCTAssertEqual(search.books.first?.title, "Microsoft Money 2006 For Dummies")
            XCTAssertEqual(search.total, "86")

        } catch {
            XCTFail("디코딩 실패: \(error)")
        }
    }

    func testBookReponseDecoding() throws {
        // given
        let json = """
        {
            "error": "0",
            "title": "Microsoft Money 2006 For Dummies",
            "subtitle": "",
            "authors": "Peter Weverka",
            "publisher": "Wiley",
            "language": "English",
            "isbn10": "0471758094",
            "isbn13": "9780471758099",
            "pages": "345",
            "year": "2005",
            "rating": "4",
            "desc": "Do you know where you money goes? Would balancing your budget take an act of Congress? Does your idea of preparing for the future involve lottery tickets? This friendly guide provides everything you need to know to stay on top of your finances and make the most of your money - both your cash and you...",
            "price": "$0.00",
            "image": "https://itbook.store/img/books/9780471758099.png",
            "url": "https://itbook.store/books/9780471758099"
        }
        """

        // when
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        // then
        do {
            let book = try decoder.decode(BookResponse.self, from: jsonData)

            XCTAssertEqual(book.title, "Microsoft Money 2006 For Dummies")
            XCTAssertEqual(book.isbn13, "9780471758099")

        } catch {
            XCTFail("디코딩 실패: \(error)")
        }
    }
}
