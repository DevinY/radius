# radius
建立image
<pre>
docker-compose build --no-cache
</pre>

產生自簽憑證
<pre>
openssl req -x509 \
-subj '/C=TW/ST=Taiwan/L=Panchiao/CN=ccc.tc' \
-nodes -newkey rsa:2048 -keyout server.key -out server.crt -days 3650
</pre>

由build好的image(目錄名稱_服務名稱)，取得預設的設定檔
<pre>
./getconfig.sh radius_radius
</pre>

啟動
<pre>
docker-compose up -d
</pre>

建立radius資料庫(密碼可自行調整)
<pre>
docker-compose exec db mysql -h db -e "create database radius"
docker-compose exec db mysql -h db -e "grant all on radius.* to 'radius'@'%' identified by 'hlOTg2ZmNk'"
</pre>

進入radius容器
<pre>
docker-compose exec radius bash
</pre>

驗證資料庫連線是正常的的(-p後是資料庫的密碼)
<pre>
mysql -uradius -phlOTg2ZmNk -h db
</pre>

補上如下字串，建立schema
<pre>
radius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql
</pre>

完整如下
<pre>
mysql -uradius -phlOTg2ZmNk -h db radius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql
</pre>

產生測試用使用者的語法，電腦需有PHP。
<pre>
./adduser.php devin test
INSERT into radius.radcheck (username,attribute,op,value) values("devin", "Crypt-Password", ":=", "$2y$10$TYKwxeU/RQ3B0l0oL4M1Eu7h8siL9b0qYltiGmmte3LjWnOrmDE/W");
</pre>

進入mysql將insert語法貼上。
<pre>
docker-compose exec db mysql
</pre>

以下提供相關attriubte說明，您可以透過程試產生不同的語法。

<pre>
 Header	    Attribute		Description
       ------	    ---------		-----------
       {clear}	    Cleartext-Password	Clear-text passwords
       {cleartext}  Cleartext-Password	Clear-text passwords
       {crypt}	    Crypt-Password	Unix-style "crypt"ed passwords
       {md5}	    MD5-Password	MD5 hashed passwords
       {base64_md5} MD5-Password	MD5 hashed passwords
       {smd5}	    SMD5-Password	MD5 hashed passwords, with a salt
       {sha}	    SHA-Password	SHA1 hashed passwords
		    SHA1-Password	SHA1 hashed passwords
       {ssha}	    SSHA-Password	SHA1 hashed passwords, with a salt
       {sha2}	    SHA2-Password	SHA2 hashed passwords
       {sha224}     SHA2-Password	SHA2 hashed passwords
       {sha256}     SHA2-Password	SHA2 hashed passwords
       {sha384}     SHA2-Password	SHA2 hashed passwords
       {sha512}     SHA2-Password	SHA2 hashed passwords
       {ssha224}    SSHA2-224-Password	SHA2 hashed passwords, with a salt
       {ssha256}    SSHA2-256-Password	SHA2 hashed passwords, with a salt
       {ssha384}    SSHA2-384-Password	SHA2 hashed passwords, with a salt
       {ssha512}    SSHA2-512-Password	SHA2 hashed passwords, with a salt
       {nt}	    NT-Password 	Windows NT hashed passwords
       {nthash}     NT-Password 	Windows NT hashed passwords
       {md4}	    NT-Password 	Windows NT hashed passwords
       {x-nthash}   NT-Password 	Windows NT hashed passwords
       {ns-mta-md5} NS-MTA-MD5-Password Netscape MTA MD5 hashed passwords
       {x- orcllmv} LM-Password 	Windows LANMAN hashed passwords
       {X- orclntv} NT-Password 	Windows NT hashed passwords
</pre>

修改clients.conf，例如:(secret可以修改，Wifi AP連線時使用相同的secret)
<pre>
client wifi {
	ipaddr = *
	secret = testing123
}
</pre>

修改sql檔，後端使用mysql資料庫連線。
因為在容器內連接，所以這裡應該不需要加密了。
<pre>
dialect = "mysql"
driver = "rlm_sql_${dialect}"

server = "db"
port = 3306
login = "radius"
password = "hlOTg2ZmNk"
#註解掉TLS
#	tls {
#		ca_file = "/etc/ssl/certs/my_ca.crt"
#		ca_path = "/etc/ssl/certs/"
#		certificate_file = "/etc/ssl/certs/private/client.crt"
#		private_key_file = "/etc/ssl/certs/private/client.key"
#		cipher = "DHE-RSA-AES256-SHA:AES128-SHA"
#		tls_required = yes
#		tls_check_cert = no
#		tls_check_cert_cn = no
#	}
</pre>


重啟容器使用參數--remove-orphans在啟動時看起來較沒問題。
<pre>
docker-compose down --remove-orphans
docker-compose up -d
</pre>

查看log可用
<pre>
docker-compose logs -f radius
</pre>

MacOS及iOS需透過Apple Configurator2描速檔才可以連到。
https://apps.apple.com/tw/app/apple-configurator-2/id1037126344?mt=12

Android連結，時請選擇
TTLS及PAP

# radius
