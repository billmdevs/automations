#!/bin/bash

# Logical conditions:
# 0. If not already in virtualenv:
# 0.1. If virtualenv already exists activate it,
# 0.2. If not create it with global packages, update pip then activate it
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
    local py=${1:-python3.8}
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
            echo "Upgrading pip3"
            ${py} -m pip3 install --upgrade pip3

            # Checking for the application type, creating and installing the appriopriate directories and packages successively
            if ["${app_type}" == "mlapp"]; then
                echo "Creating directories and installing machine learning packages..."
                mkdir data src models notebooks
                touch data/train.csv data/test.csv
                touch src/train.py src/inference.py src/models.py src/config.py src/data_pipeline.py
                touch notebooks/exploration.ipynb notebooks/check_data.ipynb

                ${py} -m pip3 install numpy pandas scikit-learn torch torchvision torchaudio tensorflow
            elif ["${app_type}" == "webapp"]; then
                echo "Creating directories and installing web development packages"
                mkdir backend frontend backend/src backend/sql backend/tests frontend/tests
                touch backend/__init__.py backend/admin.py backend/app.py backend/config.py backend/controllers.py backend/data_model.py backend/manage.py backend/requirements.txt
                ${py} -m pip3 install flask django
                cd frontend/
                npm install react react-dom --save
                cd ..

        else
            echo "Virtual environment  ${venv} already exists, activating..."
            source ${bin}
        fi
    else
        echo "Already in a virtual environment!"
    fi
}
crenvndirs