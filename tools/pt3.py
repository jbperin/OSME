import struct

# $000/000 ($0D/13)   "ProTracker 3." identification string.

# $00D/013 ($01/01)   "7" (or "6", "5", "4", or even "3") the number of the exposure. => Version
#                     It should be noted that PTV3.4x and lower modules are used another, "unbalanced" volume table, and in the modules PTv3.3x
#                     Alternative frequency table "Pro Tracker" is used, not coinciding with the eponymous modern!)

# $00E/014 ($10/16)   " compilation of " (optional - any text of this length).

# $01E/030 ($20/32)   the name of the module (ASCII, lat) unused symbols fulled with spaces.

# $03E/062 ($04/04)   " by " (optional - any 4 characters)

# $042/066 ($20/32)   author's name (ASCII, lat, unused symbols fulled with spaces).

# $062/098 ($01/01)   " " - one space (any character).
#                     (i.e., the first 99 bytes of the module form the corresponding row)

# $063/099 ($01/01)   frequency table number: 0 = Pro Tracker, 1 = Sound Tracker, 2 = ASM or PSC, 3 = RealSound. 
#                     The label occupies 192 bytes and contains the values ​​of the periods for 96 notes starting from C-1 (up to the first octave).
#                     The period is the value inverse to the frequency of the note placed in the corresponding registers AY. 
#                     The lower bytes (here and below, behind one the exception to be indicated) are kept first. 
#                     Compiler PT stores the table corresponding to the module in the player's body by relative to address 512. 
#                     It stores the volume table in that same body of the player at a relative address 256.

# $064/100 ($01/01)   Tempo value. => Delay

# $065/101 ($01/01)   song end (1 = only one item in the module) - not used in the player.

# $066/102 ($01/01)   song loop (0 = loop to the beginning).

# $067/103 ($02/02)   Psa_chn = offset from the beginning of the module to the table of patterns. => PatsPtr

# $069/105 ($20*2)    offsets from the beginning of the module to the samples, starting with the zero- => SamPtrs
#          (32*2)     left sample. Two bytes per sample. Zero sample in current
#                     versions of the editor is not used. For all unused samples offset is zero.

# $0A9/169 ($10*2)    offsets from the beginning of the module to the ornaments, starting with zero. => OrnPtrs
#          (16*2)     Two bytes per ornament. Null ornament is a lack of ornament, so the data of this ornament (see below) contain 0,1,0. 
#                     You can use this ornament at your discretion, BUT then in the song it will be impossible to use samples without ornaments. 
#                     For of all unused ornaments, the offset is zero.

# $0C9/201 (?)        List of items (in play order): contains pattern numbers (0 ... 84) multiplied by 3. 
#                     The table ends with the code #ff. 
#                     Pro Tracker v3.3x-v3.5x does not support more than 42 patterns.
#                     Pro Tracker v3.6x does not support more than 46 patterns.
#                     Pro Tracker v3.7 ?

# + Psa_chn (?*6)     A pattern pointer. 
#                     Contains for each of the displacement Patterns:
#                     ++ 0 (2) to the channel data block (track) A
#                     ++ 2 (2) to the channel data block (track) B
#                     ++ 4 (2) to the channel data block (track) C.
#                     The noise offset data (a separate column in the editor) are fed to channel B.

# + ? (? *?)          blocks of data channels, that is, tracks.

def readFFTerminatedList(bytes_read, idx_data):
    vals = []
    idx=idx_data
    while True:
        c = bytes_read[idx]
        # print (idx_data, c)
        idx = idx+1
        if (c == 0xff) : break
        vals.append(c)
    return idx, vals



class PT3:
    def __init__(self, ):
        pass

    def load(self,filepath):
        with open (filepath, "rb") as ficin:
            buffer = ficin.read()
        filesize = len(buffer)
        print (f"File is {filesize} bytes long")


        identification_string = struct.unpack("13s", buffer[0:13])[0].decode("utf-8")
        print (f"Identification: {identification_string}")
        idx_data = 0
        s = struct.Struct('<13s B 16s 32s 4s 32s c B B B B H')
        unpacked = s.unpack(buffer[idx_data:s.size])
        self.header = {
            'identification':unpacked[0].decode("utf-8"),
            'exposure':unpacked[1],
            'compilation':unpacked[2].decode("utf-8"),
            'title':unpacked[3],
            'author':unpacked[5],
            'freqs':unpacked[7],
            'tempo':unpacked[8],
            'end':unpacked[9],
            'loop':unpacked[10],
            'PatsPtr': unpacked[11]
        }    
        print (f'ident:{self.header["identification"]}|expo:{self.header["exposure"]}|{self.header["compilation"]}|\n'
         ,f'title:{self.header["title"]}|author:{self.header["author"]}|freqs:{self.header["freqs"]}|tempo:{self.header["tempo"]}|\n'
         ,f'end:{self.header["end"]}|loop:{self.header["loop"]}|PatsPtr:{self.header["PatsPtr"]}|\n'
         )

        idx_data += s.size

        s = struct.Struct('<32H')
        unpacked = s.unpack(buffer[idx_data:idx_data+s.size])
        SamPtrs = unpacked
        print ("SamPtrs:", SamPtrs)

        idx_data += s.size

        s = struct.Struct('<16H')
        unpacked = s.unpack(buffer[idx_data:idx_data+s.size])
        OrnPtrs = unpacked
        print ("OrnPtrs:", OrnPtrs)

        idx_data += s.size

        idx_data , self.items=readFFTerminatedList(buffer, idx_data)
        print ('items:',self.items)
        print (f"idx_data : {idx_data}")

        print ([x for x in buffer[idx_data:idx_data+60]])
        print ([x for x in buffer[SamPtrs[1]:OrnPtrs[0]]])
        print ([x for x in buffer[OrnPtrs[0]:filesize]])
        # readFFTerminatedList(bytes_read, idx_data)

        # if format in ['YM2!', 'YM3!', 'YM4!', 'YM5!', 'YM6!']:
        #     prgint (f"Not compressed format:  {format}")
        #     print (len(buffer))
        # else:
        #     lha = lhafile.Lhafile(filepath)
        #     files = [info.filename for info in lha.infolist()]
        #     filename = files[0]
        #     buffer = lha.read(filename)
        #     print (len(buffer))
        #     format = struct.unpack('4s',buffer[0:4])[0].decode("utf-8")
        #     if format in ['YM2!', 'YM3!', 'YM4!', 'YM5!', 'YM6!']:
        #         print (f"LHA compressed format:  {format}")
        #     else:
        #         print (f"Unrecognized YM format ..")
        #         return
        # if (format == 'YM2!'):
        #     pass
        # elif (format == 'YM3!'):
        #     pass
        # elif (format == 'YM4!'):
        #     pass
        # elif (format == 'YM5!'):
        #     self._ym5decode(buffer)
        # elif (format == 'YM6!'):
        #     self._ym6decode(buffer)



def main ():
    aPT3 = PT3()
    # aPT3.load('C:\\Perso\\myCode\\OSME\\tools\\BOOM.pt3')
    aPT3.load('C:\\Perso\\myCode\\OSME\\tools\\MyModule.pt3')


if __name__ == '__main__':
    main()


