#!/bin/bash

# Logical conditions:
# 0. If not already in virtualenv:
# 0.1. If virtualenv already exists activate it,
# 0.2. If not create it with global packages, update pip then activate it
# 0.0.1. If application structure type is mlapp create directory structures and install appropriate packages
# 0.0.2. ElseIf application structure type is webapp create directory structures and install appropriate packages
# 1. If already in virtualenv: just give info
#
# Usage:
# Without arguments it will create virtualenv named `.venv` with `python3.8` version
# $ ve
# or for a specific python version
# $ ve python3.9
# or for a specific python version and environment name;
# $ ve python3.9 ./.venv-diff
crenvndirs() {
    local py=${1:-python3}
    local venv="${2:-./.venv}" # Creating venv as a private directory is cool so as not to clutter the directory!
    local app_type="${3:-none}"

    local bin="${venv}/bin/activate"

    # If not already in virtualenv
    # $VIRTUAL_ENV is being set from $venv/bin/activate script
	if [ -z "${VIRTUAL_ENV}" ]; then
        if [ ! -d ${venv} ]; then
            echo "Creating and activating virtual environment ${venv}"
            ${py} -m venv ${venv} --system-site-package
            #echo "export PYTHON=${py}" >> ${bin}    # overwrite ${python} on .zshenv
            source ${bin}
            echo "Upgrading pip"
            ${py} -m pip install --upgrade pip

            # Checking for the application type, creating and installing the appriopriate directories and packages successively
            if [ "${app_type}" = "mlapp" ]; then
                echo "Creating directories and installing machine learning packages..."
                
                mkdir data src models notebooks
                touch data/train.csv data/test.csv
                touch src/train.py src/inference.py src/models.py src/config.py src/data_pipeline.py
                touch notebooks/exploration.ipynb notebooks/check_data.ipynb

                ${py} -m pip install numpy pandas scikit-learn torch torchvision torchaudio tensorflow

                echo "Finished setting up machine learning environment and it suitable basic packages"
            elif ["${app_type}" = "webapp"]; then
                echo "Creating directories and installing web development packages"
                
                mkdir backend backend/src backend/sql backend/tests
                touch backend/__init__.py backend/admin.py backend/app.py backend/config.py backend/controllers.py backend/data_model.py backend/manage.py backend/requirements.txt
                ${py} -m pip install flask django
                npx create-react-app frontend
                mkdir frontend/tests                
                
                echo "Finished setting up web development environment and its suitable basic packages"
            fi

        else
            echo "Virtual environment  ${venv} already exists, activating..."
            source ${bin}
        fi
    else
        echo "Already in a virtual environment!"
    fi
}