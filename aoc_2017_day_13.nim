import memfiles, sets, sequtils, strutils

type
    Direction = enum up, down 
    Layer = object
        depth     : int
        `range`   : int
        loc       : int
        direction : Direction

var firewall = newSeq[Layer]()
for line in lines(memfiles.open("aoc_2017_day_13.dat")):
    let atoms = split(line, ": ")
    firewall.add Layer(depth: parseInt(atoms[0]), `range`: parseInt(atoms[1]), loc: 0, direction: down)

let firewallLength  = firewall[firewall.len - 1].depth #assume increasing depth
var currentLocation = 0
var severity        = 0
while currentLocation <= firewallLength:
    let currentLayer = filter(firewall, proc(layer: Layer): bool = layer.depth == currentLocation)
    if currentLayer.len == 0: 
        discard "no firewall at current depth"
    else:
        let layer = currentLayer[0]
        if layer.loc == 0:
            severity += layer.depth * layer.range
    
    #move layer location
    for i in 0..firewall.len - 1:
        case firewall[i].direction:
            of down:
                if firewall[i].loc < firewall[i].range - 1:
                    inc firewall[i].loc
                else:
                    dec firewall[i].loc
                    firewall[i].direction = up 
            of up:
                if firewall[i].loc > 0:
                    dec firewall[i].loc
                else:
                    inc firewall[i].loc
                    firewall[i].direction = down

    inc currentLocation

echo severity