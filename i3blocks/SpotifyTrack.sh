#!/usr/bin/env bash
playerctl --player=spotify metadata --format "{{ title }}  -  {{ artist }}"
