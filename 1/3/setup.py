from distutils.core import setup, Extension

import os
import sysconfig

#extra_compile_args = sysconfig.get_config_var('CFLAGS').split()
#extra_compile_args += ["-std=c++11", "-Wall", "-Wextra"]


module = Extension('_pywidgets',
	include_dirs = ['/usr/local/Cellar/qt/5.9.2/include'],
	sources = ['pywidgets.c', 'widgets.cpp'],
	#extra_compile_args = extra_compile_args,
	language = 'c++11')

setup(name = '_pywidgets', 
	  version = '1.0', 
	  ext_modules = [module])