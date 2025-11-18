//
//  DetailInfoViewController.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

import UIKit

class BookDetailViewController: UIViewController {
    private let isbn13: String
    private let apiService = APIService.shared

    init(isbn13: String) {
        self.isbn13 = isbn13
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let detailStackView = UIStackView()

    private let bookCoverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let authorsLabel = UILabel()
    private let publisherLabel = UILabel()
    private let yearLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setScrollView()
        setImageView()
        setStackView()
        setLoadingIndicator()

        title = "상세정보"

        fetchBookDetails()
    }

    private func setImageView() {
        bookCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        bookCoverImageView.contentMode = .scaleAspectFit
        bookCoverImageView.clipsToBounds = true
//        bookCoverImageView.backgroundColor = .gray
    }

    private func setScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(detailStackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView
            .leading().trailing().top().bottom()

        contentView
            .leading().trailing().top().bottom()
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.addSubview(bookCoverImageView)

        bookCoverImageView.top().leading().trailing()
        bookCoverImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        detailStackView
            .leading(constant: 20).trailing(constant: -20)
            .top(
                equalTo: bookCoverImageView.bottomAnchor,
                constant: 20
            )
            .bottom(constant: 60)
    }

    private func setStackView() {
        detailStackView.axis = .vertical
        detailStackView.spacing = 10
        detailStackView.alignment = .fill
        detailStackView.distribution = .fill

        setLabels()

        [
            titleLabel,
            subtitleLabel,
            authorsLabel,
            publisherLabel,
            yearLabel,
            priceLabel,
            ratingLabel,
            descriptionLabel,
        ]
        .forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            detailStackView.addArrangedSubview($0)
        }
    }

    private func setLabels() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        subtitleLabel.font = .systemFont(ofSize: 18)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        [
            authorsLabel,
            publisherLabel,
            yearLabel,
            priceLabel,
            ratingLabel,
            descriptionLabel,
        ]
        .forEach {
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textColor = .secondaryLabel
            $0.numberOfLines = 0
        }
    }

    private func setLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension BookDetailViewController {
    private func fetchBookDetails() {
        loadingIndicator.startAnimating()

        apiService.fetchBookDetails(isbn13: isbn13) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()

                switch result {
                case .success(let book):
                    self.setBookInfo(book)
                case .failure(let error):
                    self.failToLoad()
                }
            }
        }
    }

    private func setBookInfo(_ book: BookResponse) {
        let noInfo = "정보 없음"
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        authorsLabel.text = "저자: \(book.authors ?? noInfo)"
        publisherLabel.text = "출판사: \(book.publisher ?? "정보 없음")"
        yearLabel.text = "출판년도: \(book.year ?? noInfo)"
        priceLabel.text = "가격: \(book.price)"
        ratingLabel.text = "별점: \(book.rating ?? noInfo)"
        descriptionLabel.text = book.desc ?? noInfo

        if let imageURL = URL(string: book.image) {
            downloadImage(from: imageURL)
        } else {
            bookCoverImageView.image = UIImage(systemName: "book.fill")
        }
    }

    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data,
                  error == nil,
                  let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self?.bookCoverImageView.image = image
            }
        }.resume()
    }

    private func failToLoad() {
        let alert = UIAlertController(
            title: "오류",
            message: "책 정보를 불러올 수 없습니다.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })

        present(alert, animated: true)
    }
}
