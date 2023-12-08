#!/bin/bash
output=$(wpctl status -n | grep alsa_output)
echo $output
