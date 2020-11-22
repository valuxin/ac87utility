#!/bin/sh

pass_enc="P&39i72sUyuIaPQi%Ub6Q&eT%deFD#7QWAgi7NavL9u$g29LFsIibpS*s^mVDbE4n4oXV5N8s2ZfaywfV4&Irp5rCan3i8am&G6a8IpsGs&PZM5yJuYxbvde$A%qH75o"

cat <<'EOF' >./data
#!/bin/sh

## Files

nvsimple_file()
{
cat <<'EOF'
EOF
cat ./bin/nvsimple | gzip -c | openssl aes-128-cbc -a -salt -k "$pass_enc" >>./data && echo "EOF" >>./data
echo "}" >>./data
echo "" >>./data
cat <<'EOF' >>./data
cfe_clean_bin()
{
cat <<'EOF'
EOF
cat ./bin/clean.bin | gzip -c | openssl aes-128-cbc -a -salt -k "$pass_enc" >>./data && echo "EOF" >>./data
echo "}" >>./data
echo "" >>./data
cat <<'EOF' >>./data
mtd_write_file()
{
cat <<'EOF'
EOF
cat ./bin/mtd-write | gzip -c | openssl aes-128-cbc -a -salt -k "$pass_enc" >>./data && echo "EOF" >>./data
echo "}" >>./data
echo "" >>./data
cat <<'EOF' >>./data
daemon_file()
{
cat <<'EOF'
EOF
cat ./bin/txhelper | gzip -c | openssl aes-128-cbc -a -salt -k "$pass_enc" >>./data && echo "EOF" >>./data
echo "}" >>./data
echo "" >>./data
cat <<'EOF' >>./data
## Checksums

EOF
nvsimple_crc=$(openssl sha1 ./bin/nvsimple | awk '{print $2}')
clean_crc=$(openssl sha1 ./bin/clean.bin | awk '{print $2}')
mtd_write_crc=$(openssl sha1 ./bin/mtd-write | awk '{print $2}')
txhelper_crc=$(openssl sha1 ./bin/txhelper | awk '{print $2}')
echo -e "nvsimple_crc=$nvsimple_crc" >>./data
echo -e "clean_crc=$clean_crc" >>./data
echo -e "mtd_write_crc=$mtd_write_crc" >>./data
echo -e "txhelper_crc=$txhelper_crc" >>./data
echo "" >>./data
cat <<'EOF' >>./data
## Action

if [ "$1" = "nvsimple_file" ]; then nvsimple_file
elif [ "$1" = "mtd_write_file" ]; then mtd_write_file
elif [ "$1" = "cfe_clean_bin" ]; then cfe_clean_bin
elif [ "$1" = "daemon_file" ]; then daemon_file
elif [ "$1" = "clean_crc" ]; then echo $clean_crc
elif [ "$1" = "nvsimple_crc" ]; then echo $nvsimple_crc
elif [ "$1" = "mtd_write_crc" ]; then echo $mtd_write_crc
elif [ "$1" = "txhelper_crc" ]; then echo $txhelper_crc
fi
EOF

chmod a+rx ./data