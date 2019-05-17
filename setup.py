# -*- coding: utf-8 -*-
import setuptools

import os
from glob import glob

def main():
  with open("README.md", "r") as fp:
      long_description = fp.read()

  setuptools.setup(
      name="slyphon-jupyter-vim-binding",
      version="0.1.0.dev2",
      author="Jonathan Simms",
      author_email="slyphon@gmail.com",
      description="vim bindings for jupyter (slyphon fork)",
      license='MIT',
      keywords=['Jupyter', 'notebook'],
      platforms=['any'],
      long_description=long_description,
      long_description_content_type="text/markdown",
      url="https://github.com/slyphon/jupyter-vim-binding",

      packages=setuptools.find_packages('src'),
      package_dir={'': 'src'},
      include_package_data=True,

      install_requires=[
          'ipython_genutils',
          'jupyter_contrib_core >=0.3.3',
          'jupyter_core',
          'jupyter_nbextensions_configurator >=0.4.0',
          'nbconvert >=4.2',
          'notebook >=4.0',
          'pyyaml',
          'tornado',
          'traitlets >=4.1',
      ],

      py_modules=[
          os.path.splitext(os.path.basename(path))[0]
          for path in glob('src/*.py')
      ],
      zip_safe=False,
      classifiers=[
          "Intended Audience :: Developers",
          "Framework :: Jupyter",
          "Framework :: IPython",
          "License :: OSI Approved :: MIT License",
          "Topic :: Text Editors",
      ],
  )


if __name__ == '__main__':
    main()
