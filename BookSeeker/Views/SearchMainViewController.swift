//
//  ViewController.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

import UIKit

class SearchMainViewController: UIViewController {
    private let apiService = APIService.shared

    private let searchResultTableView = UITableView()
    private var emptyStateView = EmptyStateView(type: .searchResultFail)
    private let searchController = UISearchController(searchResultsController: nil)
    private var books: [BookResponse] = []

    private var currentPage: Int = 1
    private var totalResult: Int = 0
    private var isLoading: Bool = false
    var currentSearchQuery: String = ""

    private var searchWorkItem: DispatchWorkItem?

    private let bookTableViewCellIdentifier = "BookTableViewCell"
    private let tableViewRowHeight: CGFloat = 180

    override func viewDidLoad() {
        super.viewDidLoad()

        initiate()
        setSearchController()
        setTableView()
        emptyStateView.set(to: view)
    }

    private func initiate() {
        view.backgroundColor = .white
        title = "BookSeeker"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setSearchController() {
        searchController.searchBar.placeholder = "검색어를 입력하세요."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setTableView() {
        view.addSubview(searchResultTableView)

        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self

        searchResultTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultTableView
            .leading().trailing().top().bottom()
        searchResultTableView.rowHeight = UITableView.automaticDimension
        searchResultTableView.estimatedRowHeight = tableViewRowHeight
        searchResultTableView.register(
            BookTableViewCell.self,
            forCellReuseIdentifier: bookTableViewCellIdentifier
        )
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension SearchMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: bookTableViewCellIdentifier,
            for: indexPath
        ) as? BookTableViewCell else {
            return UITableViewCell()
        }

        let book = books[indexPath.row]
        cell.configureBook(with: book)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = books[indexPath.row]

        let detailViewController = BookDetailViewController(isbn13: book.isbn13)

        detailViewController.modalPresentationStyle = .pageSheet

        present(detailViewController, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let currentRow = indexPath.row
        let thresholdIndex = books.count - 5

        guard currentRow >= thresholdIndex,
              !isLoading,
              !currentSearchQuery.isEmpty,
              books.count < totalResult else {
            return
        }

        let nextPage = currentPage + 1
        searchMore(query: currentSearchQuery, page: nextPage)
    }
}

// MARK: UISearchResultsUpdating

extension SearchMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            books = []
            searchResultTableView.reloadData()
            currentSearchQuery = ""
            currentPage = 1
            searchWorkItem?.cancel()
            emptyStateView.isHidden = true
            return
        }

        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            if query != currentSearchQuery {
                currentSearchQuery = query
                currentPage = 1
                books = []
                searchMore(query: query, page: 1)
            }
        }

        searchWorkItem = workItem
        // debouncing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
    }

    private func searchMore(query: String, page: Int) {
        guard !isLoading else { return }
        isLoading = true

        apiService.fetchSearchResult(query: query, page: page) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    guard !response.books.isEmpty
                    else {
                        self.failToLoad(.noData)
                        return
                    }
                    self.totalResult = Int(response.total) ?? 0
                    if page == 1 {
                        self.books = response.books
                    } else {
                        self.books.append(contentsOf: response.books)
                    }
                    self.currentPage = page
                    self.searchResultTableView.reloadData()

                    self.emptyStateView.hide()
                case .failure(let error):
                    if page == 1 {
                        let error = error as? NetworkError
                        self.failToLoad(error)
                    }
                }
            }
        }
    }

    private func failToLoad(_ error: NetworkError?) {
        books = []
        searchResultTableView.reloadData()
        emptyStateView.setMessage(error?.failMessage)
        emptyStateView.show()
    }
}
