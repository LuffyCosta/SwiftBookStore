//
//  BookCollectionViewController.swift
//  BookStore_Danilo
//
//  Created by danilo on 05/11/2020.
//

import UIKit

private let reuseIdentifier = "Cell"

class BookCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    @IBOutlet var booksCollection: UICollectionView!
    var searchData: [BookModel] = []
    var selectedIndexpath = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BookDataManager.sharedInstance.goGetBooks(completion:{
                array in
                self.searchData = array
                self.configureCollectionView()
        })
    }
    
    func configureCollectionView()
     {
        DispatchQueue.main.async {
            self.booksCollection.reloadData()
        }
     }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let lay = collectionViewLayout as! UICollectionViewFlowLayout
                let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing

    return CGSize(width:widthPerItem, height:180)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? BookCollectionViewCell{
            bookCell.configure(with: self.searchData[indexPath.row].title!)
            bookCell.goGetImageForThumbnail(with: self.searchData[indexPath.row].thumbnailBig!)
            cell = bookCell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "showDetail", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailBooksViewController{
            let cell = sender as! BookCollectionViewCell
            let indexPaths = self.booksCollection.indexPath(for: cell)
            destination.book = self.searchData[indexPaths!.row]
        }
    }
}

        
