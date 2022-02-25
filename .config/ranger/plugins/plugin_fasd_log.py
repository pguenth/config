import ranger.api
import subprocess

try: from shlex import quote
except ImportError: from pipes import quote

old_hook_init = ranger.api.hook_init

def hook_init(fm):
    def fasd_add_file():
        subprocess.Popen(["fasd", "--add", quote(fm.thisfile.path)])
        
    def fasd_add_dir():
        subprocess.Popen(["fasd", "--add", quote(fm.thisdir.path)])
       
    fm.signal_bind('execute.before', fasd_add_file)
    fm.signal_bind('cd', fasd_add_dir)

    return old_hook_init(fm)

ranger.api.hook_init = hook_init
