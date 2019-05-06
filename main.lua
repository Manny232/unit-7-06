
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--background
display.setDefault( "background", 100/255, 100/255, 200/255 )

-- Gravity

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local playerBullets = {} -- Table that holds the players Bullets

--leftwall
local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
leftWall.id = "left wall"
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )
--local rightWall = display.newRect( 400, 0, display.contentHeight / 3 , display.contentHeight + 400 )


--ground
local theGround = display.newImage( "land.png" )
theGround.x = - 190
theGround.y = 480
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )


--charater
local Idle = display.newImageRect( "Idle.png", 175, 175 )
Idle.x = display.contentCenterX
Idle.y = 200
Idle.id = "the character"
physics.addBody(Idle, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
Idle.isFixedRotation = true

-- Character move
-- Character move
local dPad = display.newImageRect( "d-pad.png" , 100 ,100)
dPad.x = 150
dPad.y = display.contentHeight - 80
dPad.alpha = 0.50
dPad.id = "d-pad"

local upArrow = display.newImageRect( "upArrow.png" ,25 ,25)
upArrow.x = 150
upArrow.y = display.contentHeight - 120
upArrow.id = "up arrow"

local downArrow = display.newImageRect( "downArrow.png" ,25 ,25)
downArrow.x = 150
downArrow.y = display.contentHeight -45
downArrow.id = "down arrow"

local leftArrow = display.newImageRect( "leftArrow.png" ,25 ,25)
leftArrow.x = 110
leftArrow.y = display.contentHeight - 80
leftArrow.id = "left arrow"

local rightArrow = display.newImageRect( "rightArrow.png",25 ,25)
rightArrow.x = 190
rightArrow.y = display.contentHeight - 80
rightArrow.id = "right arrow"

local jumpButton = display.newImageRect( "jumpButton.png" ,25 ,25)
jumpButton.x = display.contentWidth -170
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local shootButton = display.newImageRect( "shootButton.png", 60, 60 )
shootButton.x = 270
shootButton.y = 460
shootButton.id = "shootButton"
shootButton.alpha = 1


--functions 
function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( Idle, { 
            x = 0, -- move 0 in the x direction 
            y = -50, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( Idle, { 
            x = 0, -- move 0 in the x direction 
            y = 50, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( idle, { 
            x = -50, -- move 0 in the x direction 
            y = 0, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( Idle, { 
            x = 50, -- move 0 in the x direction 
            y = 0, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        Idle:setLinearVelocity( 0, -750 )
    end

    return true
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImageRect( "bullet.png", 80, 30)
        aSingleBullet.x = Idle.x
        aSingleBullet.y = Idle.y - 75
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity(  0, 500 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
        if event.other.id == "dynamite" then
            print("boom")
        end
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function checkPlayerBulletsOutOfBounds()
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if Idle.y > display.contentHeight + 500 then
       Idle.x = display.contentCenterX
        Idle.y = display.contentCenterY
    end
end

upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )
jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )

Idle.collision = characterCollision
Idle:addEventListener( "collision" )
