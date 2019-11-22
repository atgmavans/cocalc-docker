set -x
sudo docker stop cocalc-no-agpl-test
sudo docker rm cocalc-no-agpl-test
set -e
git pull
commit=`git ls-remote -h https://github.com/sagemathinc/cocalc master | awk '{print $1}'`
echo $commit | cut -c-12 > current_commit_noagpl
time sudo docker build --build-arg commit=$commit --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -t cocalc-no-agpl -f Dockerfile-no-agpl $@ .
sudo docker tag cocalc-no-agpl:latest sagemathinc/cocalc-no-agpl
sudo docker tag cocalc-no-agpl:latest sagemathinc/cocalc-no-agpl:`cat current_commit_noagpl`
sudo docker run --name=cocalc-no-agpl-test -d -v ~/cocalc-no-agpl-test:/projects -p 4044:443 sagemathinc/cocalc-no-agpl
