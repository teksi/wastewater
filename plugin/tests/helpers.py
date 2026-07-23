import re
import xml.etree.ElementTree as ET
from pathlib import Path
from subprocess import run as sp_run

OUTPUT_DIR = Path(__file__).parent / "output"
OUTPUT_DIR.mkdir(exist_ok=True)


def get_output_filename(name: str) -> str:
    return str(OUTPUT_DIR / name)


def get_xtf_object(xtf_file, topicname, classname, tid):
    # from xml file
    tree = ET.parse(xtf_file)
    root = tree.getroot()

    def get_namespace(element):
        m = re.match(r"\{.*\}", element.tag)
        return m.group(0) if m else ""

    namespace = get_namespace(root)

    interlis_objects = root.findall(
        "./{0}DATASECTION/{0}{1}/{0}{1}.{2}".format(namespace, topicname, classname)
    )

    for interlis_object in interlis_objects:
        xml_tid = interlis_object.attrib.get("TID", None)

        if xml_tid == tid:
            return interlis_object

    return None


def get_xtf_object_node_text(
    xtf_file, topicname: str, classname: str, tid: str, attributename: str
) -> str:

    # from xml file
    tree = ET.parse(xtf_file)
    root = tree.getroot()

    def get_namespace(element):
        m = re.match(r"\{.*\}", element.tag)
        return m.group(0) if m else ""

    namespace: str = get_namespace(root)

    # findtext with Clark Notation: https://de.wikipedia.org/wiki/Namensraum_(XML)#Namensraum-Notation_nach_James_Clark
    return root.findtext(
        f"./{namespace}DATASECTION/{namespace}{topicname}"
        f"/{namespace}{topicname}.{classname}[@TID='{tid}']"
        f"/{namespace}{attributename}"
    )


def run_cli(command: str):
    cmd = f"""
    docker compose exec qgis sh -c '
    xvfb-run python3 /usr/src/plugin/tww_cmd.py {command}
    '
    """

    result = sp_run(cmd, shell=True, capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)
    assert result.returncode == 0
