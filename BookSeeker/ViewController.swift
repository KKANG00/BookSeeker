//
//  ViewController.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)

    private var books: [BookResponse] = []
    private let apiService = APIService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        initiate()
        setSearchController()
        setTableView()
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView
            .leading().trailing().top().bottom()
        tableView.rowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookItemCell")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookItemCell", for: indexPath)

        let book = books[indexPath.row]

        // tableViewCell
        var content = cell.defaultContentConfiguration()
        content.text = book.title
        content.secondaryText = book.subtitle
        cell.contentConfiguration = content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let book = books[indexPath.row]
        // open modal
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            books = []
            tableView.reloadData()
            return
        }

        apiService.fetchSearchResult(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self else { return }
                DispatchQueue.main.async {
                    self.books = response.books
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("fetchSearchResult Error: \(error)")
            }
        }
    }
}
