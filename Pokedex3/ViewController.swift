//
//  ViewController.swift
//  Pokedex3
//
//  Created by Jonathan Go on 2017/03/14.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit
import AVFoundation     //for music

//UICollectionViewDelegate is the class that will be the delegate for the UICollectionvView
//UICollectionViewDataSource is the class that will hold the data for the UICollectionView
//UICollectionViewDelegateFlowLayout is the protocol used to modify and set the settings for the layout
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAUdio()
    }
    
    func initAUdio() {
        let musicPath = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: musicPath!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    //func to parse the pokemon csv data
    func parsePokemonCSV() {
        //create a path to the csv file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
    
        do {
            //parser to pull up the rows
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                //for each row, we're creating a pokemon object (poke) and putting the name and id to it.
                let poke = Pokemon(name: name, pokedexId: pokeId)
                //add the pokemon object (poke) to the pokemon array we created
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        //we dont want all 700+ pokemon to load, so dequereusablecell only loads how many will be displayed at a time. When the user scroll up, the ones off the screen deque and it just picks up another cell.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!   //we're getting a pokemon object
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)        //we're passing the pokemon object to the cell

            } else {
                
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)            //we're passing the pokemon object to the cell
            }
            
            return cell
        } else {
            return UICollectionViewCell()   //returns and empty generic cell if func can't grab a dequed cell.
        }
    }

    
    //this func will execute when user taps on a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        //we're creating a variable (poke) and we're taking it from filteredPokemon or pokemon array
        var poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
            
        } else {
            
            poke = pokemon[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "toPokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokemon.count
            
        }
        
        return pokemon.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
        
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2
        
        } else {
        
            musicPlayer.play()
            sender.alpha = 1.0
        
        }
        
    }
    
    //to close the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //anytime we make a keystroke in the searchbar, whatever is here is going to be called
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()     //if user deleted his search, this will revert to orignal list of pokemon
            view.endEditing(true)       //to close the keyboard
            
        } else {
        
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            //check if the search text is in the original name of the pokemon, if it is, put it in filteredPokemon. $0 is a placeholder for each item in the array.
            filteredPokemon = pokemon.filter({ $0.name.range(of: lower) != nil})
            collection.reloadData()
        }
        
    }
    
    //this is where we set data that will be passed to PokemonDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPokemonDetailVC" {
            
            if let detailsVC = segue.destination as? PokemonDetailVC {
                
                if let poke = sender as? Pokemon {
                    
                    detailsVC.pokemonDetail = poke
                    
                }
                
            }
            
        }
        
    }
    
}

