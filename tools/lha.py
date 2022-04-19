import lhafile

filepath = "C:\\Perso\\myCode\\OSME\\tools\\Savage_3.ym"

# # Create Lhafile instance from filename
# f = lhafile.Lhafile(filepath)

# # Print each file informaion in archive file.
# for info in f.infolist():
#    print (info.filename)
#    # Extract data from archive
#    f.read(info.filename)


import os
import sys

def extract_all(lzhname):
    """Extract files under current directory"""
    print ("Extract", lzhname, "...")
    # make directory to extract
    root, ext = os.path.splitext(lzhname)
    try:
        os.makedirs(root)
    except OSError :
        return
    # open lzh file and get file names in it.
    lha = lhafile.Lhafile(lzhname)
    files = [info.filename for info in lha.infolist()]
    # extract all files
    for filename in files:
        ufilename = filename # unicode(filename, "cp932")
        dirname = os.path.dirname(ufilename)
        basename = os.path.basename(ufilename)
        try:
            os.makedirs(os.path.join(root, dirname))
        except OSError :
            pass
        if basename:
            print (" extract", filename)
            open(os.path.join(root, dirname, basename), "wb").write(lha.read(filename))

if __name__ == '__main__':
    extract_all("C:\\Perso\\myCode\\OSME\\tools\\Savage_3.ym")# sys.argv[1])
