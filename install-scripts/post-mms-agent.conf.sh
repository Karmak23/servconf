#!/bin/bash -e

USER=mms-agent
LOGS=/var/log/mms

start mms-agent || restart mms-agent
