//
//  BookTableViewCell.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/17/25.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    private let bookCoverImageView: UIImageView = .init()
    private let bookInfoStackView: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let subtitleLabel: UILabel = .init()
    private let isbn13Label: UILabel = .init()
    private let priceLabel: UILabel = .init()
    private let urlLabel: UILabel = .init()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
    }

    private func setViews() {
        bookCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        bookCoverImageView.contentMode = .scaleAspectFit
        bookCoverImageView.clipsToBounds = true
        bookCoverImageView.layer.borderColor = UIColor.systemGray4.cgColor
        bookCoverImageView.layer.borderWidth = 0.5
        bookCoverImageView.layer.cornerRadius = 8

        bookInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        bookInfoStackView.axis = .vertical
        bookInfoStackView.spacing = 2
        bookInfoStackView.distribution = .fillProportionally

        contentView.addSubview(bookCoverImageView)
        contentView.addSubview(bookInfoStackView)
        contentView.addSubview(titleLabel)

        bookCoverImageView.leading(constant: 10).top(constant: 20).bottom(constant: 20)
        bookCoverImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        titleLabel
            .top(constant: 20)
            .trailing(constant: 20)
            .leading(equalTo: bookCoverImageView.trailingAnchor, constant: 10)
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        setLabels()
        bookInfoStackView.leading(equalTo: titleLabel.leadingAnchor)
        bookInfoStackView
            .top(equalTo: titleLabel.bottomAnchor, constant: 5)
            .bottom(constant: 20)
            .trailing(constant: 20)
    }

    private func setLabels() {
        [
            subtitleLabel,
            isbn13Label,
            priceLabel,
            urlLabel,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bookInfoStackView.addArrangedSubview($0)
        }

        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2

        isbn13Label.font = .systemFont(ofSize: 14)
        isbn13Label.textColor = .secondaryLabel
        isbn13Label.numberOfLines = 1

        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = .secondaryLabel
        priceLabel.numberOfLines = 1

        urlLabel.font = .systemFont(ofSize: 14)
        urlLabel.textColor = .secondaryLabel
        urlLabel.numberOfLines = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        isbn13Label.text = nil
        priceLabel.text = nil
        urlLabel.text = nil
        bookCoverImageView.image = nil
    }

    func configureBook(with info: BookResponse) {
        titleLabel.text = info.title
        subtitleLabel.text = info.subtitle
        isbn13Label.text = "번호: \(info.isbn13)"
        priceLabel.text = "가격: \(info.price)"
        urlLabel.text = "이동하기: \(info.url)"

        if let imageURL = URL(string: info.image) {
            downloadImage(from: imageURL)
        }
    }

    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data,
                  error == nil,
                  let image = UIImage(data: data)
            else { return }

            DispatchQueue.main.async {
                self?.bookCoverImageView.image = image
            }
        }.resume()
    }
}
