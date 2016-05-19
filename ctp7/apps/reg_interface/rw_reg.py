import xml.etree.ElementTree as xml
import sys, os, subprocess

ADDRESS_TABLE_TOP = '/mnt/persistent/texas/gem_amc_top.xml'
nodes = []

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
    configure()
    print 'Example:'
    random_node = nodes[76]
    #print str(random_node.__class__.__name__)
    print 'Node:',random_node.name
    print 'Parent:',random_node.parent.name
    kids = []
    getAllChildren(random_node, kids)
    print len(kids), kids.name

def parseXML():
    tree = xml.parse(ADDRESS_TABLE_TOP)
    root = tree.getroot()[0]
    vars = {}
    makeTree(root,'',0x0,nodes,None,vars,False)

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

def getNode(nodeName):
    nodelist = [node for node in nodes if node.name == nodeName]
    if len(nodelist): return nodelist[0]
    else: return None

def getNodesContaining(nodeString):
    nodelist = [node for node in nodes if nodeString in node.name]
    if len(nodelist): return nodelist
    else: return None

def readAddress(address):
    try: 
        output = subprocess.check_output('mpeek '+str(hex(address)), stderr=subprocess.STDOUT , shell=True)
        value = ''.join(s for s in output if s.isalnum())
    except subprocess.CalledProcessError as e: value = parseError(int(str(e)[-1:]))
    return value

def readRawAddress(raw_address):
    address = raw_address
    address = address << 2
    address = address + 0x64000000
    return readAddress(address)

def readReg(reg):
    address = reg.address
    address = address << 2
    address = address + 0x64000000
    # mpeek <address>
    try: 
        output = subprocess.check_output('mpeek '+str(address), stderr=subprocess.STDOUT , shell=True)
        value = ''.join(s for s in output if s.isalnum())
    except subprocess.CalledProcessError as e: return parseError(int(str(e)[-1:]))
    # Apply Mask
    if reg.mask is not None:
        shift_amount=0
        for bit in reversed('{0:b}'.format(reg.mask)):
            if bit=='0': shift_amount+=1
            else: break
        final_value = (parseInt(str(reg.mask))&parseInt(value)) >> shift_amount
    else:
        final_value = value
    final_int =  parseInt(str(final_value))
    return '{0:#010x}'.format(final_int)

def isValid(address):
    try: subprocess.check_output('mpeek '+str(hex(address)), stderr=subprocess.STDOUT , shell=True)
    except subprocess.CalledProcessError as e: return False
    return True

def parseError(e):
    if e==1:
        return "Failed to parse address"
    if e==2:
        return "Bus error"
    else:
        return "Unknown error: "+str(e)

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

def tabPad(s,maxlen):
    return s+"\t"*((maxlen-len(s)-1)/8+1)

if __name__ == '__main__':
    main()
