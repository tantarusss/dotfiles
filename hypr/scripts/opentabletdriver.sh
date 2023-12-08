#!/bin/sh
systemctl --user daemon-reload
systemctl --user enable opentabletdriver --now
