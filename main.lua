local effect = love.graphics.newShader [[
	//extern vec2 mouse;
	extern vec2 x_bounds;
	extern vec2 y_bounds;
	extern float iter_start;
	extern float max_iter;
	extern float iter_incr;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc){
	
		vec4 colour = Texel(tex,tc); //get colour at current pixel
		float px = tc.x;
		float py = tc.y;
		float x0 = px*(x_bounds.y-x_bounds.x)+x_bounds.x;
		float y0 = py*(y_bounds.y-y_bounds.x)+y_bounds.y;
		
		//float max_iter = 1.0;
		float iter = iter_start;
		float x = 0.0;
		float y = 0.0;
		float xtemp = 0.0;
		float xsqr = x*x;
		float ysqr = y*y;
		while(((xsqr + ysqr) < 4) && (iter < max_iter)){
			xtemp = xsqr - ysqr + x0;
			x += x;
			y = x*y + y0;
			x = xtemp;
			xsqr = x*x;
			ysqr = y*y;
			iter = iter + iter_incr;
		}
		//return colour + vec4(mod(iter,1),mod(iter,1),mod(iter,1),1);
		return colour + vec4(iter,iter,iter,1);
	}

]]
function love.load()
	canvas = love.graphics.newCanvas(640,480);
	canvas:setFilter("nearest","nearest")
	x_bounds = {-2.5,1.0}
	y_bounds = {-1.0,1.0}
	fine = 0.1
	iter = 0
	max_iter = 2
	iter_incr = 0.01
end

function love.update()
	effect:send('x_bounds',{x_bounds[1],x_bounds[2]})
	effect:send('y_bounds',{y_bounds[1],y_bounds[2]})
	effect:send('iter_start',iter)
	effect:send('max_iter',max_iter)
	effect:send('iter_incr',iter_incr)
	--effect:send('iter_incr',0.001)
	if love.keyboard.isDown("up") then
		y_bounds[1] = y_bounds[1] + fine
		y_bounds[2] = y_bounds[2] + fine
	end
	if love.keyboard.isDown("down") then
		y_bounds[1] = y_bounds[1] - fine
		y_bounds[2] = y_bounds[2] - fine
	end
	if love.keyboard.isDown("left") then
		x_bounds[1] = x_bounds[1] - fine
		x_bounds[2] = x_bounds[2] - fine
	end
	if love.keyboard.isDown("right") then
		x_bounds[1] = x_bounds[1] + fine
		x_bounds[2] = x_bounds[2] + fine
	end
	if love.keyboard.isDown("q") then
		--iter = iter + 0.001
		--iter_incr = iter_incr/1.05
		max_iter = max_iter + 0.002
		fine = fine*0.9
		centre_x = (x_bounds[1]+x_bounds[2])/2.0
		centre_y = (y_bounds[1]+y_bounds[2])/2.0
		
		--move point to 0
		zeroed_x = {x_bounds[1]-centre_x,x_bounds[2]-centre_x}
		zeroed_y = {y_bounds[1]-centre_y,y_bounds[2]-centre_y}
		
		--scale it
		zeroed_x[1] = zeroed_x[1]*0.9
		zeroed_x[2] = zeroed_x[2]*0.9
		zeroed_y[1] = zeroed_y[1]*0.9
		zeroed_y[2] = zeroed_y[2]*0.9
		
		--move point back
		x_bounds[1] = zeroed_x[1] + centre_x
		x_bounds[2] = zeroed_x[2] + centre_x
		y_bounds[1] = zeroed_y[1] + centre_y + fine*2
		y_bounds[2] = zeroed_y[2] + centre_y + fine*2
		print(iter,max_iter,iter_incr)
		print(x_bounds[1],x_bounds[2],y_bounds[1],y_bounds[2])
	end
	if love.keyboard.isDown("w") then
		--iter = iter - 0.001
		--iter_incr = iter_incr*1.05
		max_iter = max_iter - 0.002
		fine = fine*1.1
		
		--[[x_bounds[1] = x_bounds[1] - fine
		x_bounds[2] = x_bounds[2] + fine
		y_bounds[1] = y_bounds[1] - fine
		y_bounds[2] = y_bounds[2] + fine]]
		centre_x = (x_bounds[2]+x_bounds[1])/2.0
		centre_y = (y_bounds[2]+y_bounds[1])/2.0
		
		--move point to 0
		zeroed_x = {x_bounds[1]-centre_x,x_bounds[2]-centre_x}
		zeroed_y = {y_bounds[1]-centre_y,y_bounds[2]-centre_y}
		
		--scale it
		zeroed_x[1] = zeroed_x[1]*1.1
		zeroed_x[2] = zeroed_x[2]*1.1
		zeroed_y[1] = zeroed_y[1]*1.1
		zeroed_y[2] = zeroed_y[2]*1.1
		
		--move point back
		
		x_bounds[1] = zeroed_x[1] + centre_x
		x_bounds[2] = zeroed_x[2] + centre_x
		y_bounds[1] = zeroed_y[1] + centre_y - fine*2
		y_bounds[2] = zeroed_y[2] + centre_y - fine*2
		print(iter,max_iter,(max_iter - iter)/100.0)
	end
	
end

function love.draw()

	love.graphics.setCanvas(canvas)
	love.graphics.setShader()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(0,0,0)
	love.graphics.setCanvas()
	love.graphics.setShader(effect)
	love.graphics.draw(canvas)
	
	
end