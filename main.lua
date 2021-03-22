function love.load()
    whale = love.graphics.newImage("new_project2.png")
    birdX = 62
    birdWidth = 30
    birdHeight = 25

    playingAreaWidth = 800
    playingAreaHeight = 600

    pipeSpaceHeight = 100
    pipeWidth = 54

    reset()
end

function reset()
    birdY = 200
    birdYSpeed = 0

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
    birdYSpeed = birdYSpeed + (516 * dt)
    birdY = birdY + (birdYSpeed * dt)

    pipe1X, pipe1SpaceY = movePipe(pipe1X, pipe1SpaceY, dt)
    pipe2X, pipe2SpaceY = movePipe(pipe2X, pipe2SpaceY, dt)

    -- TODO: Fix!! when whale collide with pipe reset game
    if isBirdCollidingWithPipe(pipe1X, pipe1SpaceY)
    or isBirdCollidingWithPipe(pipe2X, pipe2SpaceY)
    or birdY > playingAreaHeight then
        -- love.load()
    end

    updateScoreAndClosestPipe(1, pipe1X, 2)
    updateScoreAndClosestPipe(2, pipe2X, 1)
    
end

function movePipe(pipeX, pipeSpaceY, dt)
    print(pipeX)
    pipeX = pipeX - (100 * dt)

    -- create new pipe once out of playing area
   if (pipeX + pipeWidth) < 0 then
       print("new pipe")
        pipeX = playingAreaWidth
        pipeSpaceY = newPipeSpaceY()
    end
    
    return pipeX, pipeSpaceY
end

function isBirdCollidingWithPipe(pipeX, pipeSpaceY)
    return 
    birdX < (pipeX + pipeWidth)
    and (birdX + birdWidth) > pipeX
    and (birdY < pipeSpaceY or (birdY +birdHeight) > (pipeSpaceY + pipeSpaceHeight))
end

function updateScoreAndClosestPipe(thisPipe, pipeX, otherPipe)
    if upcomingPipe == thisPipe
    and (birdX > (pipeX + pipeWidth)) then
        score = score + 1
        upcomingPipe = otherPipe
    end
end

function love.keypressed(key)
    if  birdY > 0 then
          birdYSpeed = -165
    end

end

function drawPipe(pipeX, pipeSpaceY)
        love.graphics.setColor(.53, .77, .90)
        love.graphics.rectangle("fill", pipeX, 0, pipeWidth, pipeSpaceY)    
        love.graphics.rectangle("fill", pipeX, pipeSpaceY + pipeSpaceHeight, pipeWidth, playingAreaHeight - pipeSpaceY - pipeSpaceHeight)
end

function love.draw()
    love.graphics.setColor(.17, .42, .46)
    love.graphics.rectangle("fill", 0, 0, playingAreaWidth, playingAreaHeight)  
    
       
    love.graphics.draw(whale, birdX, birdY, birdWidth, birdHeight)


    
    
    drawPipe(pipe1X, pipe1SpaceY)
    drawPipe(pipe2X, pipe2SpaceY)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(score, 15, 15)
end
