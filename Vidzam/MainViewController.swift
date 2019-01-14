//
//  MainViewController.swift
//  Vidzam
//
//  Created by Arpit Patel on 2019-01-13.
//  Copyright © 2019 Zapps Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let resultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultVC") as! ResultViewController

    
    let musicManager = MusicManager()

    @IBOutlet var videoUrlField: UITextView!
    @IBOutlet var startTimeField: UITextField!
    
    //let resultVC = ResultViewController()
    
    @IBAction func submit(_ sender: UIButton) {
        musicManager.getMusicInfo(url: videoUrlField.text,
                                  startTime: Int(startTimeField.text!)!,
                                    completionHandler: { (musicDict) in
                                        DispatchQueue.main.async {
                                            self.present(self.resultVC, animated: true, completion: { () in
                                                self.resultVC.musicResultLabel.text = musicDict.description
                                            })
                                        }
                                    },
                                    errorHandler: { (error) in
                                        DispatchQueue.main.async {
                                            self.present(self.resultVC, animated: true, completion: { () in
                                                self.resultVC.musicResultLabel.text = error
                                            })
                                        }
                                    })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

