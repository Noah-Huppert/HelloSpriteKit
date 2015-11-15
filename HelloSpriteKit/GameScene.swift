import SpriteKit

class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        player.position = CGPoint(x: size.height * 0.1, y: size.height * 0.5)
        
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnMonster),
                SKAction.waitForDuration(1.0)
            ])
        ))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            let touchScaler = (size.height - touchLocation.y) / touchLocation.y// TODO: Figure out how to make destination of ninja star be offscreen with triangles of same ratios
            
            let ninjaStar = SKSpriteNode(imageNamed: "projectile")
            
            ninjaStar.position = player.position
            
            addChild(ninjaStar)
            
            let moveAction = SKAction.moveTo(CGPoint(
                                                x: touchLocation.x * touchScaler,
                                                y: touchLocation.y * touchScaler),
                duration: 1.5)
            let moveDoneAction = SKAction.removeFromParent()
            
            ninjaStar.runAction(SKAction.sequence([moveAction, moveDoneAction]))
        }
    }
    
    func spawnMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.position = CGPoint(
            x: size.width + monster.size.width,
            y: CGFloat(Random(Int(monster.size.height / CGFloat(2)), max: Int(size.height - monster.size.height / 2)))
        )
        
        addChild(monster)
        
        let actionMove = SKAction.moveTo(
            CGPoint(x: -monster.size.width / 2, y: monster.position.y),
            duration: NSTimeInterval(Random(2, max: 4)))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func Random(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}