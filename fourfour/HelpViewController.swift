//
//  HelpViewController.swift
//  fourfour
//
//  Created by Eura Choi on 7/29/16.
//  Copyright © 2016 Eura Choi. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var AISwitch: UISwitch!
    var on = false
    var switchWasRecentlyFlipped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AISwitch.on = on
        AISwitch.addTarget(self, action: #selector(HelpViewController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            on = true
            switchWasRecentlyFlipped = true
        }
        else {
            on = false
            switchWasRecentlyFlipped = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "backButton" {
                let destination = segue.destinationViewController as! ViewController
                destination.AIPlay = self.on
                destination.AIPlayHasBeenNewlySwitched = switchWasRecentlyFlipped
            }
        }
    }
    
    
    

}
