//
//  DetailInfoViewController.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

import UIKit

class BookDetailViewController: UIViewController {
    private let searchUseCase: SearchUseCaseProtocol
    private let isbn13: String?

    init(
        searchUseCase: SearchUseCaseProtocol,
        isbn13: String?
    ) {
        self.searchUseCase = searchUseCase
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
    private let languageLabel = UILabel()
    private let isbn10Label = UILabel()
    private let isbn13Label = UILabel()
    private let pagesLabel = UILabel()
    private let yearLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let urlButton = UIButton()

    private let emptyStateView: EmptyStateView = .init(type: .detailInfoFail)

    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setScrollView()
        setImageView()
        setStackView()
        setLoadingIndicator()
        emptyStateView.set(to: view)

        title = "상세정보"

        fetchBookDetails()
    }

    private func setImageView() {
        bookCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        bookCoverImageView.contentMode = .scaleAspectFit
        bookCoverImageView.clipsToBounds = true
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

        bookCoverImageView.top(constant: 20).leading().trailing()
        bookCoverImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        detailStackView
            .leading(constant: 20).trailing(constant: 20)
            .top(
                equalTo: bookCoverImageView.bottomAnchor,
                constant: 20
            )
            .bottom(constant: 20)
    }

    private func setStackView() {
        detailStackView.axis = .vertical
        detailStackView.spacing = 10
        detailStackView.distribution = .fill

        setLabels()

        [
            titleLabel,
            subtitleLabel,
            authorsLabel,
            publisherLabel,
            languageLabel,
            isbn10Label,
            isbn13Label,
            pagesLabel,
            yearLabel,
            priceLabel,
            ratingLabel,
            descriptionLabel,
            urlButton,
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
            languageLabel,
            isbn10Label,
            isbn13Label,
            pagesLabel,
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

        urlButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        urlButton.setTitleColor(.systemBlue, for: .normal)
        urlButton.titleLabel?.numberOfLines = 0
        urlButton.contentHorizontalAlignment = .left
        urlButton.addTarget(self, action: #selector(urlButtonAction), for: .touchUpInside)
    }

    @objc
    private func urlButtonAction() {
        guard let labelText = urlButton.titleLabel?.text
        else { return }
        openURL(String(labelText))
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
        guard let isbn13 else { return }
        loadingIndicator.startAnimating()

        Task {
            do {
                let response = try await searchUseCase.bookDetail(isbn: isbn13)

                await MainActor.run {
                    self.loadingIndicator.stopAnimating()
                    self.setBookInfo(response)
                    self.emptyStateView.hide()
                }
            } catch {
                await MainActor.run {
                    self.loadingIndicator.stopAnimating()
                    self.failToLoad(error: error.localizedDescription)
                }
            }
        }
    }

    private func setBookInfo(_ entity: BookEntity) {
        titleLabel.text = entity.title
        subtitleLabel.text = entity.subtitle
        authorsLabel.text = entity.authors
        publisherLabel.text = entity.publisher
        languageLabel.text = entity.language
        isbn10Label.text = entity.bookNumber10
        isbn13Label.text = entity.bookNumber13
        pagesLabel.text = entity.pages
        yearLabel.text = entity.year
        priceLabel.text = entity.price
        ratingLabel.text = entity.rating
        descriptionLabel.text = entity.description
        urlButton.setTitle(entity.url, for: .normal)

        if let imageURL = entity.imageURL,
           let url = URL(string: imageURL) {
            downloadImage(from: url)
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

    private func failToLoad(error message: String?) {
        emptyStateView.setMessage(message)
        emptyStateView.show()
    }
}
