#!/bin/bash
#
# Script to source environment files and start the service
#

source /home/pi/rnaEngine/bin/activate && python3 -m swagger_server
