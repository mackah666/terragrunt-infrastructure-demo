#!/bin/bash

REPO_NAME=terragrunt-infrastructure-demo
REPO_URL=https://github.com/mackah666/terragrunt-infrastructure-demo
TEAMS_URL=https://awazecom.webhook.office.com/webhookb2/aabea965-89c2-42a4-bae1-2fb0314e0a14@bd846b68-132a-4a46-b1e7-d090e168c0a2/IncomingWebhook/b7722a845c91457a9511893fee392ded/60337754-a8e4-404d-965b-76ecbd4d3b44
LATEST_RELEASE_VERSION=$(cat version.txt)

curl --data-binary '{"@type": "MessageCard","@context": "http://schema.org/extensions","themeColor": "#7032cd","summary": "New Commit to '"$REPO_NAME"'","sections": [{"activityTitle": "'"$REPO_NAME"' has been updated.","facts": [{"name": "Repo","value": "'"$REPO_URL"'"},{"name": "Latest Release Version","value": "'"$LATEST_RELEASE_VERSION"'"},{"name": "Commit Log","value": "'"$(git log --author="^(?!${GIT_AUTHOR_NAME}).*$" --perl-regexp --pretty=format:"%s" -n1)"'"}],"markdown": true}],"potentialAction": [{"@type": "OpenUri","name": "View Release","targets": [{"os": "default","uri": "'"$REPO_URL/blob/v${LATEST_RELEASE_VERSION}/CHANGELOG.md"'"}]}]}' $TEAMS_URL
