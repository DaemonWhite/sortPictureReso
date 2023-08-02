from setuptools import setup, find_packages

setup(
    name='pictureSorter',
    version='0.0.3',
    description='Mon super module Python',
    author='DaemonWhite',
    author_email='votre@email.com',
    packages=find_packages(),
    install_requires=[
        "Pillow==10.0.0",
        "pyxdg==0.28",
    ],
)
