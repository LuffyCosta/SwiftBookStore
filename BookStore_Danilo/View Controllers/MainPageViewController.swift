//
//  MainPageViewController.swift
//  BookStore_Danilo
//
//  Created by danilo on 04/11/2020.
//

import Foundation
import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    public static let SharedInstance = BookModel()
    private let reuseIdentifier = "Book"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
