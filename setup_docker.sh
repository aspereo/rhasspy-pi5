curl -fsSL https://get.docker.com | sudo sh

sudo usermod -aG docker $USER
newgrp docker

docker run hello-world

sudo systemctl enable docker
sudo systemctl start docker
