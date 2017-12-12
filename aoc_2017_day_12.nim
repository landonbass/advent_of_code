import memfiles, sets, sequtils, strutils

type
    Node = object 
        source  : int
        targets : seq[int]

var source = newSeq[string]()
for line in lines(memfiles.open("aoc_2017_day_12.dat")):
    source.add line

var graphSource = newSeq[Node]()

for line in source:
    let atoms  = split line
    let source = parseInt(atoms[0])
    var targets = newSeq[int]()
    for i in 2..atoms.len - 1:
        targets.add parseInt(replace(atoms[i], ",", ""))
    graphSource.add Node(source: source, targets: targets)
 
proc traverseGraph(source: seq[Node], program: int, graph: HashSet[int]) : HashSet[int] =
    result = initSet[int]()
    result.incl graph
    var newGraph  = graph
    let programRow = filter(source, proc(n: Node) : bool = n.source == program)[0]
    if programRow.source notin newGraph:
        newGraph.incl programRow.source
        result.incl newGraph
    for target in programRow.targets:
        if target notin newGraph:
            newGraph.incl target
            result.incl newGraph
            result = result + traverseGraph(source, target, newGraph)



let res = traverseGraph(graphSource, 0, initSet[int]())
echo "part 1:" & $res.len

var groups = newSeq[HashSet[int]]()
for row in graphSource:
    let graph  = traverseGraph(graphSource, row.source, initSet[int]())
    #echo $row.source & " " & $graph
    var found = false
    for group in groups:
        if group == graph: found = true
    if not found: groups.add graph

echo "part 2:" & $groups.len