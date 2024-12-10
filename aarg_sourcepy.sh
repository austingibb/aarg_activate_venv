#!/bin/bash

function aarg_activate() {
    local venv_root_path="$HOME/venvs" # Ensure this path is correctly set

    # Check if venv_root_path exists and is a directory
    if [ ! -d "$venv_root_path" ]; then
        echo "The specified root path for virtual environments does not exist or is not a directory: $venv_root_path"
        return 1
    fi

    echo "Available virtual environments:"
    local venvs=()
    local i=1

    # Use a loop to iterate over directories
    for venv in "$venv_root_path"/*; do
        if [ -d "$venv" ]; then
            venvs[i]="$(basename "$venv")"
            echo "$i) ${venvs[i]}"
            i=$((i + 1))
        fi
    done

    if [ ${#venvs[@]} -eq 0 ]; then
        echo "No virtual environments found in $venv_root_path."
        return 1
    fi

    echo "Enter the number of the virtual environment to activate:"
    read -r selection

    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -ge $i ]; then
        echo "Invalid selection. Exiting."
        return 1
    fi

    local activate_script="${venv_root_path}/${venvs[selection]}/bin/activate"
    if [ -f "$activate_script" ]; then
        echo "Activating virtual environment: ${venvs[selection]}"
        # shellcheck disable=SC1090
        source "$activate_script"
    else
        echo "Activation script not found for ${venvs[selection]}."
        return 1
    fi
}

# Directly invoke the function for immediate action
aarg_activate
