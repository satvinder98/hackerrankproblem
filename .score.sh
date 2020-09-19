#!/bin/bash
SCORE=0
PASS=0
TOTAL_TESTS=5
redis-server --daemonize yes

echo "get auto_expire_otp" | redis-cli > autootp.txt
if(($(grep -io 8790 autootp.txt | wc -l)==1)); then PASS=$((PASS+1)); fi;

echo "keys *"| redis-cli > keys.txt
if(($(grep -io -e "your_otp" -e "auto_expire_otp" -e "fargo" -e "no_otp" keys.txt | wc -l)==4)); then PASS=$((PASS+1)); fi;

echo "get no_otp" | redis-cli > nootp.txt
if(($(grep -io 2121 nootp.txt | wc -l)==1)); then PASS=$((PASS+1)); fi;

echo "lrange fargo 0 3" | redis-cli > accounts.txt
if(($(grep -io -e "Retirement_account" -e "Money_market_account" -e "Checking_account" -e "Savings_account" accounts.txt| wc -l)==4)); then PASS=$((PASS+1)); fi;

if [ -f /usr/bin/redis-server ]
then PASS=$((PASS + 1))
fi;
echo ""
echo $PASS
SCORE=$(($PASS*100 / $TOTAL_TESTS))
echo "FS_SCORE:$SCORE%"

