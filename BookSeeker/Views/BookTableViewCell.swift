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

        bookInfoStackView.translatesAutoresizingMaskIntoConstraints = false

        bookInfoStackView.axis = .vertical
        bookInfoStackView.addArrangedSubview(titleLabel)
        bookInfoStackView.addArrangedSubview(subtitleLabel)
        bookInfoStackView.addArrangedSubview(isbn13Label)
        bookInfoStackView.addArrangedSubview(priceLabel)

        contentView.addSubview(bookCoverImageView)
        contentView.addSubview(bookInfoStackView)

        bookCoverImageView.leading().top().bottom()
        bookCoverImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bookInfoStackView.leading(equalTo: bookCoverImageView.trailingAnchor)
        bookInfoStackView.top().bottom().trailing()
    }

    private func setLabels() {
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .secondaryLabel
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        isbn13Label.font = .systemFont(ofSize: 14)
        isbn13Label.textColor = .secondaryLabel
        isbn13Label.numberOfLines = 1

        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = .secondaryLabel
        priceLabel.numberOfLines = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        priceLabel.text = nil
        bookCoverImageView.image = nil
//        bookCoverImageView.tintColor = nil
    }

    func configureBook(with info: BookResponse) {
        titleLabel.text = info.title
        subtitleLabel.text = info.subtitle
        priceLabel.text = info.price
        bookCoverImageView.image = UIImage(systemName: "book.fill")
        bookCoverImageView.tintColor = .gray

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
