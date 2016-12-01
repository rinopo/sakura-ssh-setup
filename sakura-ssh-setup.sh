#!/usr/bin/env bash

# Fail on command errors and unset variables.
set -e -u -o pipefail

# Prevent commands misbehaving due to locale differences.
export LC_ALL=C



#### Preparation.

## Arguments.

readonly User=$1


## Audits.

# さくらのレンタルサーバのユーザー名として正当か？
#
# > ・半角英数字とハイフン(-)が使えます。
# > ・3～16文字でご設定ください。
# > ・数字のみの文字列、最初および末尾のハイフン(-)は利用できません。
# cf. https://secure.sakura.ad.jp/signup2/rentalserver.php

readonly Regex1="^[0-9a-z]{1}[0-9a-z-]{1,14}[0-9a-z]{1}$"
readonly Regex2="^[0-9]+$"
if [[ ! ${User} =~ ${Regex1} || ${User} =~ ${Regex2} ]]; then
  echo "❌️ さくらのレンタルサーバのユーザー名を正しく入力してください。"
  exit 1
fi

# ssh-copy-id コマンド使えるか？

if ! type ssh-copy-id > /dev/null ; then
  echo "❌️ ssh-copy-id コマンドがないか、実行権限がありません。"
  echo "ssh-copy-id コマンドをインストールしてください。"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "例: brew install ssh-copy-id"
    echo "brew コマンドが使えない場合は、まず brew コマンドをインストールしてください:"
    echo "http://brew.sh/index_ja.html"
  fi
  if ( type apt-get ); then
    echo "例: apt-get install openssh-client"
  fi
  if ( type yum ); then
    echo "例: yum install openssh-client"
  fi
  exit 1
fi


## Constants.

readonly Ssh_dir=${HOME}/.ssh



#### Actually do something.

# Change working directory.
pushd ${Ssh_dir} > /dev/null

# Generate key pair.
ssh-keygen -t rsa -f ${User}

# Add public key to the remote server's authorized_keys.
ssh-copy-id -i ${User}.pub ${User}@${User}.sakura.ne.jp

# Append config entry.
cat << EOT >> config

Host ${User}
  HostName ${User}.sakura.ne.jp
  User ${User}
  IdentityFile ~/.ssh/${User}
EOT

# Confirm result.
echo "${Ssh_dir}/config にて下記のように設定されました："
ssh -G ${User} | grep -w "user"
ssh -G ${User} | grep -w "hostname"
ssh -G ${User} | grep -w "identityfile"

echo ""
echo "次のコマンドで SSH できることを確認してください: ssh ${User}"

# Change the working directory back to original.
popd > /dev/null



exit 0
