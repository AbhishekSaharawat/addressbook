sudo apt install java -y
sudo apt install git -y
sudo apt install maven -y

if [-d "addressbook-v1"]
then
  echo "repo is clone and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin main
else
 git clone https://github.com/AbhishekSaharawat/addressbook-v1.git
fi

cd /home/ec2-user/addressbook-v1
mvn package
