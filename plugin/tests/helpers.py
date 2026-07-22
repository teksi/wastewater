from subprocess import run as sp_run


def run_cli(command: str):
    cmd = f"""
    docker compose exec qgis sh -c '
    xvfb-run python /usr/src/plugin/tww_cmd.py {command}
    '
    """
    result = sp_run(cmd, shell=True)
    assert result.returncode == 0