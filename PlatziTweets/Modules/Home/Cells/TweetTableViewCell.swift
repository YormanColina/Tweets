//
//  TweetTableViewCell.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 31/01/22.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var ShowVideoButtom: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - IBActions
    
    
    @IBAction func showVideoAction() {
        guard let videoURL = videoURL  else {
            return
        }
        self.needsToShowVideo?(videoURL)
    }
    
// MARK: -  Prpoerties
    private var videoURL: URL?
    var needsToShowVideo: ((_ url: URL) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    // NOTA IMPORTANTE, LAS CELDAS NUNCA DEBN INVOCAR VIEWCONTROLERS
    
    func setupCellWith(post: Post) {
        ShowVideoButtom.isHidden = post.hasVideo ? true : false
        nameLabel.text = post.author.names
        nicknameLabel.text = post.author.nickname
        messageLabel.text = post.text
        
        if post.hasImage  {
            // configurar imagen
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
        } else {
            tweetImageView.isHidden = true
        }
        
        if post.hasVideo {
            ShowVideoButtom.isHidden = false
        } else {
            ShowVideoButtom.isHidden = true
        }
        
        videoURL = URL(string: post.videoUrl)
    }
    
    private func setupUI() {
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        
        nicknameLabel.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        nicknameLabel.layer.shadowColor = UIColor.black.cgColor
        
        messageLabel.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        messageLabel.layer.shadowColor = UIColor.black.cgColor
        
        
    }
    
}
