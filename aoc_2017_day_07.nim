import memfiles, sequtils,strutils

type
    Node = ref object
        name        : string
        children    : seq[Node]
        weight      : int
        childWeight : int
        isChild     : bool
        combined    : int
proc `$`(n:Node) : string =
    result = "Name:$#\n  Weight:$# Children Count: $# Child Weight $# Combined: $#" % [n.name, $n.weight, $n.children.len, $n.childWeight, $n.combined]
var flatNodes = newSeq[Node]()
for line in lines(memfiles.open("aoc_2017_day_07_train.dat")):
    #parse root
    let rootName   = split(line, " ")[0]
    let weight     = parseInt(line[(find(line, "(") + 1..find(line, ")") - 1)])
    var childNodes = newSeq[Node]()
    let children   = split(split(line, "-> ")[1], " " )
    for child in children:
        childNodes.add Node(name: replace(child, ",", ""))
    flatNodes.add Node(name: rootName, weight: weight, children: childNodes)


for iNode in 0..flatNodes.len - 1:
    for iChild in 0..flatnodes[iNode].children.len - 1:
        let childName = flatnodes[iNode].children[iChild].name
        for n in flatNodes:
            if n.name == childName:
                flatnodes[iNode].children[iChild].weight   = n.weight
                flatnodes[iNode].children[iChild].children = n.children

var nodes = newSeq[Node]()
for node in flatNodes:
    var weight = 0
    for child in node.children:
        let cn = filter(flatNodes, proc(n: Node) : bool = n.name == child.name)[0]
        weight = weight + cn.weight
    let n = Node(name: node.name, weight: node.weight, children: node.children, childWeight: weight, combined: node.weight + weight)
    echo n.name & " " & $n.combined
    nodes.add n



for i in 0..nodes.len-1:
    for c in nodes[i].children: 
        var cn = filter(nodes, proc(n: Node) : bool = n.name == c.name)[0]
        cn.isChild = true

let root = filter(nodes, proc (x: Node): bool = not x.isChild)[0]

proc disp(str: string, offset: int) =
    #echo " ".repeat(offset) & str
    discard

var w1 = 0
var sum0 = newSeq[int]()
var sum1 = newSeq[int]()
var sum2 = newSeq[int]()
var sum3 = newSeq[int]()
var sum4 = newSeq[int]()
var sum5 = newSeq[int]()

echo root
for child in root.children:
    echo child.name & " - " & $child.childWeight

echo sum1

#[
for child1 in root.children:
    w1 += child1.weight
    var w2 = 0
    for child2 in child1.children:
        w2 += child2.weight
        var w3 = 0
        for child3 in child2.children:
            w3 += child3.weight
            var w4 = 0
            for child4 in child3.children:
                w4 += child4.weight
                var w5 = 0
                for child5 in child4.children:
                    sum4.add child5.weight
                    w5 += child5.weight
                    var w6 = 0
                    for child6 in child5.children:
                        sum5.add child6.weight
                        w6 += child6.weight
                        w5 += w6
                    w4 += w5
                    disp(child5.name & " " & $child5.weight & " " & $(child5.weight + w6), 25)        
                w3 += w4
                disp(child4.name & " " & $child4.weight & " " & $(child4.weight + w5), 20)        
            w2 += w3
            disp(child3.name & " " & $child3.weight & " " & $(child3.weight + w4), 15)        
        w1 += w2
        disp(child2.name & " " & $child2.weight & " " & $(child2.weight + w3) , 10)       
    disp(child1.name & " " & $child1.weight & " " & $(child1.weight + w2), 5)
disp(root.name & " " & $root.weight & " " & $(root.weight + w1), 0)

echo sum4
]#