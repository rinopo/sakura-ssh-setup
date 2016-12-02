# sakura-ssh-setup

SSH 用のキー・ペアを作成して、さくらのレンタルサーバに公開鍵を登録する作業を簡単にする。

鍵を作成して登録しておくことで、パスワード無しで SSH ログインできるようになる。

＊以下、「XXX」はさくらのレンタルサーバのユーザー名（＝ 初期ドメイン名の XXX.sakura.ne.jp の XXX の部分）を指す。

## 概要

このスクリプトは以下のことを実行する。

- `ssh-keygen` で、ローカルの `~/.ssh` に、秘密鍵 / 公開鍵（`XXX` / `XXX.pub`）を作る。
- `ssh-copy-id` で、さくらのレンタルサーバの `~/.ssh/authorized_keys` に公開鍵を登録する。
- ローカルの `~/.ssh/config` に、ホスト名（`XXX.sakura.ne.jp`）、ユーザー名（`XXX`）、秘密鍵の情報を追記する。

次回以降、`ssh XXX` のみでログインできるようになる。


## 使い方

ローカルのターミナルで、下記を実行する。

```sh-session
$ ./sakura-ssh-setup.sh XXX
```


実行例：

```sh-session
$ ./sakura-ssh-setup.sh XXX
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in XXX.
Your public key has been saved in XXX.pub.
The key fingerprint is:
SHA256:qyJLN+snTN9L16qmFkqyrqf/arQd7x4uknJPsjJ9T1A user@machine.local
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|                 |
|      E          |
|     .           |
|    .   S        |
|  o +..  . .     |
| ooX+=ooo . .    |
|+.@=O==+o. .     |
|o%*X=XBooo.      |
+----[SHA256]-----+
/usr/local/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "XXX.pub"
/usr/local/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/local/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
XXX@XXX.sakura.ne.jp's password:

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'XXX@XXX.sakura.ne.jp'"
and check to make sure that only the key(s) you wanted were added.

/Users/xxx/.ssh/config にて下記のように設定されました：
user XXX
hostname XXX.sakura.ne.jp
identityfile ~/.ssh/XXX

次のコマンドで SSH できることを確認してください: ssh XXX
```

---

- この内容は非公式のものであり、さくらインターネット株式会社様とは一切関係ございません。
- 無保証です（[LICENSE](./LICENSE)）。
- Issue、PR、フォークは歓迎いたします。
