#!/bin/bash

yum update -y

# Javaなどのインストール
yum install -y java-17-amazon-corretto-devel git

mkdir ~/minecraft
cd ~/minecraft

# PaperMCのインストール
wget https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/18/downloads/paper-1.20.1-18.jar
chmod +x paper-1.20.1-18.jar

java -Xmx2G -jar paper-1.20.1-18.jar nogui

# eula.txtの変更
sed -i '/eula=false/ s/false/true/' eula.txt || echo "eula=true" >> eula.txt

# sedコマンドで置換して一時ファイルに保存
sed "s/$search_string/$replace_string/g" "$file" > "$file.tmp"

# 一時ファイルを元ファイルに上書き保存
mv "$file.tmp" "$file"

# 起動シェルスクリプトの作成
cat << 'EOF' > launch.sh
#!/bin/sh
cd ~/minecraft

zip $(date "+%Y%m%d%H").zip -r world world_nether world_the_end/
aws s3 cp $(date "+%Y%m%d%H").zip s3://unit-minecraft-world/world_backup/world/ --storage-class ONEZONE_IA
rm -f $(date "+%Y%m%d%H").zip

java -Xmx2G -Xmx2G -jar paper-1.20.1-18.jar nogui
EOF

chmod +x launch.sh

cat << EOF > /../../etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network-online.target

[Service]
User=ec2-user

WorkingDirectory=/root/minecraft
ExecStart=/bin/bash /root/minecraft/launch.sh
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable minecraft
systemctl start minecraft