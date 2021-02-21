#! /bin/bash
          # update os
          sudo yum update -y
          # set server hostname as jenkins-server
          sudo hostnamectl set-hostname jenkins-server
          # install git
          sudo yum install git -y
          # install java 11
          sudo yum install -y yum install java-11-openjdk
          # install jenkins
          wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
          rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
          sudo yum install jenkins -y
          sudo systemctl start jenkins
          sudo systemctl enable jenkins
          # install docker
          sudo yum install -y docker
          sudo systemctl start docker
          sudo systemctl enable docker
          sudo usermod -aG docker $USER
          sudo usermod -aG docker jenkins
          # configure docker as cloud agent for jenkins
          cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
          sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/127.0.0.1:2375 -H unix:\/\/\/var\/run\/docker.sock/g' /lib/systemd/system/docker.service
          sudo systemctl daemon-reload
          sudo systemctl restart docker
          sudo systemctl restart jenkins
          # install docker compose
          curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
          -o /usr/local/bin/docker-compose
          sudo chmod +x /usr/local/bin/docker-compose          
          mkdir -p /home/jenkins/.docker
          cd /home/jenkins/.docker
          # install python 3
          sudo yum install python3 -y
          # install ansible
          pip3 install ansible
          # install boto3
          pip3 install boto3