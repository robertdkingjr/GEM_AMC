import xml.etree.ElementTree as xml

ADDRESS_TABLE_TOP = '../../../scripts/address_table/gem_amc_top.xml'

class Node:
    name = ''
    vhdlname = ''
    address = 0x0
    permission = ''  
    mask = 0x0
    isModule = False
    parent = None

    def __init__(self):
        self.children = []

    def addChild(self, child):
        self.children.append(child)

    def getVhdlName(self):
        return self.name.replace(TOP_NODE_NAME + '.', '').replace('.', '_')

def main():
    tree = xml.parse(ADDRESS_TABLE_TOP)
    root = tree.getroot()[0]

    nodes = []
    vars = {}
    
    makeTree(root,'',0x0,nodes,None,vars,False)
    print 'Example:'
    random_node = nodes[76]
    #print str(random_node.__class__.__name__)
    print 'Node:',random_node.name
    print 'Parent:',random_node.parent.name
    kids = []
    getAllChildren(random_node, kids)
    print len(kids), kids.name


def makeTree(node,baseName,baseAddress,nodes,parentNode,vars,isGenerated):
    
    if (isGenerated == None or isGenerated == False) and node.get('generate') is not None and node.get('generate') == 'true':
        generateSize = parseInt(node.get('generate_size'))
        generateAddressStep = parseInt(node.get('generate_address_step'))
        generateIdxVar = node.get('generate_idx_var')
        for i in range(0, generateSize):
            vars[generateIdxVar] = i
            #print('generate base_addr = ' + hex(baseAddress + generateAddressStep * i) + ' for node ' + node.get('id'))
            makeTree(node, baseName, baseAddress + generateAddressStep * i, nodes, parentNode, vars, True)
        return


    newNode = Node()
    name = baseName
    if baseName != '':
        name += '.'
    name += node.get('id')
    name = substituteVars(name, vars)
    newNode.name = name
    #print len(nodes), name
    #print newNode.name
    address = baseAddress
    if node.get('address') is not None:
        address = baseAddress + parseInt(node.get('address'))
    newNode.address = address
    
    newNode.permission = node.get('permission')
    newNode.mask = parseInt(node.get('mask'))

    newNode.isModule = node.get('fw_is_module') is not None and node.get('fw_is_module') == 'true'
    
    nodes.append(newNode)
    if parentNode is not None:
        parentNode.addChild(newNode)
        newNode.parent = parentNode

    for child in node:
        makeTree(child,name,address,nodes,newNode,vars,False)


def getAllChildren(node,kids=[]):
    #print node.children
    if node.children==[]:
        kids.append(node)
        #print kids
        return kids
    else:
        for child in node.children:
            getAllChildren(child,kids)



def parseInt(string):
    if string is None:
        return None
    elif string.startswith('0x'):
        return int(string, 16)
    elif string.startswith('0b'):
        return int(string, 2)
    else:
        return int(string)


     
def substituteVars(string, vars):
    if string is None:
        return string
    ret = string
    for varKey in vars.keys():
        ret = ret.replace('${' + varKey + '}', str(vars[varKey]))
    return ret


if __name__ == '__main__':
    main()
