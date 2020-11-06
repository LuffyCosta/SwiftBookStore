//
//  DetailBooksViewController.swift
//  BookStore_Danilo
//
//  Created by danilo on 05/11/2020.
//

import UIKit
import CoreData

class DetailBooksViewController: UIViewController {

    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!    
    @IBOutlet weak var Favorite: UIButton!
    
    var book: BookModel?
    var favoriteBooks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout(){
        var authors = "Autores: "
        detailTitleLabel.text = book?.title
        fetchImage()
        descriptionLabel.text = book?.description
        for author in book?.authors ?? [String]() {
            authors.append(author+"; ")
        }
        authorsLabel.text = authors
        releaseDateLabel.text = "Lançado: " + self.formatDate(date: book?.releaseDate)
        fetchDataFromFavorites()
        if self.checkBookStaus(bookID: (book?.id)!) {
            Favorite.setTitle("Unfavorite", for: .normal)
        } else {
            Favorite.setTitle("Favorite", for: .normal)
        }
    }
    @IBAction func tappedBuyButton(_ sender: Any) {
        guard let url = URL(string: book?.buyLink ?? "nolink") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func favoriteCurrentBook(_ sender: Any) {
        if self.checkBookStaus(bookID: (book?.id)!) {
            removeFromFavorites()
        } else {
            addToFavorites(bookIdstr: (book?.id)!)
        }
        
        setupLayout()
    }
    
    func formatDate(date: Date?) -> String {
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date!)
        } else {
            return "Not available"
        }
    }
    
    func fetchImage(){
        //URL to get image
        let url = URL(string: (book?.thumbnailBig)!)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {    // execute on main thread
                self.bookCoverImage.image = UIImage(data: data)
            }
        }

        task.resume()
    }
    
    
    func removeFromFavorites(){
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
           return
         }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        for fetchedBook in favoriteBooks {
            if (fetchedBook.value(forKey: "bookId") as? String == book?.id){
                managedContext.delete(fetchedBook)
            }
        }
    }
    
    func addToFavorites(bookIdstr :String){
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
           return
         }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "FavoriteBooks",
                                       in: managedContext)!
        let book = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        book.setValue(bookIdstr, forKeyPath: "bookId")
        do {
          try managedContext.save()
            favoriteBooks.append(book)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func checkBookStaus(bookID: String) -> Bool {
        for fetchedBook in favoriteBooks {
            if (fetchedBook.value(forKey: "bookId") as? String == book?.id){
                Favorite.setTitle("Unfavorite", for: .normal)
                return true
            }
        }
        return false
    }
    
    func fetchDataFromFavorites(){
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
             return
         }
         
         let managedContext =
           appDelegate.persistentContainer.viewContext
         
         let fetchRequest =
           NSFetchRequest<NSManagedObject>(entityName: "FavoriteBooks")
         
         do {
            favoriteBooks = try managedContext.fetch(fetchRequest)
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
    }
}
