# To create a directory mattermost container can write to.
sudo mkdir -pv ./volumes/app/mattermost/{data,logs,config}
chown -R 2000:2000 ./volumes/app/mattermost/
