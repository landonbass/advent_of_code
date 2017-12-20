import memfiles, sequtils, strutils

type
    Particle = ref object
        id        : int 
        pX, pY, pZ: int
        vX, vY, vZ: int 
        aX, aY, aZ: int 
        distance  : int
        isCollide : bool

proc `$`(p: Particle): string =
    result = "p=<$#,$#,$#> v=<$#,$#,$#> a=<$#,$#,$#> d=$#" % [$p.pX, $p.pY, $p.pZ, $p.vX, $p.vY, $p.vZ, $p.aX, $p.aY, $p.aZ, $p.distance]   
var particles = newSeq[Particle]()

proc extractValues(s: string) : seq[int] =
    result = newSeq[int]()
    let atoms = split(s,",")
    let left  = parseInt(atoms[0][3..atoms[0].len - 1])
    let mid   = parseInt(atoms[1])
    let right = parseInt(atoms[2][0..atoms[2].len - 2])
    result.add left
    result.add mid
    result.add right

var x = 0
for line in lines(memfiles.open("aoc_2017_day_20.dat")):
    let atoms        = split(line,", ")
    let location     = extractValues atoms[0]
    let velocity     = extractValues atoms[1]
    let acceleration = extractValues atoms[2]
    particles.add Particle(id: x, pX: location[0], pY: location[1], pZ: location[2], vX: velocity[0], vY: velocity[1], vZ: velocity[2], aX: acceleration[0], aY: acceleration[1], aZ: acceleration[2], distance: 0, isCollide: false)
    inc x

for i in 0..<1_000:
    for x in 0..particles.len - 1:
        if not particles[x].isCollide:
            particles[x].vX +=  particles[x].aX
            particles[x].vY +=  particles[x].aY
            particles[x].vZ +=  particles[x].aZ
            particles[x].pX +=  particles[x].vX
            particles[x].pY +=  particles[x].vY
            particles[x].pZ +=  particles[x].vZ
            particles[x].distance = abs(particles[x].pX) + abs(particles[x].pY) + abs(particles[x].pZ)
    #slow cartesian
    for x1 in 0..particles.len - 1:
        for x2 in 0..particles.len - 1:
            if (particles[x1].id != particles[x2].id) and (particles[x1].pX == particles[x2].pX and particles[x1].pY == particles[x2].pY and particles[x1].pZ == particles[x2].pZ):
                particles[x1].isCollide = true
                particles[x2].isCollide = true 

var min  = high int
var minI = low int
for x in 0..particles.len - 1:
    if particles[x].distance < min:
        min  = particles[x].distance
        minI = x

echo minI #not correct for part1 with part 2
echo filter(particles, proc(p: Particle): bool = not p.isCollide).len