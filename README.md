# AWS_minecraft_terraform
Minecraft Java版(2023/6時点最新版のv1.20.1)の鯖をterraformでAWSのリソースを用いて構築できます。

アプリ起動基盤には仮想サーバであるEC2、minecraftのワールドバックアップデータはS3、
任意時間にCloudWatch/Lambda関数を利用してEC2の起動と停止が行えます。

なお、デフォルトではEC2の起動時間はJST 15:00, 停止時間はJST 22:00が設定してあります。

.pyを.pyのファイル名と同じ名称でそれぞれZipで圧縮してください。

インフラ構成図は``infra_structure.jpg``を参照してください。

* 注意点: S3のバケット名を変える場合``/template``内の初期実行シェルスクリプト内の値も変更する必要があるので注意してください
* EC2のAMIを変更する場合、初期実行シェルスクリプトが適切に動かない場合があります。その場合はスクリプトの内容をAMI環境に合わせて書き換えるか、実行せずに、手動で設定を行ってください。

## 使い方
事前にこのプロジェクトのルートディレクトリに``/.ssh``を作成して、EC2へのSSHログイン用の公開鍵、秘密鍵を作成しておいてください。ファイル名称は``id_rsa``です。

1. クライアントの環境変数にvariables.tfの変数名を参考にAWSのアクセスキー、シークレットキー、リージョンの情報を登録して利用できるようにしてください
2. ``/deploy``内の.pyを.pyのファイル名と同じ名称でそれぞれZipで圧縮してください。
3. ``terraform init``、``terraform plan``,``terraform apply``で一度目のデプロイを行ってください
4. ``/deploy``内の.pyのinstance_idの値はinstance_id.txtに出力された値にそれぞれ書き換えて手順2を再度行い、２度目の``terraform plan``,``terraform apply``で反映してください。
5. 3～4の手順でLambda関数が動くようになります。

## EC2インスタンスのパラメータ
AMI: Amazon Linux 2 最新版

インスタンスタイプ: ''t3a.medium''

EBS: 20GB, GP2

## 開発環境

Terraform v1.4.6


