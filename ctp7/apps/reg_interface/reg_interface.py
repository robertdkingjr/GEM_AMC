from cmd import Cmd
import sys, os
from rw_reg import *

class Prompt(Cmd):


    def do_hello(self, args):
        """Says hello. If you provide a name, it will greet you with it."""
        if len(args) == 0:
            name = 'stranger'
        else:
            name = args
        print "Hello, %s" % name


    def do_read(self, args):
        """Reads register. USAGE: read <register name>"""
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)

        reglist = [node for node in nodes if node.name == args]
        if len(reglist): 
            register = reglist[0]         
            address = register.address
            address = address << 2
            address = address + 0x64000000
            print 'Register:',register.name
            print 'Address:',hex(address)
            print 'Permission:',register.permission
            if 'r' in str(register.permission):
                os.system('mpeek '+str(address))
            else: print 'No read permission!' 
        else:
            print args,'not found!'

    
    def complete_read(self, text, line, begidx, endidx):
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)
        for n in nodes:
            REGS.append(n.name)
        if not text:
            completions = REGS
        else:
            completions = [ f for f in REGS
                            if f.startswith(text) ]
        return completions

    def do_write(self, args):
        """Writes register. USAGE: write <register name> <register value>"""

        arglist = args.split()
        if len(arglist)==2:
            reglist = [node for node in nodes if node.name == arglist[0]]
            if len(reglist):
                register = reglist[0]
                value = int(arglist[1])
                address = register.address
                address = address << 2
                address = address + 0x64000000
                print 'Register:',register.name
                print 'Address:',hex(address)
                print 'Value:',value
                if 'w' in str(register.permission):
                    os.system('mpoke '+str(address)+' '+str(value))
                    print 'Register Written.'
                else: print 'No write permission!'
            else: print arglist[0],'not found!'
        else: print "Incorrect number of arguments!"

    def complete_write(self, text, line, begidx, endidx):
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)
        for n in nodes:
            REGS.append(n.name)
        if not text:
            completions = REGS
        else:
            completions = [ f for f in REGS
                            if f.startswith(text) ]
        return completions

    def do_readGroup(self, args):
        """Read all registers below node in register tree. USAGE: readGroup <register/node name> """
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)

        reglist = [node for node in nodes if node.name == args]
        if len(reglist): 
            register = reglist[0]         
            print 'NODE:',register.name
            kids = []
            getAllChildren(register, kids)
            print len(kids),'CHILDREN'
            for kid in kids:
                print kid.name
                address = kid.address
                address = address << 2
                address = address + 0x64000000
                print 'Address:',hex(address)
                if 'r' in str(kid.permission):
                    os.system('mpeek '+str(address))
                else: print 'No read permission!'    
        else:
            print args,'not found!'

    def complete_readGroup(self, text, line, begidx, endidx):
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)
        for n in nodes:
            REGS.append(n.name)
        if not text:
            completions = REGS
        else:
            completions = [ f for f in REGS
                            if f.startswith(text) ]
        return completions

    def do_readFW(self, args):
        """Quick read of all FW-related registers"""
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)

        reglist = [node for node in nodes if 'STATUS.FW' in node.name]
        for reg in reglist:
            print reg.name
            address = reg.address
            address = address << 2
            address = address + 0x64000000
            print 'Address:',hex(address)
            if 'r' in str(reg.permission):
                os.system('mpeek '+str(address))
            else: print 'No read permission!'   

    def do_readKW(self, args):
        """Read all registers containing KeyWord. USAGE: readKW <KeyWord>"""
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)

        reglist = [node for node in nodes if args in node.name]
        if len(reglist) and args!='':
            for reg in reglist:
                print reg.name
                address = reg.address
                address = address << 2
                address = address + 0x64000000
                print 'Address:', hex(address)
                if 'r' in str(reg.permission):
                    os.system('mpeek '+str(address))
                else: print 'No read permission!'   
        else: print args,'not found!'

    def do_readAll(self, args):
        """Read all registers with read-permission"""
        tree = xml.parse(ADDRESS_TABLE_TOP)
        root = tree.getroot()[0]
        nodes = []
        vars = {}
        REGS = []
        makeTree(root,'',0x0,nodes,None,vars,False)
        
        reglist = [node for node in nodes if 'r' in str(node.permission)]
        for reg in reglist:
            print reg.name
            address = reg.address
            address = address << 2
            address = address + 0x64000000
            print 'Address:',hex(address)
            if 'r' in str(reg.permission):
                os.system('mpeek '+str(address))
            else: print 'No read permission!'   

    def do_exit(self, args):
        """Exit program"""
        return True

if __name__ == '__main__':
    prompt = Prompt()
    prompt.prompt = 'CTP7 > '
    prompt.cmdloop('Starting Register Command Line Interface...')
