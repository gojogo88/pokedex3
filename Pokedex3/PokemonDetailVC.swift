//
//  PokemonDetailVC.swift
//  Pokedex3
//
//  Created by Jonathan Go on 2017/03/15.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemonDetail: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = pokemonDetail.name.capitalized
        
        let img = UIImage(named: "\(pokemonDetail.pokedexId)")
        
        mainImage.image = img
        currentEvoImg.image = img
        pokedexIdLbl.text = "\(pokemonDetail.pokedexId)"
        
        pokemonDetail.downloadPokemonDetail {
            
            print("did arrive here")
            //this will only be called after the network call is complete
            self.updateUI()
        }
    }

    func updateUI() {
        attackLbl.text = pokemonDetail.attack
        defenseLbl.text = pokemonDetail.defense
        heightLbl.text = pokemonDetail.height
        weightLbl.text = pokemonDetail.weight
        typeLbl.text = pokemonDetail.type
        descriptionLbl.text = pokemonDetail.description
        
        if pokemonDetail.nextEvolutionId == "" {
            
            evoLbl.text = "No Evolution"
            nextEvoImg.isHidden = true
            
        } else {
            
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemonDetail.nextEvolutionId)
            let evoStr = "Next Evolution: \(pokemonDetail.nextEvolutionName) - Lvl \(pokemonDetail.nextEvolutionLvl)"
            evoLbl.text = evoStr
            
        }
        
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
