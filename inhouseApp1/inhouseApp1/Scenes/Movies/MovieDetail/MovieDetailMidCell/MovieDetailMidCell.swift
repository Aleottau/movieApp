//
//  MovieDetailMidCell.swift
//  inhouseApp1
//
//  Created by alejandro on 7/09/22.
//

import UIKit
import SnapKit

class MovieDetailMidCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var viewInScroll: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    static let identifier: String = "MovieDetailMidCell"
    override var reuseIdentifier: String? {
        return MovieDetailMidCell.identifier
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = nil
        viewInScroll.backgroundColor = nil
    }

    func createButtonGenre() -> UIButton {
        let button = UIButton(configuration: .bordered())
        button.configuration?.cornerStyle = .medium
        button.configuration?.buttonSize = .medium
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        viewInScroll.addSubview(button)
        return button
    }

    func addHorizontalGenreList(arrayGenres movieGenres: [GenreMovie]) {
        var buttons: [UIButton] = []
        for index in 0..<movieGenres.count {
            let genreButton = createButtonGenre()
            let info = movieGenres[index].name
            if index == 0 {
                genreButton.setTitle(info, for: .normal)
                genreButton.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.leading.equalTo(10)
                }
            } else {
                let lastButton = buttons.last
                guard let lastButton = lastButton else {
                    return
                }
                genreButton.setTitle(info, for: .normal)
                genreButton.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.leading.equalTo(lastButton.snp.trailing).offset(10)
                    if index == (movieGenres.count - 1 ) {
                        make.trailing.equalTo(viewInScroll.snp.trailing).offset(-10)
                    }
                }
            }
            buttons.append(genreButton)
        }
        viewInScroll.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}
extension MovieDetailMidCell: MovieDetailCell {
    func setUpWith(model: MovieDetailItem) {
        guard let model = model as? MidMovieDetail else {
            return
        }
        genreLabel.text = "Genres:"
        addHorizontalGenreList(arrayGenres: model.genres)
    }

    func fetchMovie(movie: MovieDetailItem, cell: MovieDetailCell, movieRepository: MovieRepositoryProtocol) {
    }
}
