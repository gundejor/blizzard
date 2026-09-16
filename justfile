default:
    @just --list

dcm-create:
    cd dcm && snow dcm create --if-not-exists -c blizzard-hq

dcm-plan:
    cd dcm && snow dcm plan -c blizzard-hq

dcm-deploy:
    cd dcm && snow dcm deploy -c blizzard-hq
