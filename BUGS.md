= BUGS

* BitmapData.setPixel(32) is slow as dirt: it's updating the texture every
  call. Need to be able to batch it in order to use Perlin noise techniques /
  etc with it more efficiently, I guess.
* Web Audio crashes Dartium. A lot. I'm not sure if this is StageXL's fault or
  someone else's.
