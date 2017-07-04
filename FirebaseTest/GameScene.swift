//
//  GameScene.swift
//  FirebaseTest
//
//  Created by Cappillen on 7/3/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase

class GameScene: SKScene {
    
    var ref: FIRDatabaseReference!
    var currentScore: Int = 26
    var highscore1: String!
    var highscore2: String!
    var highscore3: String!
    
    override func didMove(to view: SKView) {
        ref = FIRDatabase.database().reference()
        
        FIRAuth.auth()?.signIn(withEmail: "theonlyuser@gmail.com", password: "123456", completion: { (user, error) in
            let email = user?.email
            print(email!)
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Push data
        //ref.child("highscores").setValue(["highscore1": "3134", "highscore2": "1234", "highscore3": "21"])
        
        //Pull data
        ref.child("highscores").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.highscore1 = snapshot.childSnapshot(forPath: "highscore1").value as! String
            self.highscore2 = snapshot.childSnapshot(forPath: "highscore2").value as! String
            self.highscore3 = snapshot.childSnapshot(forPath: "highscore3").value as! String
            
            print(self.highscore1)
            print(self.highscore2)
            print(self.highscore3)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func checkIfNewHigh(num: Int) {
        guard let highscore1 = highscore1 else {
            return
        }
        guard let highscore2 = highscore2 else {
            return
        }
        guard let highscore3 = highscore3 else {
            return
        }
        if num > Int(highscore1)! {
            print(num)
            ref.child("highscores").child("highscore1").setValue(String(num))
        } else if num > Int(highscore2)! {
            print(num)
            ref.child("highscores").child("highscore2").setValue(String(num))
        } else if num > Int(highscore3)! {
            print(num)
            ref.child("highscores").child("highscore3").setValue(String(num))
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        checkIfNewHigh(num: currentScore)
    }
}
