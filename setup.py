from distutils.core import setup
from distutils.command.install_scripts import install_scripts
from os import environ, rename

if 'PKG_VER' in environ:
    VERSION = environ['PKG_VER']
else:
    VERSION = ''


class our_install_scripts(install_scripts):
    def run(self):
        install_scripts.run(self)
        for file in self.get_outputs():
            if file.endswith('.py'):
                rename(file, file[:-3])

setup(name = 'pybootchartgui',
      version = VERSION,
      description = 'Python bootchart graph utility',
      url = 'http://github.com/mmeeks/bootchart/',

      maintainer = 'Michael Meeks',
      maintainer_email = 'michael.meeks@novell.com',

      packages = ['pybootchartgui'],
      package_dir = {'pybootchartgui': 'pybootchartgui'},

      scripts = ['pybootchartgui.py'],
      cmdclass = {'install_scripts': our_install_scripts}
      )

