//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Jonathan Go on 2017/03/14.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import Foundation
import Alamofire

//Class to hold all the Pokemon.
class Pokemon {
    
    //what does each Pokemon need?
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    //data protection to make sure we never get a nil and crash when we request data from the class.
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    //we need to initialize each Pokemon object and pass into it the data needed
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        //everytime we create a pokemon, we want to create the api URL as well
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {     //DownloadComplete is the closure
        
        //getting a network get request via Alamofire
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            //putting the JSOn response in a dictionary (dict)
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                //using if let calls to go deeper in the dict and extract the data we need (seach the dictionary key and get the value of the key)
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    
                    self._height = height
                    
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    self._attack = "\(attack)"
                    
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                    
                }
                
                //the value of key "types" is an array of dictionies. So we're getting all the possible values
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    
                    //first entry with kay "name" and assign the value to name then to _type. If there is only 1 entry, this will be called.
                    if let name = types[0]["name"] {
                        
                        self._type = name.capitalized
                    }
                    
                    //if there are more than 1 entry, this will be called and loop through all the dictionaries
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            
                            if let name = types[x]["name"] {
                                
                                self._type! += " / \(name.capitalized)"
                                
                            }
                            
                        }
                        
                    }
                    
                    print(self._type)
                        
                } else {
                        
                    self._type = ""
                    
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    
                                }
                                
                            }
                            
                            completed()
                            
                        })
                        
                    }
                    
                } else {
                    
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "api/vi/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int {
                                        
                                        self._nextEvolutionLvl = "\(lvl)"
                                        
                                    }
                                    
                                } else {
                                    
                                    self._nextEvolutionLvl = ""
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                print(self._nextEvolutionName)
                print(self._nextEvolutionLvl)
                print(self._nextEvolutionId)
                
            }
            
            completed()
            
        }
        
    }
    
}
