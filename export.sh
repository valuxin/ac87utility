#!/bin/sh

pass_enc="valuxin@2018"

cp txhelper.sh ./bin/txhelper
cp ac87utility.sh ac87utility

./data_update.sh

cat <<'EOF' >./build/ac87utility
#!/bin/sh

## Files

ac87utility()
{
cat <<'EOF' | openssl aes-128-cbc -a -d -salt -k "valuxin@2018" | gunzip | tar -xv
EOF
tar zc ac87utility data start_0 | openssl aes-128-cbc -a -salt -k "$pass_enc" >>./build/ac87utility && echo "EOF" >>./build/ac87utility
echo "}" >>./build/ac87utility
echo "" >>./build/ac87utility
cat <<'EOF' >>./build/ac87utility
## Action

runfrom_path=$PWD
{
export runfrom_path
mkdir /tmp/ac87utility
cd /tmp/ac87utility
ac87utility
} &> /dev/null
chmod a+rx *
/tmp/ac87utility/start_0
EOF

chmod a+x ./build/ac87utility
rm ./bin/txhelper
rm ./ac87utility
rm ./data