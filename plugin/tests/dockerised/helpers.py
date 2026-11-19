import re
import shlex
import time
import xml.etree.ElementTree as ET
from pathlib import Path
from subprocess import run as sp_run

from teksi_wastewater.interlis import model_config

OUTPUT_DIR = Path(__file__).parent / "output"
OUTPUT_DIR.mkdir(exist_ok=True)
DEFAULT_CLI_PATH = Path("/usr/src/plugin/teksi_wastewater/hooks/cli/importer_exporter.py")
SCHEMA_RECREATION_ARG = "--allow-schema-recreation"
DB_ARGS = (
    "--pghost db " "--pgdatabase tww " "--pguser postgres " "--pgpass postgres " "--pgport 5432"
)


def get_output_filename(name: str) -> str:
    return str(OUTPUT_DIR / name)


def topic_name(
    group: str,
    *,
    lang: str = "de",
) -> str:
    configured_model = model_config.interlis_models[group]

    model_name = configured_model.lang_name(
        lang,
    )
    topics = configured_model.topics_by_lang(
        lang,
    )

    if len(topics) != 1:
        raise AssertionError(
            "Expected exactly one topic for INTERLIS group "
            f"{group!r} and language {lang!r}, got "
            f"{sorted(topics)!r}."
        )

    topic_name = next(
        iter(
            topics,
        )
    )

    return f"{model_name}.{topic_name}"


def get_xtf_object(
    xtf_file: str | Path,
    topic_name: str,
    class_name: str,
    tid: str,
):
    tree = ET.parse(xtf_file)

    root = tree.getroot()

    namespace = root.tag.partition("}")[0] + "}" if root.tag.startswith("{") else ""

    data_section = root.find(f"{namespace}DATASECTION")

    if data_section is None:
        raise AssertionError(f"XTF file {xtf_file!s} has no DATASECTION.")

    expected_basket_tag = f"{namespace}{topic_name}"
    expected_object_tag = f"{namespace}{topic_name}.{class_name}"

    basket = next(
        (element for element in data_section if element.tag == expected_basket_tag),
        None,
    )

    if basket is None:
        available_baskets = tuple(element.tag.removeprefix(namespace) for element in data_section)

        print(f"Basket {topic_name!r} not found. " f"Available baskets: {available_baskets!r}")
        return None

    matching_objects = [element for element in basket if element.tag == expected_object_tag]

    print(
        f"{class_name} TIDs:",
        [element.attrib.get("TID") for element in matching_objects],
    )

    return next(
        (element for element in matching_objects if element.attrib.get("TID") == tid),
        None,
    )


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


def _container_output_file(
    name: str,
    container_output_dir: Path,
) -> Path:
    return container_output_dir / f"{name}.xtf"


def _host_exported_file(
    base_name: str,
    model_name: str,
    host_output_dir: Path,
) -> Path:
    return host_output_dir / f"{base_name}_{model_name}.xtf"


def _model_name(
    group: str,
    *,
    lang: str = "de",
) -> str:
    """
    Return the configured language-specific model name for a model group.
    """
    return model_config.interlis_models[group].lang_name(lang)


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
            'export PATH="/tmp/teksi-hooks-venv/bin:$PATH" '
            '&& export PYTHONPATH="/usr/src/plugin:/usr/src:/usr/share/qgis/python" '
            f"&& {inner_command}",
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


def data_file(
    name: str,
    host_data_dir: Path,
    container_data_dir: Path,
) -> Path:
    """
    Validate a fixture using the pytest runner's filesystem and return the
    corresponding path visible inside the qgis container.
    """
    host_path = host_data_dir / name

    assert host_path.is_file(), f"Missing INTERLIS test fixture in the checkout: {host_path}"

    return container_data_dir / name


def run_interlis_import(
    fixture_name: str,
    host_data_dir: Path,
    container_data_dir: Path,
) -> None:
    """E2E import of one XTF straight into the live schema (no diff job)."""
    xtf_file = data_file(fixture_name, host_data_dir, container_data_dir)
    run_cli(
        "interlis_import " f'--xtf_file "{xtf_file}" ' f"{SCHEMA_RECREATION_ARG} " f"{DB_ARGS}"
    )


def run_interlis_export(
    *,
    base_name: str,
    model_group: str,
    selected_ids: tuple[str, ...] = (),
    host_output_dir: Path,
    container_output_dir: Path,
) -> Path:
    """
    Export one model and return the host-visible output path.
    """
    export_model = _model_name(model_group)
    container_output = _container_output_file(base_name, container_output_dir)
    host_output = _host_exported_file(base_name, export_model, host_output_dir)

    # Prevent an output left by an earlier run from satisfying the test.
    host_output.unlink(missing_ok=True)

    selected_ids_arg = f'--selected_ids "{",".join(selected_ids)}" ' if selected_ids else ""

    run_cli(
        "interlis_export "
        f'--xtf_file "{container_output}" '
        f'--export_model "{export_model}" '
        f"{selected_ids_arg}"
        "--logs_next_to_file "
        f"{SCHEMA_RECREATION_ARG} "
        f"{DB_ARGS}"
    )

    assert host_output.is_file(), (
        "INTERLIS export command completed without creating the expected "
        f"host-visible output file: {host_output}"
    )

    return host_output
