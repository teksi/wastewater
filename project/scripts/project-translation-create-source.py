#!/usr/bin/python3

import argparse

from qgis.core import QgsApplication, QgsProject

parser = argparse.ArgumentParser(description="Create QGIS project translation")
parser.add_argument("project")
parser.add_argument("-l", "--language", default="en")
args = parser.parse_args()

app = QgsApplication([], True)
app.setPrefixPath("/usr", True)
app.initQgis()


def print_message(message, tag, level):
    print(f"{tag}: {message}")


app.messageLog().messageReceived.connect(print_message)

project = QgsProject.instance()

assert project.read(args.project)

ok = True
for layer in project.mapLayers().values():
    layer_invalid = ""
    if not layer.isValid():
        ok = False
        layer_invalid = " *** INVALID ***"
    print(f" - layer {layer.name()}{layer_invalid}")

if not ok:
    raise ValueError("Some layers are invalid!")
project.generateTsFile(args.language)
