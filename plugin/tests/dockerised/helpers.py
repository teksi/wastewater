import re
import shlex
import time
import xml.etree.ElementTree as ET
from pathlib import Path
from subprocess import run as sp_run

OUTPUT_DIR = Path(__file__).parent / "output"
OUTPUT_DIR.mkdir(exist_ok=True)
DEFAULT_CLI_PATH = Path("/usr/src/plugin/tww_cmd.py")


def get_output_filename(name: str) -> str:
    return str(OUTPUT_DIR / name)


def get_xtf_object(xtf_file, topicname, classname, tid):
    # from xml file
    tree = ET.parse(xtf_file)
    root = tree.getroot()
    for elem in root.iter():
        if "." in elem.tag:
            print(elem.tag)

    def get_namespace(element):
        m = re.match(r"\{.*\}", element.tag)
        return m.group(0) if m else ""

    namespace = get_namespace(root)

    interlis_objects = root.findall(
        "./{0}DATASECTION/{0}{1}/{0}{1}.{2}".format(namespace, topicname, classname)
    )
    print(
        f"{classname} TIDs:",
        [obj.attrib.get("TID") for obj in interlis_objects],
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


def run_cli(
    command: str,
    cli_path: str | Path | None = None,
) -> None:
    """
    Run a TEKSI CLI command inside the QGIS test environment.

    If already running inside the QGIS container, invoke the CLI directly.
    Otherwise, invoke it through docker compose.
    """

    start = time.time()

    effective_cli_path = Path(cli_path if cli_path is not None else DEFAULT_CLI_PATH)

    cli_arguments = shlex.split(
        command,
    )

    python_command = [
        "python3",
        str(
            effective_cli_path,
        ),
        *cli_arguments,
    ]

    running_inside_container = DEFAULT_CLI_PATH.is_file()

    if running_inside_container:
        cmd = [
            "xvfb-run",
            "-a",
            *python_command,
        ]
    else:
        inner_command = shlex.join(
            [
                "xvfb-run",
                "-a",
                *python_command,
            ]
        )

        cmd = [
            "docker",
            "compose",
            "exec",
            "-T",
            "qgis",
            "sh",
            "-c",
            inner_command,
        ]

    result = sp_run(
        cmd,
        capture_output=True,
        text=True,
    )

    duration = time.time() - start

    rendered_command = shlex.join(
        cmd,
    )

    print(f"CLI duration: {duration:.1f}s")
    print("COMMAND")
    print(rendered_command)
    print("STDOUT")
    print(result.stdout)
    print("STDERR")
    print(result.stderr)

    assert result.returncode == 0, (
        f"CLI command failed with exit code "
        f"{result.returncode}.\n"
        f"Command: {rendered_command}\n\n"
        f"STDOUT:\n{result.stdout}\n\n"
        f"STDERR:\n{result.stderr}"
    )
