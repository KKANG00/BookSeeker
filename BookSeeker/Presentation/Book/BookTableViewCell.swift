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
    private let urlButton: UIButton = .init(type: .system)

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

        bookCoverImageView.leading(constant: 10).top(constant: 20)
        bookCoverImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        titleLabel
            .top(constant: 20)
            .trailing(constant: 20)
            .leading(equalTo: bookCoverImageView.trailingAnchor, constant: 10)
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 3
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

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
            urlButton,
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

        urlButton.titleLabel?.font = .systemFont(ofSize: 14)
        urlButton.setTitleColor(.systemBlue, for: .normal)
        urlButton.titleLabel?.numberOfLines = 2
        urlButton.contentHorizontalAlignment = .left
        urlButton.addTarget(self, action: #selector(urlButtonAction), for: .touchUpInside)
    }

    @objc
    private func urlButtonAction() {
        guard let labelText = urlButton.titleLabel?.text?.split(separator: " ").last
        else { return }
        openURL(String(labelText))
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
        urlButton.titleLabel?.text = nil
        bookCoverImageView.image = nil
    }

    func configureBook(with entity: BookEntity) {
        titleLabel.text = entity.title
        subtitleLabel.text = entity.subtitle
        isbn13Label.text = entity.bookNumber13
        priceLabel.text = entity.price
        urlButton.setTitle("이동하기: \(entity.url)", for: .normal)

        Task {
            if let imageURL = entity.imageURL,
               let image = await ImageManager.shared.loadImage(from: imageURL) {
                self.bookCoverImageView.image = image
            } else {
                bookCoverImageView.image = UIImage(systemName: "book.fill")
            }
        }
    }
}
