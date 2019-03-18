#!/bin/bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

mapred historyserver
