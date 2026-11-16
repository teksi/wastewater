#!/usr/bin/env bash
set -euo pipefail

service="${1:-db}"
timeout_seconds="${2:-180}"
deadline=$((SECONDS + timeout_seconds))

container_id="$(docker compose ps -q "${service}")"
if [ -z "${container_id}" ]; then
  echo "No container found for Compose service ${service}." >&2
  docker compose ps --all
  exit 1
fi

while (( SECONDS < deadline )); do
  state="$(docker inspect --format '{{.State.Status}}' "${container_id}" 2>/dev/null || true)"
  pid1_comm="$(docker compose exec -T "${service}" sh -c 'cat /proc/1/comm 2>/dev/null || true' 2>/dev/null | tr -d '
')"

  if [ "${state}" = "exited" ] || [ "${state}" = "dead" ]; then
    echo "PostgreSQL container stopped while waiting." >&2
    docker compose logs --no-color --tail=300 "${service}"
    exit 1
  fi

  # During first-time initialization the official image runs a temporary
  # postmaster while PID 1 remains docker-entrypoint.sh. pg_isready can succeed
  # during that window. The final server is ready only after PID 1 has exec'd
  # postgres and a real SQL query succeeds.
  if [ "${pid1_comm}" = "postgres" ]     && docker compose exec -T "${service}" pg_isready -h localhost -U postgres -d postgres >/dev/null 2>&1     && docker compose exec -T "${service}" psql -h localhost -U postgres -d postgres -v ON_ERROR_STOP=1 -Atc 'SELECT 1' | grep -qx '1'; then
    first_start="$(docker compose exec -T "${service}" psql -h localhost -U postgres -d postgres -Atc 'SELECT pg_postmaster_start_time();')"
    sleep 2
    second_start="$(docker compose exec -T "${service}" psql -h localhost -U postgres -d postgres -Atc 'SELECT pg_postmaster_start_time();')"

    if [ "${first_start}" = "${second_start}" ]; then
      echo "Final PostgreSQL server is ready (started ${second_start})."
      exit 0
    fi
  fi

  echo "Waiting for final PostgreSQL server: state=${state}, pid1=${pid1_comm:-unknown}"
  sleep 2
done

echo "Timed out waiting for final PostgreSQL server." >&2
docker compose ps --all
docker compose logs --no-color --tail=300 "${service}"
exit 1
