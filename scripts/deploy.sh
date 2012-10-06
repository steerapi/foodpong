#!/bin/bash
ssh vertx@107.21.250.18 -i ~/key.pem "cd ~/foodpong && git pull"
ssh ubuntu@107.21.250.18 -i ~/key.pem sudo stop foodpong
ssh ubuntu@107.21.250.18 -i ~/key.pem sudo start foodpong