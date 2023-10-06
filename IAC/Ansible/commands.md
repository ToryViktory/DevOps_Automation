sudo -i
yum install epel-release -y
yum install python3 -y
python3 -m pip install --user pipx
python3 -m pipx ensurepath

exit
sudo -i

pipx install --include-deps ansible
pipx upgrade ansible
