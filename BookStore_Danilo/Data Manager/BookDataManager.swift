//
//  BookDataManager.swift
//  BookStore_Danilo
//
//  Created by danilo on 04/11/2020.
//

import Foundation

enum JSONError: Error {
    case InvalidURL(String)
    case InvalidKey(String)
    case InvalidArray(String)
    case InvalidData
    case InvalidImage
    case indexOutOfRange
    
}

private let baseURL = "https://www.googleapis.com/books/v1/volumes?q=ios&maxResults=20&startIndex=0"
private let notFoundImage = "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101028/112815904-stock-vector-no-image-available-icon-flat-vector-illustration.jpg?ver=6"
class BookDataManager {
    var searchData: [BookModel]
    public static let sharedInstance = BookDataManager()
   
    private init() {
        searchData = []
    }
    
    public func gettAllBooks() -> [BookModel]{
        return self.searchData
    }
    
    func goGetBooks(completion: @escaping ([BookModel]) -> Void){
        let session = URLSession.shared
        let booksUrl = NSURLComponents(string: baseURL)
        let url = (booksUrl?.url!)!
        
        session.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                guard let items = json["items"] as! [[String: Any]]? else {
                    throw JSONError.InvalidArray("items")
                }
                
                for item in items {
                    
                    guard let id = item["id"] as! String? else {
                        throw JSONError.InvalidKey("id")
                    }
                    
                    guard let volumeInfo = item["volumeInfo"] as! [String: AnyObject]? else {
                        throw JSONError.InvalidKey("volumeInfo")
                    }
                    
                    let title = volumeInfo["title"] as? String ?? "Title not available"
                    
                    var authors = [String]()
                
                    if let authorsArray = volumeInfo["authors"] as! [String]? {
                        for author in authorsArray {
                            authors.append(author)
                        }
                    }
                    
                    let smallThumnail = volumeInfo["imageLinks"]?.object(forKey: "smallThumbnail") as? String ?? notFoundImage
                    let bigThumbnail = volumeInfo["imageLinks"]?.object(forKey: "thumbnail") as? String ?? notFoundImage
                    let descripiton = volumeInfo["description"] as? String ?? "Description not available"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                    var pubDate: Date? = nil
                    if let dateString = volumeInfo["publishedDate"] as! String? {
                        pubDate = dateFormatter.date(from: dateString)
                    }
                    
                    let buyLink = volumeInfo["infoLink"] as? String ?? ""
            
                    let book = BookModel(id: id, title: title, authors: authors,description: descripiton, thumbnailBig: bigThumbnail, thumbnailSmall: smallThumnail, releaseDate: pubDate, buyLink: buyLink)
                    
                    self.searchData.append(book)
                }
                completion(self.searchData)
            } catch  {
                print("Error thrown: \(error)")
            }
        }).resume()
    }
}

