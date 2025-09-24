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
    @IBOutlet private weak var biographyLabel: UILabel!
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
                    self?.setupUI()
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
    
    private func setupUI() {
        guard let detail = viewModel.personDetail else {
            nameLabel.text = "Name not available.."
            jobLabel.text = "Job info not available.."
            biographyLabel.text = "Biography not available.."
            biographyLabel.numberOfLines = 0
            personImageView.image = UIImage(named: "placeholder")
            backgroundImageView.image = UIImage(named: "placeholder")
            return
        }
        
        nameLabel.text = detail.name.isEmpty ? "Name not available.." : detail.name
        jobLabel.text = detail.knownForDepartment.isEmpty ? "Job info not available.." : detail.knownForDepartment
        biographyLabel.text = detail.biography.isEmpty ? "Biography not available.." : detail.biography
        biographyLabel.numberOfLines = 0
        
        if let path = detail.profilePath, !path.isEmpty {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            personImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            backgroundImageView.kf.setImage(with: url)
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backgroundImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundImageView.addSubview(blurEffectView)
        } else {
            personImageView.image = UIImage(named: "placeholder")
            backgroundImageView.image = UIImage(named: "placeholder")
        }
        
        personImageView.layer.cornerRadius = 8
        personImageView.layer.masksToBounds = true
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
            let cast = viewModel.movies[indexPath.item]
            cell.configure(with: cast)
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
            let selectedCast = viewModel.movies[indexPath.row]
            let storyboard = UIStoryboard(name: "MovieDetailViewController", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
                detailVC.movieId = selectedCast.id
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == movieCollectionView {
            let width = collectionView.frame.width / 3 - 8
            return CGSize(width: width, height: width * 1.5)
        } else {
            let width = collectionView.frame.width / 3 - 8
            return CGSize(width: width, height: width * 1.5)
        }
    }
}
