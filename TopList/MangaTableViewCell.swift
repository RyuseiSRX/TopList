//
//  MangaTableViewCell.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/15.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import UIKit
import Kingfisher

protocol MangaTableViewCellDelegate: class {
    func mangaTableViewCellDidAddFavorite(_ cell: MangaTableViewCell)
    func mangaTableViewCellDidRemoveFavorite(_ cell: MangaTableViewCell)
}

class MangaTableViewCell: UITableViewCell {

    let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let startDate: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let endDate: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = .systemFont(ofSize: 12)
        label.layer.cornerRadius = 2
        label.layer.borderColor = UIColor.brown.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "icons8-love-2"), for: .normal)
        button.setImage(UIImage.init(named: "icons8-love"), for: .selected)
        button.imageView?.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTouched(_:)), for: .touchUpInside)
        return button
    }()

    weak var delegate: MangaTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(photoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rankLabel)
        contentView.addSubview(startDate)
        contentView.addSubview(endDate)
        contentView.addSubview(typeLabel)
        contentView.addSubview(favoriteButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoView.heightAnchor.constraint(equalToConstant: 120),
            photoView.widthAnchor.constraint(equalToConstant: 90),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: photoView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: rankLabel.leadingAnchor, constant: -20),

            startDate.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            startDate.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            endDate.topAnchor.constraint(equalTo: startDate.bottomAnchor, constant: 10),
            endDate.leadingAnchor.constraint(equalTo: startDate.leadingAnchor),

            typeLabel.topAnchor.constraint(equalTo: endDate.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: endDate.leadingAnchor),

            rankLabel.topAnchor.constraint(equalTo: photoView.topAnchor),
            rankLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rankLabel.heightAnchor.constraint(equalToConstant: 30),
            rankLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),

            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 36),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    override func prepareForReuse() {
        photoView.image = nil
        titleLabel.text = nil
        startDate.text = nil
        endDate.text = nil
        typeLabel.text = nil
        favoriteButton.isSelected = false
    }

    func setup(manga: Manga) {
        if let url = URL(string: manga.imageURL) {
            photoView.kf.setImage(with: url)
        }
        titleLabel.text = manga.title
        startDate.text = "Start Date: " + (manga.startDate ?? "")
        endDate.text = "End Date: " + (manga.endDate ?? "")
        typeLabel.text = " " + manga.type + " "
        rankLabel.text = "\(manga.rank)"
        favoriteButton.isSelected = manga.isFavorite
    }

    @objc func favoriteButtonTouched(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            delegate?.mangaTableViewCellDidAddFavorite(self)
        } else {
            delegate?.mangaTableViewCellDidRemoveFavorite(self)
        }
    }

}

