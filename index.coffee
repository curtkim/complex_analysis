IMAGE_WIDTH = 800
IMAGE_HEIGHT = 800
WORLD_WIDTH = 2
WORLD_HEIGHT = 2

# f(x) = (x^2 − 1)(x − 2 − i)^2 / (x^2 + 2 + 2i)
fun = (z)->
  a = z.pow(2).sub(1)
  b = z.sub({re:2, im:1}).pow(2)
  c = z.pow(2).add({re:2, im:2})
  a.mul(b).div(c)


complex2hsv = (z)->
  #hue
  a = z.arg()
  a += 2*Math.PI while a<0
  a /= 2*Math.PI

  #radius of z
  m = z.abs()
  ranges = 0
  rangee = 1
  while m > rangee
    ranges = rangee
    rangee *= Math.E
  k = (m-ranges)/(rangee-ranges)

  #saturation
  sat = if k<0.5 then k*2 else 1 - (k-0.5)*2
  sat = 1 - Math.pow(1-sat, 3)
  sat = 0.5 + sat*0.6

  #value
  val = if k< 0.5 then k*2 else 1- (k-0.5)*2
  val = 1 - val
  val = 1 - Math.pow(1-val, 3)
  val - 0.6 + val*0.4

  [a, sat, val]


hsv2rgb = (hsv)->
  h = hsv[0]
  s = hsv[1]
  v = hsv[2]

  r = undefined
  g = undefined
  b = undefined
  i = Math.floor(h * 6)
  f = h * 6 - i
  p = v * (1 - s)
  q = v * (1 - (f * s))
  t = v * (1 - ((1 - f) * s))
  switch i % 6
    when 0
      r = v
      g = t
      b = p
    when 1
      r = q
      g = v
      b = p
    when 2
      r = p
      g = v
      b = t
    when 3
      r = p
      g = q
      b = v
    when 4
      r = t
      g = p
      b = v
    when 5
      r = v
      g = p
      b = q
  [
    parseInt(r * 255)
    parseInt(g * 255)
    parseInt(b * 255)
  ]  


window.onload = ()->  
  c = document.getElementById('myCanvas')
  ctx = c.getContext('2d')

  imageData = ctx.createImageData(IMAGE_WIDTH, IMAGE_HEIGHT)
  data = imageData.data
  
  for y in [0...IMAGE_HEIGHT]
    im = WORLD_HEIGHT - (y * 2*WORLD_HEIGHT / IMAGE_HEIGHT)
    for x in [0...IMAGE_WIDTH]
      re = (x * 2*WORLD_WIDTH / IMAGE_WIDTH) - WORLD_WIDTH      
      z = new Complex({re, im})      
      f = fun(z)
      rgb = hsv2rgb(complex2hsv(f))      
      idx = (IMAGE_WIDTH*y+x)*4
      data[idx]= rgb[0]
      data[idx+1]= rgb[1]
      data[idx+2]= rgb[2]
      data[idx+3]= 255

  ctx.putImageData(imageData, 0, 0)