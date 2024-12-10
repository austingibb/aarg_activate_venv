#!/bin/bash

function aarg_activate() {
    local DEBUG=false # Set to true for verbose debugging output
    local venv_root_path="$HOME/venvs" # Ensure this path is correctly set

    # Debugging function
    function debug_print() {
        if [ "$DEBUG" = true ]; then
            echo "[DEBUG] $1"
        fi
    }

    debug_print "Checking root path: $venv_root_path"
    if [ ! -d "$venv_root_path" ]; then
        echo "The specified root path for virtual environments does not exist or is not a directory: $venv_root_path"
        return 1
    fi

    echo "Available virtual environments:"
    local venvs=()
    local i=1

    debug_print "Contents of $venv_root_path:"
    debug_print "$(ls -la "$venv_root_path")"

    # Use a loop to iterate over directories, including hidden ones
    for venv in "$venv_root_path"/{*,.*}; do
        debug_print "Checking: $venv"
        if [ -d "$venv" ] && [ ! "$(basename "$venv")" = "." ] && [ ! "$(basename "$venv")" = ".." ]; then
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
    debug_print "Activation script path: $activate_script"
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
