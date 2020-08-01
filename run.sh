#!/bin/bash
docker-compose run iac aws ec2 describe-instances \
--query Reservations[*].Instances[*].NetworkInterfaces[*].{NetworkInterfaces:Association} --output json
