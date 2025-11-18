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
    private var emptyStateView = UIView()
    private var emptyStateLabel = UILabel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var books: [BookResponse] = []

    private var currentPage: Int = 1
    private var totalResult: Int = 0
    private var isLoading: Bool = false
    private var currentSearchQuery: String = ""

    private var searchWorkItem: DispatchWorkItem?

    private let bookTableViewCellIdentifier = "BookTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        initiate()
        setSearchController()
        setTableView()
        setEmptyStateView()
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

    private func setEmptyStateView() {
        let emptyStateIconView: UIImageView = .init()
        emptyStateIconView.image = UIImage(systemName: "exclamationmark.triangle.fill")

        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateIconView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyStateView.addSubview(emptyStateIconView)
        emptyStateIconView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        emptyStateIconView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emptyStateIconView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor)
            .isActive = true
        emptyStateIconView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
            .isActive = true
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateLabel
            .leading().trailing().top(equalTo: emptyStateIconView.bottomAnchor, constant: 20)
        emptyStateLabel.textAlignment = .center

        emptyStateView.isHidden = true
    }

    private func setTableView() {
        view.addSubview(searchResultTableView)

        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self

        searchResultTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultTableView
            .leading().trailing().top().bottom()
        searchResultTableView.rowHeight = 100
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
            currentSearchQuery = "" // ?
            currentPage = 1
            searchWorkItem?.cancel()
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
                    self.emptyStateView.isHidden = true
                    self.totalResult = Int(response.total) ?? 0
                    if page == 1 {
                        self.books = response.books
                    } else {
                        self.books.append(contentsOf: response.books)
                    }
                    self.currentPage = page
                    self.searchResultTableView.reloadData()
                case .failure(let error):
                    if page == 1 {
                        let failCase = error as? NetworkError
                        self.setEmptyState(message: failCase?.failMessage)
                        self.emptyStateView.isHidden = false
                    }
                }
            }
        }
    }
}

// MARK: EmptyState

extension SearchMainViewController {
    private func setEmptyState(message: String?) {
        books = []
        searchResultTableView.reloadData()
        emptyStateLabel.text = message
    }
}
