import SpriteKit


protocol MainMenuSceneDelegate
{
    func mainMenuSceneDidTapResumeButton(mainMenuScene:MainMenuScene)
    func mainMenuSceneDidTapRestartButton(mainMenuScene:MainMenuScene)
}


class MainMenuScene: SKScene
{
    var infoButton: Button?
    var resumeButton: Button?
    var restartButton: Button?
    var buttons: [Button]?
    var mainMenuSceneDelegate: MainMenuSceneDelegate?
    var background: BackgroundNode?

    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    override init(size: CGSize)
    {
        super.init(size: size)
                
        configureButtons()
        configureBackground()
    }
    
    
    func configureBackground()
    {
        background = BackgroundNode(size: self.size, staticBackgroundImageName: ImageName.MenuBackgroundPhone)
        background!.configureInScene(self)
    }
}


/**
 Buttons & Title.
*/
extension MainMenuScene
{
    func configureButtons()
    {
        // Info button.
        infoButton = Button(
            normalImageNamed: ImageName.MenuButtonInfoNormal.rawValue,
            selectedImageNamed: ImageName.MenuButtonInfoSelected.rawValue)
        
        infoButton!.position = CGPoint(
            x: scene!.size.width - 20,
            y: scene!.size.height - 20)
        
        self.addChild(infoButton!)

        // Resume button.
        resumeButton = Button(
            normalImageNamed: ImageName.MenuButtonResumeNormal.rawValue,
            selectedImageNamed: ImageName.MenuButtonResumeSelected.rawValue)
        
        resumeButton!.touchUpInsideEventHandler = resumeButtonTouchUpInsideHandler()
        
        // Restart button.
        restartButton = Button(
            normalImageNamed: ImageName.MenuButtonRestartNormal.rawValue,
            selectedImageNamed: ImageName.MenuButtonRestartSelected.rawValue)
        
        restartButton!.touchUpInsideEventHandler = restartButtonTouchUpInsideHandler()
        
        buttons = [resumeButton!, restartButton!]
        let horizontalPadding: CGFloat = 20.0
        var totalButtonsWidth: CGFloat = 0.0
        
        // Calculate total width of the buttons area.
        for (index, button) in enumerate(buttons!)
        {
            totalButtonsWidth += button.size.width
            totalButtonsWidth += index != buttons!.count - 1 ? horizontalPadding : 0.0
        }
        
        // Calculate origin of first button.
        var buttonOriginX = CGRectGetWidth(self.frame) / 2.0 + totalButtonsWidth / 2.0
        
        // Place buttons in the scene.
        for (index, button) in enumerate(buttons!)
        {
            button.position = CGPoint(
                x: buttonOriginX - button.size.width/2,
                y: button.size.height * 1.1)
            
            self.addChild(button)
            
            buttonOriginX -= button.size.width + horizontalPadding
            
            let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI/180.0 * 5.0), duration: 2.0)
            let sequence = SKAction.sequence([rotateAction, rotateAction.reversedAction()])
            
            button.runAction(SKAction.repeatActionForever(sequence))
        }
    }
    
    
    func resumeButtonTouchUpInsideHandler() -> TouchUpInsideEventHandler
    {
        let handler =
        {
            () -> () in

            self.mainMenuSceneDelegate?.mainMenuSceneDidTapResumeButton(self)
            return
        }
       
        return handler
    }
    
    
    func restartButtonTouchUpInsideHandler() -> TouchUpInsideEventHandler
    {
        let handler =
        {
            () -> () in
            
            self.mainMenuSceneDelegate?.mainMenuSceneDidTapRestartButton(self)
            return
        }
        
        return handler
    }
}