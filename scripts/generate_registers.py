__author__ = 'evka'

import xml.etree.ElementTree as xml
import textwrap as tw

ADDRESS_TABLE_TOP = '../doc/address_table/gem_amc_top.xml'
CONSTANTS_FILE = '../common/hdl/pkg/registers.vhd'

TOP_NODE_NAME = 'GEM_AMC'
VHDL_REG_CONSTANT_PREFIX = 'REG_'

class Module:
    name = ''
    description = ''
    baseAddress = 0x0
    regAddressMsb = None
    regAddressLsb = None
    file = ''
    userClock = ''
    busClock = ''
    busReset = ''
    masterBus = ''
    slaveBus = ''

    def __init__(self):
        self.regs = []

    def addReg(self, reg):
        self.regs.append(reg)

    def isValid(self):
        return self.name is not None and self.file is not None and self.userClock is not None and self.busClock is not None\
               and self.busReset is not None and self.masterBus is not None and self.slaveBus is not None\
               and self.regAddressMsb is not None and self.regAddressLsb is not None

    def toString(self):
        return str(self.name) + ' module: ' + str(self.description) + '\n'\
                         + '    Base address = ' + hex(self.baseAddress) + '\n'\
                         + '    Register address MSB = ' + hex(self.regAddressMsb) + '\n'\
                         + '    Register address LSB = ' + hex(self.regAddressLsb) + '\n'\
                         + '    File = ' + str(self.file) + '\n'\
                         + '    User clock = ' + str(self.userClock) + '\n'\
                         + '    Bus clock = ' + str(self.busClock) + '\n'\
                         + '    Bus reset = ' + str(self.busReset) + '\n'\
                         + '    Master_bus = ' + str(self.masterBus) + '\n'\
                         + '    Slave_bus = ' + str(self.slaveBus)

    def getVhdlName(self):
        return self.name.replace(TOP_NODE_NAME + '.', '')

class Register:
    name = ''
    address = 0x0
    description = ''
    permission = ''
    mask = 0x0
    signal = ''
    default = 0x0
    isWritePulse = False
    writePulseLength = 0
    readPulseSignal = None
    readPulseLength = None
    msb = -1
    lsb = -1

    def isValidReg(self):
        return self.name is not None and self.address is not None and self.permission is not None\
               and self.mask is not None and self.signal is not None\
               and (self.default is not None or self.isWritePulse == True or self.permission == 'r')

    def toString(self):
        ret = 'Register ' + str(self.name) + ': ' + str(self.description) + '\n'\
              '    Address = ' + hex(self.address) + '\n'\
              '    Mask = ' + hexPadded32(self.mask) + '\n'\
              '    Permission = ' + str(self.permission) + '\n'\
              '    Signal = ' + str(self.signal) + '\n'\
              '    Default value = ' + hexPadded32(self.default) + '\n'\
              '    Is write pulse = ' + str(self.isWritePulse) + '\n'\

        if self.isWritePulse:
            ret += '\n        Write pulse length = ' + str(self.writePulseLength);

        if self.readPulseSignal is not None:
            ret += '\n    Read pulse signal = ' + str(self.readPulseSignal) + '\n'\
                   '        Read pulse length = ' + str(self.readPulseLength)
        return ret

    def getVhdlName(self):
        return self.name.replace(TOP_NODE_NAME + '.', '').replace('.', '_')

def main():
    print('Hi, parsing this top address table file: ' + ADDRESS_TABLE_TOP)

    tree = xml.parse(ADDRESS_TABLE_TOP)
    root = tree.getroot()[0]

    modules = []

    findRegisters(root, '', 0x0, modules, None)

    print('Modules:')
    for module in modules:
        module.regs.sort(key=lambda reg: reg.address * 100 + reg.msb)
        print('============================================================================')
        print(module.toString())
        print('============================================================================')
        for reg in module.regs:
            print(reg.toString())

    print('Writing constants file to ' + CONSTANTS_FILE)
    writeConstantsFile(modules, CONSTANTS_FILE)

def findRegisters(node, baseName, baseAddress, modules, currentModule):
    isModule = node.get('fw_is_module') is not None and node.get('fw_is_module') == 'true'
    name = baseName
    module = currentModule
    if baseName != '':
        name += '.'
    name += node.get('id')
    address = baseAddress

    if isModule:
        module = Module()
        module.name = name
        module.description = node.get('description')
        module.baseAddress = parseInt(node.get('address'))
        module.regAddressMsb = parseInt(node.get('fw_reg_addr_msb'))
        module.regAddressLsb = parseInt(node.get('fw_reg_addr_lsb'))
        module.file = node.get('fw_module_file')
        module.userClock = node.get('fw_user_clock_signal')
        module.busClock = node.get('fw_bus_clock_signal')
        module.busReset = node.get('fw_bus_reset_signal')
        module.masterBus = node.get('fw_master_bus_signal')
        module.slaveBus = node.get('fw_slave_bus_signal')
        if not module.isValid():
            error = 'One or more parameters for module ' + module.name + ' is missing... ' + module.toString()
            raise ValueError(error)
        modules.append(module)
    else:
        if node.get('address') is not None:
            address = baseAddress + parseInt(node.get('address'))

        if node.get('address') is not None and node.get('permission') is not None and node.get('mask') is not None:
            reg = Register()
            reg.name = name
            reg.address = address
            reg.description = node.get('description')
            reg.permission = node.get('permission')
            reg.mask = parseInt(node.get('mask'))
            msb, lsb = getLowHighFromBitmask(reg.mask)
            reg.msb = msb
            reg.lsb = lsb
            reg.signal = node.get('fw_signal')
            reg.default = parseInt(node.get('fw_default'))
            if node.get('fw_is_write_pulse') is not None:
                reg.isWritePulse = bool(node.get('fw_is_write_pulse') == 'true')
            if node.get('fw_write_pulse_length') is not None:
                reg.writePulseLength = parseInt(node.get('fw_write_pulse_length'))
            if node.get('fw_read_pulse_signal') is not None:
                reg.readPulseSignal = node.get('fw_read_pulse_signal')
            if node.get('fw_read_pulse_length') is not None:
                reg.readPulseLength = parseInt(node.get('fw_read_pulse_length'))

            if module is None:
                error = 'Module is not set, cannot add register ' + reg.name
                raise ValueError(error)
            if not reg.isValidReg():
                raise ValueError('One or more attributes for register %s are missing.. %s' % (reg.name, reg.toString()))

            module.addReg(reg)

    for child in node:
        findRegisters(child, name, address, modules, module)

def writeConstantsFile(modules, filename):
    f = open(filename, 'w')
    f.write('library IEEE;\n'\
            'use IEEE.STD_LOGIC_1164.all;\n\n')
    f.write('-----> !! This package is auto-generated from an address table file using <repo_root>/scripts/generate_registers.py !! <-----\n')
    f.write('package registers is\n')

    for module in modules:
        # find out the total number of 32bit registers (not very intelligent way, but ok, it works, we're not trying to save time here ;) )
        totalRegs32 = 0
        if len(module.regs) > 0:
            totalRegs32 = 1
            lastAddress = module.regs[0].address
            for reg in module.regs:
                if reg.address != lastAddress:
                    totalRegs32 += 1
                    lastAddress = reg.address

        f.write('\n')
        f.write('    --============================================================================\n')
        f.write('    --       >>> ' + module.getVhdlName() + ' Module <<<    base address: ' + hexPadded32(module.baseAddress) + '\n')
        f.write('    --\n')
        for line in tw.wrap(module.description, 75):
            f.write('    -- ' + line + '\n')
        f.write('    --============================================================================\n\n')

        f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_NUM_REGS : integer := ' + str(totalRegs32) + ';\n\n')

        for reg in module.regs:
            print('Writing register constants for ' + reg.name)
            f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_ADDR    : '\
                        'std_logic_vector(' + str(module.regAddressMsb) + ' downto ' + str(module.regAddressLsb) + ') := ' + \
                        vhdlHexPadded(reg.address, module.regAddressMsb - module.regAddressLsb + 1)  + ';\n')
            f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_HIGH    : '\
                        'integer := ' + str(reg.msb) + ';\n')
            f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_LOW     : '\
                        'integer := ' + str(reg.lsb) + ';\n')
            if reg.default is not None and reg.msb - reg.lsb > 0:
                f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_DEFAULT : '\
                            'std_logic_vector(' + str(reg.msb) + ' downto ' + str(reg.lsb) + ') := ' + \
                            vhdlHexPadded(reg.default, reg.msb - reg.lsb + 1)  + ';\n')
            elif reg.default is not None and reg.msb - reg.lsb == 0:
                f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_DEFAULT : '\
                            'std_logic := ' + \
                            vhdlHexPadded(reg.default, reg.msb - reg.lsb + 1)  + ';\n')
            f.write('\n')

    f.write('\n')
    f.write('end registers;\n')

def hex(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0x}".format(number)

def hexPadded32(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0{1}x}".format(number, 10)

def binaryPadded32(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0{1}b}".format(number, 34)

def vhdlHexPadded(number, numBits):
    if number is None:
        return 'None'
    else:
        hex32 = hexPadded32(number)
        binary32 = binaryPadded32(number)

        ret = ''

        # if the number is not aligned with hex nibbles, add  some binary in front
        numSingleBits = (numBits % 4 != 0)
        if (numSingleBits != 0):
            ret += "'" if numSingleBits == 1 else '"'
            # go back from the MSB down to the boundary of the most significant nibble
            for i in range(numBits, numBits // 4 * 4, -1):
                ret += binary32[i *  -1]
            ret += "'" if numSingleBits == 1 else '"'


        # add the right amount of hex characters

        if numBits // 4 > 0:
            if (numSingleBits != 0):
                ret += ' & '
            ret += 'x"'
            for i in range(numBits // 4, 0, -1):
                ret += hex32[i * -1]
            ret += '"'
        return ret


def parseInt(string):
    if string is None:
        return None
    elif string.startswith('0x'):
        return int(string, 16)
    elif string.startswith('0b'):
        return int(string, 2)
    else:
        return int(string)

def getLowHighFromBitmask(bitmask):
    binary32 = binaryPadded32(bitmask)
    lsb = -1
    msb = -1
    rangeDone = False
    for i in range(1, 33):
        if binary32[i * -1] == '1':
            if rangeDone == True:
                raise ValueError('Non-continuous bitmasks are not supported: %s' % hexPadded32(bitmask))
            if lsb == -1:
                lsb = i - 1
            msb = i - 1
        if lsb != -1 and binary32[i * -1] == '0':
            if rangeDone == False:
                rangeDone = True
    return msb, lsb

if __name__ == '__main__':
    main()