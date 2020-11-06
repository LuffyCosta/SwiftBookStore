//
//  BookCollectionViewCell.swift
//  BookStore_Danilo
//
//  Created by danilo on 05/11/2020.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    
    
    func configure(with bookTitle:String){
        bookTitleLabel.text = bookTitle
    }
    
    func goGetImageForThumbnail(with urlstr: String) {
        let url = URL(string: urlstr)

        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {    // execute on main thread
                self.bookCoverImageView.image = UIImage(data: data)
            }
        }

        task.resume()
    }
    
}
