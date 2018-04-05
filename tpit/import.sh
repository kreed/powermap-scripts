#!/bin/sh
for i in sheets/*.xlsx; do
	./import.py "$i"
done
