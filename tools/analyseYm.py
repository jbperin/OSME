from xlsxwriter import Workbook
import ym


def main ():

    fileradname = 'Output'
    
    aYM = ym.YM()
    aYM.load(f'C:\\Perso\\myCode\\OSME\\tools\\{fileradname}.ym')

    def computeChanFreq(coarse, fine):
        if ((coarse !=0) or (fine!=0)):
            return aYM.header['masterClockHz']/(16*(coarse*256+fine))
        return 0

    def computeEnvFreq(coarse, fine):
        if ((coarse !=0) or (fine!=0)):
            return aYM.header['masterClockHz']/(256*(coarse*256+fine))
        return 0

    def computeNoiseFreq(period):
        if (period != 0):
            return aYM.header['masterClockHz']/(16*period)
        return 0
    
    wb=Workbook(f'C:\\Perso\\myCode\\OSME\\tools\\{fileradname}.xlsx')
    ws=wb.add_worksheet("Frames")
    ws.write(0,0,"time")
    ws.write(0,1,"freqA")
    ws.write(0,2,"ampA")
    ws.write(0,3,"mixA")
    ws.write(0,4,"freqB")
    ws.write(0,5,"ampB")
    ws.write(0,6,"mixB")
    ws.write(0,7,"freqC")
    ws.write(0,8,"ampC")
    ws.write(0,9,"mixC")
    ws.write(0,10,"freqenv")
    ws.write(0,11,"envcont")
    ws.write(0,12,"noisefreq")
    ws.write(0,13,"mix")
    row=1
    for fra in aYM.frames:
        # print (fra)
        time = (row-1)/aYM.header['origPlayerFrames']

        freqA = computeChanFreq(fra['r1'], fra['r0']) # 1000000/(16*(fra['r1']*256+fra['r0']))
        freqB = computeChanFreq(fra['r3'], fra['r2']) # 1000000/(16*(fra['r3']*256+fra['r2']))
        freqC = computeChanFreq(fra['r5'], fra['r4']) # 1000000/(16*(fra['r5']*256+fra['r4']))
        ampA = fra['r10']
        ampB = fra['r11']
        ampC = fra['r12']
        env = computeEnvFreq(fra['r14'], fra['r13']) # 1000000/(256*(fra['r14']*256+fra['r13']))
        envcont = fra['r15']
        noise = computeNoiseFreq(fra['r6']) # 1000000/(16*fra['r6'])
        mixer = fra['r7']
        mixA = mixer & 0x09
        if (mixA == 0) : mixChanA = "TN"
        elif (mixA == 1) : mixChanA = "tN"
        elif (mixA == 8) : mixChanA = "Tn"
        elif (mixA == 9) : mixChanA = "tn"
        mixB = (mixer & 0x12)>>1
        if   (mixB == 0) : mixChanB = "TN"
        elif (mixB == 1) : mixChanB = "tN"
        elif (mixB == 8) : mixChanB = "Tn"
        elif (mixB == 9) : mixChanB = "tn"
        mixC = (mixer & 0x24)>>2
        if   (mixC == 0) : mixChanC = "TN"
        elif (mixC == 1) : mixChanC = "tN"
        elif (mixC == 8) : mixChanC = "Tn"
        elif (mixC == 9) : mixChanC = "tn"

        ws.write(row,0,time)
        ws.write(row,1,freqA)
        ws.write(row,2,ampA)
        ws.write(row,3,mixChanA)
        ws.write(row,4,freqB)
        ws.write(row,5,ampB)
        ws.write(row,6,mixChanB)
        ws.write(row,7,freqC)
        ws.write(row,8,ampC)
        ws.write(row,9,mixChanC)
        ws.write(row,10,env)
        ws.write(row,11,envcont)
        ws.write(row,12,noise)
        ws.write(row,13,mixer)
        row+=1
    wb.close()

if __name__ == '__main__':
    main()
