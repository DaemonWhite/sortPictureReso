#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

VIRTUAL_ENV="virtual_PictureSorter"

function init()
{
	python3 -m venv $VIRTUAL_ENV
	source $VIRTUAL_ENV/bin/activate
	pip install -r requirements.txt
}

init