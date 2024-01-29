#!/usr/bin/env bash

for f in /usr/src/project/*\_*.ts
do
	lrelease $f ${f%.ts}.qm
done
