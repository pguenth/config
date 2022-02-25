# This is a sample commands.py.  You can add your own commands here.  #
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command
from ranger.ext.signals import SignalDispatcher


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()
    
# https://github.com/gotbletu/shownotes/blob/master/ranger_file_locate_fzf.md
class FzfBase(Command):
    def _command(self):
        return ""

    def execute(self):
        import subprocess

        command = self._command()
        if command == "":
            return
        
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

# fzf_locate
class plocate(FzfBase):
    """
    :plocate

    Search the current directory or a given directory with plocate
    and fzf

    Lists the contents of the current directory with plocate
    and passes the list to fzf

    See: https://github.com/junegunn/fzf
    """
    def _command(self):
        if self.arg(1):
            target_dir = self.rest(1)
        else:
            target_dir = self.fm.thisdir.path

        command = "plocate '" + target_dir + "' | fzf -i"
        
        return command

# fzf_plocate
class plocate_prefilter(FzfBase):
    """
    :plocate_prefilter

    Find a file using fzf and plocate

    Queries the file system with plocate and passes the list
    of results (in the current directory) to fzf

    See: https://github.com/junegunn/fzf
    """
    def _command(self):
        if not self.arg(1):
            self.fm.notify("No search string given.", bad=True)
            return ""
        
        plocate_query = self.rest(1)
            
        command = "plocate -bi " + plocate_query + " | grep \"" + self.fm.thisdir.path + "\" | fzf -e -i"
        return command
        

class fasd(Command):
    """
    :fasd

    Jump to directory using fasd
    """
    def execute(self):
        args = self.rest(1).split()
        if args:
            directories = self._get_directories(*args)
            if directories:
                self.fm.cd(directories[0])
            else:
                self.fm.notify("No results from fasd", bad=True)

    def tab(self, tabnum):
        start, current = self.start(1), self.rest(1)
        for path in self._get_directories(*current.split()):
            yield start + path

    @staticmethod
    def _get_directories(*args):
        import subprocess
        output = subprocess.check_output(["fasd", "-dl"] + list(args), universal_newlines=True)
        dirs = output.strip().split("\n")
        dirs.sort(reverse=True)  # Listed in ascending frecency
        return dirs
        
# base class for AVFS related tasks
class AVFSStatic(Command):
    def __init__(self, *args, **kwargs):
        Command.__init__(self, *args, **kwargs)
        
        self.avfs_path = os.path.expanduser("~/.avfs")
        
    def _mountavfs(self):
        if not os.path.ismount(self.avfs_path):
            self.fm.execute_command("mountavfs")
            
        return os.path.ismount(self.avfs_path)
    
class avfs_open(AVFSStatic):
    """
    :avfs_open

    Open an archive using avfs. If avfs is not mounted for the current
    user (in ~/.avfs), it is mounted on first call.
    """
        
    def _return(self):
        if not os.path.abspath(self.fm.thisfile.path).startswith(self.avfs_path + self.archive_path + "#"):
            self.fm.signal_unbind(self.handler)
            self.fm.select_file(self.archive_path)
            
    
    def execute(self):
        if not self._mountavfs():
            self.fm.notify("avfs is not available and could not be mounted", bad=True)
            return
            
        self.archive_path = os.path.abspath(self.fm.thisfile.path)
        self.fm.cd(self.avfs_path + self.archive_path + "#/")
        self.handler = self.fm.signal_bind('cd', self._return)
        
class avfs_remount(AVFSStatic):
    """
    :avfs_remount

    (Re)mount the avfs directory.
    """  
    
    def execute(self):
        self.fm.execute_command("umountavfs")
        if not self._mountavfs():
            self.fm.notify("avfs is not available and could not be mounted", bad=True)
            return
