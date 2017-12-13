import memfiles, sets, sequtils, strutils

type
    Direction = enum up, down 
    Layer     = object
                    depth     : int
                    `range`   : int
                    loc       : int
                    direction : Direction

var firewallDef = newSeq[Layer]()
for line in lines(memfiles.open("aoc_2017_day_13.dat")):
    let atoms = split(line, ": ")
    firewallDef.add Layer(depth: parseInt(atoms[0]), `range`: parseInt(atoms[1]), loc: 0, direction: down)


proc canonballRun(firewallDef: seq[Layer], delay: int) : int = 
    var firewall        = firewallDef
    let firewallLength  = firewall[firewall.len - 1].depth #assume increasing depth
    var currentLocation = delay * -1
    var severity        = 0
    while currentLocation <= firewallLength:
        #echo "  delay $# currentLocation $#" % [$delay, $currentLocation]
       
        #move layer location
        for i in 0..firewall.len - 1:
            if firewall[i].depth == currentLocation and firewall[i].loc == 0: severity += firewall[i].depth * firewall[i].range
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

    result = severity


#this is very slow, look to optimize
var initialDelay = 0
var res          = 0
while initialDelay < high int:
    res = canonballRun(firewallDef, initialDelay)
    if res == 0: echo "delay: $# severity: $#" % [$initialDelay, $res]
    inc initialDelay
    




