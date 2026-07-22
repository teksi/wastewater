from subprocess import run as sp_run


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
