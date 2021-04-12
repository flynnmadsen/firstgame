--require("lldebugger").start()

function love.load()
    whale = love.graphics.newImage("new_project2.png")

    whaleX = 62
    whaleWidth = 30
    whaleHeight = 25

    playingAreaWidth = 800
    playingAreaHeight = 600

    pipeSpaceHeight = 100
    pipeWidth = 60
    
    reset()
end

function reset()
    whaleY = 200
    whaleYSpeed = 0

    pipe1X = playingAreaWidth
    pipe1SpaceY = newPipeSpaceY()

    pipe2X = playingAreaWidth + ((playingAreaWidth + pipeWidth) / 2)
    pipe2SpaceY = newPipeSpaceY()

     score = 0

    upcomingPipe = 1
end

function newPipeSpaceY()
    local pipeSpaceYMin = 54
    local pipeSpaceY = love.math.random(pipeSpaceYMin, playingAreaHeight - pipeSpaceHeight - pipeSpaceYMin)
     return pipeSpaceY
 end

function love.update(dt)
    whaleYSpeed = whaleYSpeed + (516 * dt)
    whaleY = whaleY + (whaleYSpeed * dt)

    pipe1X, pipe1SpaceY = movePipe(pipe1X, pipe1SpaceY, dt)
    pipe2X, pipe2SpaceY = movePipe(pipe2X, pipe2SpaceY, dt)

    -- pipeTop = pipe1SpaceY
    -- pipeBottom = pipe2SpaceY
    -- whalePosY = whaleY
   --  whalePosX = 140 --whaleX + (whaleWidth*3)

    -- TODO: Fix!! when whale collide with pipe reset game
    if isWhaleCollidingWithPipe(pipe1X, pipe1SpaceY)        
       or isWhaleCollidingWithPipe(pipe2X, pipe2SpaceY) 
       or whaleY > playingAreaHeight then 
        reset()
    end
    

    updateScoreAndClosestPipe(1, pipe1X, 2)
    updateScoreAndClosestPipe(2, pipe2X, 1)
    
end

function movePipe(pipeX, pipeSpaceY, dt)
    --print(pipeX)
    pipeX = pipeX - (120 * dt)

    -- create new pipe once out of playing area
   if (pipeX + pipeWidth) < 0 then
       print("new pipe")
        pipeX = playingAreaWidth
        pipeSpaceY = newPipeSpaceY()
    end
    
    return pipeX, pipeSpaceY
end

function isWhaleCollidingWithPipe(pipeX, pipeSpaceY)
   return
    whaleX < (pipeX + pipeWidth) 
   and (whaleX + whaleWidth) > pipeX
   and (whaleY < pipeSpaceY or (whaleY + whaleHeight) > (pipeSpaceY + pipeSpaceHeight))

end

function updateScoreAndClosestPipe(thisPipe, pipeX, otherPipe)
    if upcomingPipe == thisPipe
    and (whaleX > (pipeX + pipeWidth)) then
        score = score + 1
        upcomingPipe = otherPipe
    end
end

function love.keypressed(key)
    if  whaleY > 0 then
          whaleYSpeed = -165
    end

end

function drawPipe(pipeX, pipeSpaceY)
        love.graphics.setColor(.53, .77, .90)
        love.graphics.rectangle("fill", pipeX, 0, pipeWidth, pipeSpaceY)    
        love.graphics.rectangle("fill", pipeX, pipeSpaceY + pipeSpaceHeight, pipeWidth, playingAreaHeight - pipeSpaceY - pipeSpaceHeight)
end

function getImageScaleForNewDimensions (image, whaleHeight, whaleWidth)
    local currentWidth, currentHeight = image:getDimensions()
    return (whaleWidth / currentWidth),   (whaleHeight / currentHeight )  
end 


function love.draw()
    love.graphics.setColor(.18, .44, .45)
    love.graphics.rectangle("fill", 0, 0, playingAreaWidth, playingAreaHeight)  
    
    local scaleX, scaleY = getImageScaleForNewDimensions(whale, 70, 60)
    love.graphics.draw(whale, whaleX, whaleY, 0, scaleX, scaleY)

    drawPipe(pipe1X, pipe1SpaceY)
    drawPipe(pipe2X, pipe2SpaceY)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(score, 20, 20)

    -- love.graphics.print(testValue, 30, 20)
    -- love.graphics.print(whaleDetails, 30, 30)
    -- love.graphics.print(pipeTop, 30, 40)
    -- love.graphics.print(pipeBottom, 30, 50)
    -- love.graphics.print(whalePosY, 30, 60)
    -- love.graphics.print(pipe1SpaceY,30, 70)
    -- love.graphics.print(pipe2SpaceY, 30, 80)
    --love.graphics.print("test test", 20, 20)
end
