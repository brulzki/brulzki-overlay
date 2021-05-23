import setuptools

with open("text/README", "r") as fh:
    long_description = fh.read()

with open("MMA/gbl.py", "r") as fh:
    for line in fh.readlines():
        if line.startswith("version ="):
            exec(line)

setuptools.setup(
    name="MMA",
    version=version,
    author="Bob van der Poel",
    author_email="bob@mellowood.ca",
    description="MMA - Musical MIDI Accompaniment",
    license='GPLv2',
    long_description=long_description,
    long_description_content_type="text/plain",
    url="https://www.mellowood.ca/mma/",
    packages=['MMA'],
    scripts=['mma', 'mma-libdoc', 'mma-renum', 'mma-splitrec'],
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GPL-v2 License",
        "Operating System :: Linux",
    ],
)
