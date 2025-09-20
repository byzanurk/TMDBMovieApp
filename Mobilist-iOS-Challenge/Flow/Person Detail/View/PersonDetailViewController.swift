//
//  PersonDetailViewController.swift
//  Mobilist-iOS-Challenge
//
//  Created by Beyza Nur Tekerek on 20.09.2025.
//

import UIKit
import Kingfisher

class PersonDetailViewController: UIViewController {

    var viewModel = PersonDetailViewModel()
    var personId: Int?
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var personImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var jobLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    @IBOutlet private weak var tvCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib(nibName: "PersonMoviesCell", bundle: nil), forCellWithReuseIdentifier: "PersonMoviesCell")
        
        tvCollectionView.delegate = self
        tvCollectionView.dataSource = self
        tvCollectionView.register(UINib(nibName: "PersonTVsCell", bundle: nil), forCellWithReuseIdentifier: "PersonTVsCell")
        
        if let id = personId {
            viewModel.fetchPersonDetail(id: id) { [weak self] in
                DispatchQueue.main.async {
                    self?.configureUI()
                }
            }
            viewModel.fetchMovieCredits(id: id) { [weak self] in
                DispatchQueue.main.async {
                    self?.movieCollectionView.reloadData()
                }
            }
            viewModel.fetchTVCredits(id: id) { [weak self] in
                DispatchQueue.main.async {
                    self?.tvCollectionView.reloadData()
                }
            }
        }
    }
    
    private func configureUI() {
        guard let detail = viewModel.personDetail else { return }
        nameLabel.text = detail.name
        jobLabel.text = detail.knownForDepartment
        overviewLabel.text = detail.biography
        if let url = URL(string: detail.posterPath) {
            personImageView.kf.setImage(with: url)
        }
    }
}

extension PersonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieCollectionView {
            return viewModel.movies.count
        } else {
            return viewModel.tvShows.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonMoviesCell", for: indexPath) as! PersonMoviesCell
            let movie = viewModel.movies[indexPath.item]
            cell.configure(with: movie)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonTVsCell", for: indexPath) as! PersonTVsCell
            let tvShow = viewModel.tvShows[indexPath.item]
            cell.configure(with: tvShow)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == movieCollectionView {
            let selectedMovie = viewModel.movies[indexPath.row]
            let storyboard = UIStoryboard(name: "MovieDetailViewController", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
                detailVC.movie = selectedMovie
                navigationController?.pushViewController(detailVC, animated: true)
            }
        } else if collectionView == tvCollectionView {
            // Eğer TV detay sayfan varsa burada benzer şekilde yönlendirme yapabilirsin.
        }
    }
}
