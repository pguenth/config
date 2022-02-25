import json
import re
import sys

def distance_from_xcolor(xcolor, r, g, b):
    dist = 0
    dist += (xcolor['rgb']['r'] - r) ** 2
    dist += (xcolor['rgb']['g'] - g) ** 2
    dist += (xcolor['rgb']['b'] - b) ** 2
    return dist


def xcolor_from_rgb(xtc, r, g, b):
    mindist = float("inf")
    minxcc = None
    for xc in xtc:
        d = distance_from_xcolor(xc, r, g, b)
        if d < mindist:
            mindist = d
            minxcc = xc['colorId']

    return minxcc

def convert_colors_from_str(colorstring):
    f = open("xterm-colors.json")
    xtc = json.load(f)

    colors = re.findall("#[0-9a-fA-F]{6}", colorstring)
    for c in colors:
        r = int(c[1:3], 16)
        g = int(c[3:5], 16)
        b = int(c[5:7], 16)

        xc = xcolor_from_rgb(xtc, r, g, b)
        print(c, '->', xc)
        
with open(sys.argv[1], mode='r') as inputfile:
    convert_colors_from_str(inputfile.read())
