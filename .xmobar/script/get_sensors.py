import json
import subprocess
import os
import sys

with open(os.devnull, 'w') as devnull:
	sout = subprocess.run(['sensors', '-j'], stdout=subprocess.PIPE, stderr=devnull).stdout.decode('utf-8')
info = json.loads(sout)

with open(sys.argv[1]) as cfile:
	config = json.load(cfile)
	
def str_sensor(name, value, subname):
	outstr = ""
	
	if name == "":
		outstr = outstr + " "
	else:
		outstr = outstr + " " + name + " "
		
	if subname[:4] == "temp":
		outstr = outstr + f'{value:3.1f}' + "°C"
	elif subname[:3] == "fan":
		outstr = outstr + str(int(value)) + "RPM"
	elif subname[:2] == "in":
		outstr = outstr + f'{value:2.2f}' + "V"
	elif subname[:2] == "-m":
		outstr = outstr + f'{value:2.2f}' + subname[2:]
		
	outstr = outstr + ","
	
	return outstr

outstr = ""
for module, l1 in info.items():
	if module in config.keys():
		outstr = outstr + config[module]["name"] + ":"
		
		for cfgsensorname, cfgsensor in config[module]["use"].items():
			if cfgsensorname + " -m" in config[module]["use"]:
				result = 1.0
			else:
				result = 0.0
			scount = 0
			sname = ""
			
			for sensor, l2 in l1.items():
				if not type(l2) == dict:
					continue
					
				for j, value in l2.items():
					if j[-5:] == "input":
						if sensor in cfgsensor:
							if cfgsensorname + " -m" in config[module]["use"]:
								result *= float(value)
								sname = "-m" + config[module]["use"][cfgsensorname + " -m"]
							else:
								result += float(value)
								scount += 1	
								sname = j
							
			if cfgsensorname + " -m" in config[module]["use"]:
				value = result
			elif not scount == 0:
				value = result / float(scount)
			else:
				value = float('NaN')
				
			if not cfgsensorname[-2:] == "-m":
				outstr = outstr + str_sensor(cfgsensorname, value, sname)
		outstr = outstr[:-1] + " | "
	
print (outstr[:-3])
