//
//  MovieDetailTopCell.swift
//  inhouseApp1
//
//  Created by alejandro on 2/09/22.
//

import UIKit

class MovieDetailTopCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backDropPath: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    static let identifier: String = "MovieDetailTopCell"
    override var reuseIdentifier: String? {
        return MovieDetailTopCell.identifier
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        backDropPath.image = nil
        poster.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        statusLabel.text = nil
    }
}

extension MovieDetailTopCell: MovieDetailCell {

    func fetchMovie(movie: MovieDetailItem, cell: MovieDetailCell, movieRepository: MovieRepositoryProtocol) {
        guard let movie = movie as? TopMovieDetail else {
            return
        }
        guard let cell = cell as? MovieDetailTopCell else {
            return
        }
        cell.activityIndicator.startAnimating()
        movieRepository.fetchDetailPoster(movie: movie) { result in
            cell.backDropPath.image = try? result.get()
            cell.poster.image = try? result.get()
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.hidesWhenStopped = true
        }
    }
    func setUpWith(model: MovieDetailItem) {
        guard let modelItem = model as? TopMovieDetail else {
            return
        }
        titleLabel.text = modelItem.originalTitle
        ratingLabel.text = "Ratings: \(modelItem.voteAverage)/10 (\(String(modelItem.voteCount)) votes)"
        statusLabel.text = "Status: \(modelItem.status)"
    }
}
