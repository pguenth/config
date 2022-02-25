#!/usr/bin/xonsh

mapping = { '00' : 'wht','01' : 'yel' , '06' : 'org' , '02':'red','16':'lil','18':'pur','15':'blu','17':'lgr','04':'grn','10':'dgr','05':'sky','11':'cbl','07':'tel','14':'ga0','08':'ga1','13':'ga2','03':'gb0','09':'gb1','12':'gc0','no':'non'}

prefixes = ['color', 'fg', 'bg']
ocom = ""

for num, let in mapping.items():
    for pre in prefixes:
        ocom += " | sed 's/" + pre + "_" + num + "/" + pre + "_" + let + "/g'"

print("cat haug.vim" + ocom)
