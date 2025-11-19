//
//  SearchMainViewControllerTests.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

@testable import BookSeeker
import XCTest

class SearchMainViewControllerTests: XCTestCase {
    var sut: SearchMainViewController!

    override func setUp() {
        super.setUp()
        sut = SearchMainViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_디바운스_간격_이전에_검색어를_입력한_경우() {
        // given
        let searchController = UISearchController()
        searchController.searchBar.text = "swift"

        // when
        sut.updateSearchResults(for: searchController)

        // then
        XCTAssertNotEqual(
            sut.currentSearchQuery,
            "swift",
            "즉시 실행 안됨"
        )

        // 0.2초 후
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(
                self.sut.currentSearchQuery,
                "swift",
                "검색 실행"
            )
        }
    }

    func test_디바운스_간격_안에_입력이_여러번_들어오는_경우() {
        // given
        let searchController = UISearchController()
        searchController.searchBar.text = "sw"

        // when
        sut.updateSearchResults(for: searchController)

        searchController.searchBar.text = "swift"
        sut.updateSearchResults(for: searchController)

        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(
                self.sut.currentSearchQuery,
                "swift"
            )
        }
    }
}
