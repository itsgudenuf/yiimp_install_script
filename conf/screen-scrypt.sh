#!/bin/bash
LOG_DIR=/var/log/yiimp
WEB_DIR=/var/web
STRATUM_DIR=/var/stratum
USR_BIN=/usr/bin
 
screen -dmS main bash $WEB_DIR/main.sh
screen -dmS loop2 bash $WEB_DIR/loop2.sh
screen -dmS blocks bash $WEB_DIR/blocks.sh
screen -dmS debug tail -f $LOG_DIR/debug.log
 
 
 
 # Stratum instances (skipped/exit if no .conf)
screen -dmS sha512256d $STRATUM_DIR/run.sh sha512256d


#screen -dmS c11 $STRATUM_DIR/run.sh c11
#screen -dmS deep $STRATUM_DIR/run.sh deep

#screen -dmS x11 $STRATUM_DIR/run.sh x11
#screen -dmS x11evo $STRATUM_DIR/run.sh x11evo
#screen -dmS x13 $STRATUM_DIR/run.sh x13
#screen -dmS x14 $STRATUM_DIR/run.sh x14
#screen -dmS x15 $STRATUM_DIR/run.sh x15
#screen -dmS x16r $STRATUM_DIR/run.sh x16r
#screen -dmS x17 $STRATUM_DIR/run.sh x17
#screen -dmS xevan $STRATUM_DIR/run.sh xevan
#screen -dmS timetravel $STRATUM_DIR/run.sh timetravel
#screen -dmS bitcore $STRATUM_DIR/run.sh bitcore
#screen -dmS hmq1725 $STRATUM_DIR/run.sh hmq1725
#screen -dmS tribus $STRATUM_DIR/run.sh tribus

#screen -dmS sha $STRATUM_DIR/run.sh sha
#screen -dmS sha256t $STRATUM_DIR/run.sh sha256t
#screen -dmS scrypt $STRATUM_DIR/run.sh scrypt
#screen -dmS scryptn $STRATUM_DIR/run.sh scryptn
#screen -dmS luffa $STRATUM_DIR/run.sh luffa
#screen -dmS neo $STRATUM_DIR/run.sh neo
#screen -dmS nist5 $STRATUM_DIR/run.sh nist5
#screen -dmS penta $STRATUM_DIR/run.sh penta
#screen -dmS quark $STRATUM_DIR/run.sh quark
#screen -dmS qubit $STRATUM_DIR/run.sh qubit
#screen -dmS jha $STRATUM_DIR/run.sh jha
#screen -dmS dmd-gr $STRATUM_DIR/run.sh dmd-gr
#screen -dmS myr-gr $STRATUM_DIR/run.sh myr-gr
#screen -dmS lbry $STRATUM_DIR/run.sh lbry
#screen -dmS allium $STRATUM_DIR/run.sh allium
#screen -dmS lyra2 $STRATUM_DIR/run.sh lyra2
#screen -dmS lyra2v2 $STRATUM_DIR/run.sh lyra2v2
#screen -dmS zero $STRATUM_DIR/run.sh lyra2z

#screen -dmS blakecoin $STRATUM_DIR/run.sh blakecoin # blake 8
#screen -dmS blake $STRATUM_DIR/run.sh blake
#screen -dmS blake2s $STRATUM_DIR/run.sh blake2s
#screen -dmS vanilla $STRATUM_DIR/run.sh vanilla # blake 8
#screen -dmS decred $STRATUM_DIR/run.sh decred # blake 14

#screen -dmS keccak $STRATUM_DIR/run.sh keccak
#screen -dmS keccakc $STRATUM_DIR/run.sh keccakc
#screen -dmS phi $STRATUM_DIR/run.sh phi
#screen -dmS polytimos $STRATUM_DIR/run.sh polytimos
#screen -dmS whirlpool $STRATUM_DIR/run.sh whirlpool

#screen -dmS skein $STRATUM_DIR/run.sh skein
#screen -dmS skein2 $STRATUM_DIR/run.sh skein2
#screen -dmS yescrypt $STRATUM_DIR/run.sh yescrypt
#screen -dmS yescryptR16 $STRATUM_DIR/run.sh yescryptR16
#screen -dmS zr5 $STRATUM_DIR/run.sh zr5
#screen -dmS sib $STRATUM_DIR/run.sh sib
#screen -dmS m7m $STRATUM_DIR/run.sh m7m
#screen -dmS veltor $STRATUM_DIR/run.sh veltor
#screen -dmS velvet $STRATUM_DIR/run.sh velvet
#screen -dmS argon2 $STRATUM_DIR/run.sh argon2


 
 

 
