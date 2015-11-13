import SpriteKit

class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        player.position = CGPoint(x: size.height * 0.1, y: size.height * 0.5)
        
        addChild(player)
        
        for var i = 0; i < 10; i++ {
            spawnMonster()
        }
    }
    
    func spawnMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.position = CGPoint(
            x: size.width + monster.size.width,
            y: CGFloat(arc4random_uniform(UInt32(Float(size.height))))
        )
        
        addChild(monster)
        
        let actionMove = SKAction.moveTo(
            CGPoint(x: -monster.size.width, y: monster.position.y),
            duration: NSTimeInterval())
        
        let actionMoveDone = SKAction.removeFromParent()
        
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
}