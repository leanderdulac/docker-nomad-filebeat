#!/usr/bin/dumb-init /bin/sh
set -e

for VAR in $(env | grep ^NOMAD_ | cut -d= -f1); do
  if [ "$VAR" = "NOMAD_MEMORY_LIMIT" ]; then continue; fi
  if [ "$VAR" = "NOMAD_CPU_LIMIT" ]; then continue; fi
  if [ "$VAR" = "NOMAD_ALLOC_DIR" ]; then continue; fi
  if [ "$VAR" = "NOMAD_TASK_DIR" ]; then continue; fi

  if [ -n "$META" ]; then
    META="${META},${VAR}"
  else
    META="${VAR}"
  fi
done

sigil -f /filebeat.yml.tmpl nomad_meta=$META > /filebeat.yml

exec "$@"
