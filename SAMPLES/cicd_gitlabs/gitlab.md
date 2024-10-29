Установка gitlab раннеров
Создаем новые раннеры в гитлабе самом сначала, прописываем нужные теги: local, develop, prod
Установка самих раннеров, УСТАНАВЛИВАЕМ ВСЕ ЧЕРЕЗ SUDO:

```bash
sudo curl -L --output /usr/local/bin/gitlab-runner "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64"

sudo chmod +x /usr/local/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

sudo rm -rf /etc/systemd/system/gitlab-runner.service
sudo gitlab-runner install --user=root

sudo gitlab-runner start

# только сначала создаем раннер для проекта в разделе настройки cicd runners
sudo gitlab-runner register  --url https://gitlab.com  --token glrt-2tz3SnQJmHTtdntAjsUn
#для develop 
sudo gitlab-runner register  --url https://gitlab.com  --token glrt-4RMfwMf4xx9t4_e1A_eu

sudo gitlab-runner restart
