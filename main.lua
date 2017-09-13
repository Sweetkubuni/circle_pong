
-- Ball Definitions
Ball ={}

function LineAngle(ox, oy, bx,by)
  local theta = math.atan( (by - oy)/ (bx - ox));
  return theta;
end

function Ball:create(x, y, vel, radius)
  local ball ={}
  self.x = x
  self.y = y
  self.vel = vel
  self.Vx = 0
  self.Vy = 0
  self.radius = radius
  self.init = 0
  self.__index = self
  setmetatable(ball,self)
  return ball
end

function Ball:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ball:update()
  if self.init == 0 then
    rnum = love.math.random( 1, 4)
    if rnum == 1 then 
      self.Vx = self.Vx + self.vel
      self.Vy = self.Vy + self.vel
      self.init = 1
    elseif rnum == 2 then
      self.Vx = self.Vx - self.vel
      self.Vy = self.Vy - self.vel
      self.init = 1
    elseif rnum == 3 then
      self.Vx = self.Vx - self.vel
      self.Vy = self.Vy + self.vel
      self.init = 1
    elseif rnum == 4 then
      self.Vx = self.Vx - self.vel
      self.Vy = self.Vy - self.vel
      self.init = 1 
    end
  else
      self.x = self.x + self.Vx
      self.y = self.y + self.Vy
  end
end

function Ball:collisionCheck( player )
  local dx = self.x - player.x;
  local dy = self.y - player.y;
  local distance = math.sqrt(dx * dx + dy * dy);

  if (distance < self.radius + player.radius) then
  --collision detected!
    local slopeAngle = LineAngle(self.x, self.y, player.x, player.y)
    slopeAngle = slopeAngle * 180/math.pi
    if slopeAngle <= player.theta and slopeAngle >= player.theta - player.arclength then
      self.Vx = -self.Vx
      self.Vy = -self.Vy
    end
    print(slopeAngle)
    print("\n")
  end
end
-- end of Ball Definitions



-- Field Definition
Field = {}

function Field:create(x,y,width,height)
  local field = {}
  self.x = x
  self.y = y
  self.width  = width - 50
  self.height = height - 50
  self.__index = self
  setmetatable(field, self)
  return field
end

function Field:collisionCheck(ball)
  if ball.x + ball.Vx > self.width - ball.radius or ball.x + ball.Vx < self.x +  ball.radius then
    ball.Vx = -ball.Vx
  end

  if ball.y + ball.Vy > self.height - ball.radius or ball.y + ball.Vy < self.y + ball.radius then
    ball.Vy = -ball.Vy
  end
end

function Field:render()
  love.graphics.setColor(122, 94, 67)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
-- end of Field Definitions


-- Player Definitions
Player = {}

function Player:create(x, y, radius)
  local player = {}
  self.x = x
  self.y = y
  self.radius = radius
  self.deltaradius = 2
  self.arclength = 40
  self.theta = 0
  self.__index = self
  setmetatable(player, self)
  return player
end

function Player:update()
  if love.keyboard.isDown("right") then
    self.theta  = self.theta  + 5
  elseif love.keyboard.isDown("left") then
    self.theta  = self.theta  - 5
  end
end

function Player:render(yellowblock, cherryblock, slimeblock, iceblock, heart)
  love.graphics.setLineWidth( 3 )
  love.graphics.setColor(99, 172, 255)
  love.graphics.circle("line",self.x,self.y, self.radius)
  love.graphics.setColor(48, 63, 86)

  local radiansThetaBegin = self.theta * math.pi / 180;
  local radiansThetaEnd   = (self.theta + self.arclength) * math.pi / 180;
  love.graphics.arc("line", "open",self.x,self.y,self.radius,radiansThetaBegin,radiansThetaEnd, 30)

  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(yellowblock, self.x - 25, self.y - 40)
  love.graphics.draw(cherryblock, self.x - 25, self.y + 20)
  love.graphics.draw(slimeblock, self.x - 25, self.y - 30, math.pi/2)
  love.graphics.draw(iceblock, self.x + 35, self.y - 30, math.pi/2)
  love.graphics.draw(heart, self.x - 25, self.y - 25)
end
-- end of Player Definitions


-- Main
function love.load()
  love.graphics.setBackgroundColor(255, 255, 255)
  width, height = love.graphics.getDimensions( )
  yellowblock = love.graphics.newImage("YellowBlock.png")
  cherryblock = love.graphics.newImage("CherryBlock.png")
  slimeblock  = love.graphics.newImage("SlimeBlock.png")
  iceblock    = love.graphics.newImage("IceBlock.png")
  heart       = love.graphics.newImage("heart.png")

  -- initialize objects
  gball = Ball:create(width/2, height/2, 5, 7)
  gfield = Field:create(20,20,width - 50, height - 50)
  gplayer = Player:create(300,400,55)
end


function love.update(dt)
  gplayer:update()
  gball:update()
  gball:collisionCheck(gplayer)
  gfield:collisionCheck(gball)
end

function love.draw()
  gplayer:render(yellowblock, cherryblock, slimeblock, iceblock, heart)
  gball:render()
  gfield:render()
  love.timer.sleep(1/30)
end
-- end of Main