#!/bin/bash

(ssh-add -L > /dev/null) || ssh-add ~/.ssh/id_rsa
