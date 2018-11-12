//
//  ViewController.swift
//  Lab2
//
//  Created by Reis Sirdas on 2/8/17.
//  Copyright © 2017 sirdas. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var happiness: UIView!
    @IBOutlet weak var foodLevel: UIView!
    @IBOutlet weak var happinessCount: UILabel!
    @IBOutlet weak var foodCount: UILabel!
    @IBOutlet weak var gameOver: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var birdButton: UIButton!
    @IBOutlet weak var bunnyButton: UIButton!
    @IBOutlet weak var fishButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var foodView: DisplayView!
    @IBOutlet weak var happinessView: DisplayView!
    var currentPet: Pet! {
        didSet {
            updateView()
        }
    }
    var petArray: [Pet] = []
    var yValue: CGFloat!
    
    var player: AVAudioPlayer!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        managedContext = (appDelegate?.persistentContainer.viewContext)
        
        gameOver.alpha = 0
        yValue = petImage.center.y
        super.viewDidLoad()
        nameButton.setTitle("", for: .normal)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Pet")
        let sortDescriptor = NSSortDescriptor(key: "speciesRaw", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            petArray = try managedContext.fetch(fetchRequest) as [NSManagedObject] as! [Pet]
            if petArray.count < 5 {
                for i in 0...4 {
                    petArray.append(save(name: "", isAlive: false, happiness: 0, foodLevel: 0, speciesRaw: i)! as! Pet)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.didDog(nil)
    }
    
    
    
    private func updateView() {
        happinessCount.text = String(currentPet.happiness)
        foodCount.text = String(currentPet.foodLevel)
        
        let happinessValue = Double(currentPet.happiness)/10
        let foodValue = Double(currentPet.foodLevel)/10
        
        happinessView.animateValue(to: CGFloat(happinessValue))
        
        foodView.animateValue(to: CGFloat(foodValue))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPlay(_ sender: Any) {
        currentPet.play()
        updateView()
        if (!currentPet.isAlive) {
            if (currentPet.happiness == 10 && currentPet.foodLevel == 0) {
                gameOver.text = "\(currentPet.name) had too much fun and not enough food so it basically died twice."
                
            } else if (currentPet.happiness == 10) {
                gameOver.text = "\(currentPet.name) had too much fun and died because of a heart attack."
            } else {
                gameOver.text = "\(currentPet.name) starved to death."
            }
            playSound(pathString: "rip")
            UIView.animateKeyframes(withDuration: 12, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                    
                    self.playButton.isHidden = true
                    self.feedButton.isHidden = true
                    self.dogButton.isEnabled = false
                    self.catButton.isEnabled = false
                    self.birdButton.isEnabled = false
                    self.bunnyButton.isEnabled = false
                    self.fishButton.isEnabled = false
                    self.petImage.alpha = 0
                    self.petImage.center.y = -5
                })
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/6, animations: {
                    self.gameOver.alpha = 1
                })
                UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                    self.gameOver.alpha = 0
                })
            }, completion: {
                _ in
                self.petImage.center.y = self.yValue
                self.dogButton.isEnabled = true
                self.catButton.isEnabled = true
                self.birdButton.isEnabled = true
                self.bunnyButton.isEnabled = true
                self.fishButton.isEnabled = true
            })
        }
        petArray[currentPet.speciesAffiliation.rawValue] = currentPet
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func didFeed(_ sender: Any) {
        currentPet.feed()
        updateView()
        if (!currentPet.isAlive) {
            gameOver.text = "\(currentPet.name) got obese and died due to diabetes, high blood pressure, some cancers, gallbladder disease and gout."
            playSound(pathString: "rip")
            UIView.animateKeyframes(withDuration: 12, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                    
                    self.playButton.isHidden = true
                    self.feedButton.isHidden = true
                    self.dogButton.isEnabled = false
                    self.catButton.isEnabled = false
                    self.birdButton.isEnabled = false
                    self.bunnyButton.isEnabled = false
                    self.fishButton.isEnabled = false
                    self.petImage.alpha = 0
                    self.petImage.center.y = -5
                })
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/6, animations: {
                    self.gameOver.alpha = 1
                })
                UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                    self.gameOver.alpha = 0
                })
            }, completion: {
                _ in
                self.petImage.center.y = self.yValue
                self.dogButton.isEnabled = true
                self.catButton.isEnabled = true
                self.birdButton.isEnabled = true
                self.bunnyButton.isEnabled = true
                self.fishButton.isEnabled = true
            })
        }
        petArray[currentPet.speciesAffiliation.rawValue] = currentPet
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func playSound(pathString: String) { //extension
        let path = Bundle.main.path(forResource: pathString, ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            
        } catch {
            print("mute pet")
        }
    }
    
    func save(name: String, isAlive: Bool, happiness: Int, foodLevel: Int, speciesRaw: Int) -> NSManagedObject? {
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Pet",
                                       in: managedContext)!
        
        let pet = NSManagedObject(entity: entity,
                                  insertInto: managedContext) as! Pet
        pet.name = name
        pet.isAlive = isAlive
        pet.happiness = happiness
        pet.foodLevel = foodLevel
        pet.speciesRaw = speciesRaw
        do {
            self.currentPet = pet
            try managedContext.save()
            
            return pet
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    
    private func birthPet(species: Pet.Species) {
        let alert = UIAlertController(title: "New Pet",
                                      message: "Give a name for your pet",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Create",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        self.petImage.alpha = 1
                                        self.playButton.isHidden = false
                                        self.feedButton.isHidden = false
                                        self.petImage.isHidden = false
                                        self.playSound(pathString: species.description)
                                        do {
                                            self.petArray[species.rawValue].name = nameToSave
                                            self.petArray[species.rawValue].isAlive = true
                                            self.petArray[species.rawValue].happiness = 3
                                            self.petArray[species.rawValue].foodLevel = 3
                                            self.petArray[species.rawValue].speciesRaw = species.rawValue
                                            try self.managedContext.save()
                                            self.currentPet = self.petArray[species.rawValue]
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                            
                                        }
                                        self.nameButton.setTitle(self.currentPet.name, for: .normal)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func didDog(_ sender: Any?) {
        if player != nil {
            player.stop()
        }
        currentPet = petArray[Pet.Species.dog.rawValue]
        self.nameButton.setTitle(currentPet.name, for: .normal)
        if (!currentPet.isAlive) { //if dead prompt for new pet
            playButton.isHidden = true
            feedButton.isHidden = true
            petImage.isHidden = true
            birthPet(species: Pet.Species.dog)
        } else {
            nameButton.setTitle(currentPet.name, for: .normal)
            petImage.alpha = 1
            playButton.isHidden = false
            feedButton.isHidden = false
            petImage.isHidden = false
            playSound(pathString: "dog")
        }
        
        
        happinessView.color = UIColor.red
        foodView.color = UIColor.red
        backgroundView.backgroundColor = UIColor.red
        petImage.image = #imageLiteral(resourceName: "dog")
        
    }
    @IBAction func didCat(_ sender: Any) {
        if player != nil {
            player.stop()
        }
        currentPet = petArray[Pet.Species.cat.rawValue]
        self.nameButton.setTitle(currentPet.name, for: .normal)
        if (!currentPet.isAlive) { //if dead prompt for new pet
            playButton.isHidden = true
            feedButton.isHidden = true
            petImage.isHidden = true
            birthPet(species: Pet.Species.cat)
        } else {
            nameButton.setTitle(currentPet.name, for: .normal)
            petImage.alpha = 1
            playButton.isHidden = false
            feedButton.isHidden = false
            petImage.isHidden = false
            playSound(pathString: "cat")
        }
        
        happinessView.color = UIColor.cyan
        foodView.color = UIColor.cyan
        backgroundView.backgroundColor = UIColor.cyan
        petImage.image = #imageLiteral(resourceName: "cat")
        
    }
    @IBAction func didBird(_ sender: Any) {
        if player != nil {
            player.stop()
        }
        currentPet = petArray[Pet.Species.bird.rawValue]
        self.nameButton.setTitle(currentPet.name, for: .normal)
        if (!currentPet.isAlive) { //if dead prompt for new pet
            playButton.isHidden = true
            feedButton.isHidden = true
            petImage.isHidden = true
            birthPet(species: Pet.Species.bird)
        } else {
            nameButton.setTitle(currentPet.name, for: .normal)
            petImage.alpha = 1
            playButton.isHidden = false
            feedButton.isHidden = false
            petImage.isHidden = false
            playSound(pathString: "bird")
        }
        
        happinessView.color = UIColor.yellow
        foodView.color = UIColor.yellow
        backgroundView.backgroundColor = UIColor.yellow
        petImage.image = #imageLiteral(resourceName: "bird")
        
    }
    @IBAction func didBunny(_ sender: Any) {
        if player != nil {
            player.stop()
        }
        currentPet = petArray[Pet.Species.bunny.rawValue]
        self.nameButton.setTitle(currentPet.name, for: .normal)
        if (!currentPet.isAlive) { //if dead prompt for new pet
            playButton.isHidden = true
            feedButton.isHidden = true
            petImage.isHidden = true
            birthPet(species: Pet.Species.bunny)
        } else {
            nameButton.setTitle(currentPet.name, for: .normal)
            petImage.alpha = 1
            playButton.isHidden = false
            feedButton.isHidden = false
            petImage.isHidden = false
            playSound(pathString: "rabbit")
        }
        
        happinessView.color = UIColor.purple
        foodView.color = UIColor.purple
        backgroundView.backgroundColor = UIColor.purple
        petImage.image = #imageLiteral(resourceName: "bunny")
        
    }
    @IBAction func didFish(_ sender: Any) {
        if player != nil {
            player.stop()
        }
        currentPet = petArray[Pet.Species.fish.rawValue]
        self.nameButton.setTitle(currentPet.name, for: .normal)
        if (!currentPet.isAlive) { //if dead prompt for new pet
            playButton.isHidden = true
            feedButton.isHidden = true
            petImage.isHidden = true
            birthPet(species: Pet.Species.fish)
        } else {
            nameButton.setTitle(currentPet.name, for: .normal)
            petImage.alpha = 1
            playButton.isHidden = false
            feedButton.isHidden = false
            petImage.isHidden = false
            playSound(pathString: "fish")
        }
        
        happinessView.color = UIColor.green
        foodView.color = UIColor.green
        backgroundView.backgroundColor = UIColor.green
        petImage.image = #imageLiteral(resourceName: "fish")
        
    }
    
    @IBAction func changeName(_ sender: Any) {
        let alert = UIAlertController(title: "Change name",
                                      message: "Give your pet another name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Change",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        self.currentPet.name = nameToSave
                                        self.petArray[self.currentPet.speciesAffiliation.rawValue] = self.currentPet
                                        do {
                                            try self.managedContext.save()
                                            
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                        }
                                        self.nameButton.setTitle(self.currentPet.name, for: .normal)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)

        
    }

    
}

