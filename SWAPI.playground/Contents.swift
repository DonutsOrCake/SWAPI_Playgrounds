import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
    let birth_year: String
    let homeworld: URL
    let vehicles: [URL]
    let starships: [URL]
    
    enum CodingKeys: String, CodingKey {
        case name
        case films
        case birth_year
        case homeworld
        case vehicles
        case starships
    }
}//End of struct

struct Film: Decodable {
    let title: String
    let episode_id: Int
    let release_date: String
    let opening_crawl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case episode_id
        case release_date
        case opening_crawl
    }
}//End of struct

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else {return completion(nil)}
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else {return completion(nil)}
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else {return completion(nil)}
            
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
}//End of class

func fetchFilms(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 4) { person in
    if let person = person {
        print(person.name)
    }
    if let person = person {
        for film in person.films {
            fetchFilms(url: film)
        }
    }
}
