//
//  SearchResult.swift
//  MusicApp
//
//  Created by Eprem Sargsyan on 11.05.23.
//

import Foundation

    class SearchResult: Codable, CustomStringConvertible {
    
        var trackName: String? = ""
        var artistName: String? = ""
        var kind: String? = ""
        var trackPrice: Double? = 0.0
        var currency = ""
        var imageSmall = ""
        var imageLarge = ""
        var trackViewUrl: String?
        var collectionName: String?
        var collectionViewUrl: String?
        var collectionPrice: Double?
        var itemPrice: Double?
        var itemGenre: String?
        var bookGenre: [String]?
    
        var name: String {
            return trackName ?? collectionName ?? ""
        }
    
        var description: String {
            return "\nResult - Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")"
        }
        
        var storeURL: String {
            return trackViewUrl ?? collectionViewUrl ?? ""
        }
        
        var price: Double {
            return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
        }
        
        var genre: String {
            if let genre = itemGenre {
                return genre
            }
            else if let genres = bookGenre {
                return genres.joined(separator: ", ")
            }
            return ""
        }
        
        var artist: String {
            return artistName ?? ""
        }
        
        var type: String {
            let kind = self.kind ?? "audiobook"
            switch kind {
                case "album": return "Album"
                case "audiobook": return "Audio Book"
                case "book": return "Book"
                case "ebook": return "E-Book"
                case "feature-movie": return "Movie"
                case "music-video": return "Music Video"
                case "podcast": return "Podcast"
                case "software": return "App"
                case "song": return "Song"
                case "tv-episode": return "TV Episode"
                default: break
            }
            return "Unknown"
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case artistName
            case trackName
            case trackPrice
            case currency
            case trackViewUrl
            case collectionName
            case collectionViewUrl
            case collectionPrice
            case imageSmall = "artworkUrl60"
            case imageLarge = "artworkUrl100"
            case itemGenre = "primaryGenreName"
            case bookGenre = "genres"
            case itemPrice = "price"
        }
    }

    class ResultArray: Codable {
        var searchResult: Int? = 0
        var results = [SearchResult]()
    }

    func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs
              .name
              .localizedStandardCompare(rhs.name) == .orderedAscending
    }
