import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        player.position = CGPoint(x: size.height * 0.1, y: size.height * 0.5)
        
        addChild(player)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
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
            let touchOffsets = CGPoint(x: player.position.x - touchLocation.x,
                                       y: player.position.y - touchLocation.y)
            let targetLocation = CGPoint(x: size.width,
                                         y: (touchOffsets.y / touchOffsets.x) * (size.width - touchLocation.x) + touchLocation.y)
        
            let ninjaStar = SKSpriteNode(imageNamed: "projectile")
            
            ninjaStar.position = player.position
            
            addChild(ninjaStar)
            
            ninjaStar.physicsBody = SKPhysicsBody(circleOfRadius: ninjaStar.size.width / 2)
            ninjaStar.physicsBody?.dynamic = true
            ninjaStar.physicsBody?.categoryBitMask = PhysicsCategory.Projectile.rawValue
            ninjaStar.physicsBody?.contactTestBitMask = PhysicsCategory.Monster.rawValue
            ninjaStar.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
            ninjaStar.physicsBody?.usesPreciseCollisionDetection = true
            
            let moveAction = SKAction.moveTo(targetLocation, duration: 1.5)
            let moveDoneAction = SKAction.removeFromParent()
            
            ninjaStar.runAction(SKAction.sequence([moveAction, moveDoneAction]))
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let items: UnorderedSet<UInt32> = UnorderedSet(initialData: [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask])
        
        if(items.equal(UnorderedSet<UInt32>(initialData: [PhysicsCategory.Projectile.rawValue, PhysicsCategory.Monster.rawValue]))) {
            if contact.bodyA.categoryBitMask == PhysicsCategory.Monster.rawValue {
                contact.bodyA.node?.removeFromParent()
            }
            
            if contact.bodyB.categoryBitMask == PhysicsCategory.Monster.rawValue {
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    func spawnMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.position = CGPoint(
            x: size.width + monster.size.width,
            y: CGFloat(Random(Int(monster.size.height / CGFloat(2)), max: Int(size.height - monster.size.height / 2)))
        )
        
        addChild(monster)
        
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        monster.physicsBody?.dynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster.rawValue
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile.rawValue
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        
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