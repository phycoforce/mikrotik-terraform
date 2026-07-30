set quiet := true
set shell := ["bash", "-euo", "pipefail", "-c"]

[private]
default:
    just --list

# Initialise one device module (device: router | switch)
[group('tofu')]
init device:
    tofu -chdir=devices/{{ device }} init

# Initialise both device modules
[group('tofu')]
init-all:
    just init switch
    just init router

# Format all HCL
[group('tofu')]
fmt:
    tofu fmt -recursive devices

# Validate one device module
[group('tofu')]
validate device:
    tofu -chdir=devices/{{ device }} validate

# Preview changes for one device (device: router | switch)
[group('tofu')]
plan device:
    tofu -chdir=devices/{{ device }} plan

# Preview changes for both devices, sequentially
[group('tofu')]
plan-all:
    just plan switch
    just plan router

# Plan, confirm, then apply exactly that plan for one device
[group('tofu')]
apply device:
    #!/usr/bin/env bash
    set -euo pipefail
    cd devices/{{ device }}
    trap 'rm -f .tfplan' EXIT
    tofu plan -out=.tfplan
    read -rp $'\nApply this plan to {{ device }}? [y/N] ' answer
    if [[ "${answer}" == "y" || "${answer}" == "Y" ]]; then
        tofu apply .tfplan
    else
        echo "aborted — nothing applied"
    fi

# Apply both devices, sequentially (each with its own confirmation)
[group('tofu')]
apply-all:
    just apply switch
    just apply router

# Quick drift check across both modules (empty plan = healthy)
[group('tofu')]
drift:
    #!/usr/bin/env bash
    set -uo pipefail
    rc=0
    for d in switch router; do
        tofu -chdir=devices/$d plan -detailed-exitcode -no-color >/dev/null 2>&1
        case $? in
            0) echo "$d: clean (no drift)" ;;
            2) echo "$d: DRIFT — run: just plan $d"; rc=1 ;;
            *) echo "$d: ERROR — run: just plan $d"; rc=1 ;;
        esac
    done
    exit $rc

# List every resource in a device's state
[group('tofu')]
state device:
    tofu -chdir=devices/{{ device }} state list
