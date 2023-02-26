//
//  MovieDetailBotCell.swift
//  inhouseApp1
//
//  Created by alejandro on 4/09/22.
//

import UIKit

class MovieDetailBotCell: UICollectionViewCell {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var desOverview: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var desRelease: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var desRuntime: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var desBudget: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var desRevenue: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var desWebsite: UILabel!

    static let identifier: String = "MovieDetailBotCell"
    override var reuseIdentifier: String? {
        return MovieDetailBotCell.identifier
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        overviewLabel.text = nil
        desOverview.text = nil
        releaseLabel.text = nil
        desRelease.text = nil
        runtimeLabel.text = nil
        desRuntime.text = nil
        budgetLabel.text = nil
        desBudget.text = nil
        revenueLabel.text = nil
        desRevenue.text = nil
        websiteLabel.text = nil
        desWebsite.text = nil
    }
}

extension MovieDetailBotCell: MovieDetailCell {

    func fetchMovie(movie: MovieDetailItem, cell: MovieDetailCell, movieRepository: MovieRepositoryProtocol) {
    }
    func setUpWith(model: MovieDetailItem) {
        guard let model = model as? BotMovieDetail else {
            return
        }
        overviewLabel.text = "Overview:"
        if let overview = model.overview {
            desOverview.text = overview
        } else {
            desOverview.text = "The Movie hasn't overview"
        }
        releaseLabel.text = "Release Date:"
        desRelease.text = model.releaseDate
        runtimeLabel.text = "Runtime:"
        if let runtime = model.runtime {
            desRuntime.text = String(runtime)
        } else {
            desRuntime.text = "nil"
        }
        budgetLabel.text = "Budget:"
        if let budget = model.budget {
            desBudget.text = String(budget)
        } else {
            desBudget.text = "nil"
        }
        revenueLabel.text = "Revenue:"
        desRevenue.text = String(model.revenue)
        websiteLabel.text = "Website:"
        if let web = model.homepage {
            desWebsite.text = web
        } else {
            desWebsite.text = "nil"
        }
    }
}
