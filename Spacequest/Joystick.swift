//
// Copyright (c) 2016 Rafał Sroka
//
// Licensed under the GNU General Public License, Version 3.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//   https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SpriteKit

typealias JoystickTranslationUpdateHandler = (CGPoint) -> ()
let kDefaultJoystickUpdateTimeInterval: TimeInterval = 1/40.0

class Joystick: SKNode {
    
    var updateHandler: JoystickTranslationUpdateHandler?
    var joystickRadius: CGFloat = 0.0
    var stickNode: SKSpriteNode?
    var baseNode: SKSpriteNode?
    var isTouchedDown: Bool = false
    var currentJoystickTranslation: CGPoint = CGPoint.zero
    var updateTimer: Timer?
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(maximumRadius: CGFloat, stickImageNamed: String, baseImageNamed: String?) {
        self.currentJoystickTranslation = CGPoint.zero
        self.isTouchedDown = false
        self.joystickRadius = maximumRadius
        self.stickNode = SKSpriteNode(imageNamed: stickImageNamed);
        
        if baseImageNamed != nil {
            self.baseNode = SKSpriteNode(imageNamed: baseImageNamed!);
        }
        
        super.init()
        
        // Create a timer that will call method that will notify about
        // Joystick movements.
        self.updateTimer = Timer.scheduledTimer(
            timeInterval: kDefaultJoystickUpdateTimeInterval,
            target: self,
            selector: #selector(Joystick.handleJoystickTranslationUpdate),
            userInfo: nil,
            repeats: true)
        
        // Configure and add stick & base nodes.
        if self.baseNode != nil {
            self.baseNode!.position = CGPoint.zero
            self.addChild(baseNode!);
        }
        
        self.stickNode!.position = CGPoint.zero
        self.addChild(self.stickNode!);
        
        self.isUserInteractionEnabled = true
    }
    
    var size: CGSize {
        get {
            return CGSize(width: self.joystickRadius + self.stickNode!.size.width/2,
                          height: self.joystickRadius + self.stickNode!.size.height/2)
        }
    }
    
}

// MARK: - Touches

extension Joystick {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : AnyObject! = touches.first
        
        if (touch != nil) {
            self.isTouchedDown = true
            updateWithTouch(touch as! UITouch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : AnyObject! = touches.first
        
        if (touch != nil) {
            self.isTouchedDown = true
            self.updateWithTouch(touch as! UITouch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouchedDown = false
        self.reset()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouchedDown = false
        self.reset()
    }
    
    func updateWithTouch(_ touch: UITouch) {
        var location = touch.location(in: self)
        let distance = CGFloat(sqrt(pow(CDouble(location.x), 2) + pow(CDouble(location.y), 2)))
        
        if distance >= self.joystickRadius {
            let normalizedTranslationVector = CGPoint(x: location.x / distance, y: location.y / distance)
            
            location = CGPoint(x: normalizedTranslationVector.x * self.joystickRadius,
                               y: normalizedTranslationVector.y * self.joystickRadius)
        }
        
        // Calculate joystick translation.
        self.currentJoystickTranslation.x = location.x/self.joystickRadius
        self.currentJoystickTranslation.y = location.y/self.joystickRadius
        
        self.stickNode!.position = location
    }
    
    @objc func handleJoystickTranslationUpdate() {
        if self.isTouchedDown && self.updateHandler != nil {
            self.updateHandler!(self.currentJoystickTranslation)
        }
    }
    
    func reset() {
        self.stickNode!.position = CGPoint.zero
    }
    
}
