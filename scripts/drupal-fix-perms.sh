#!/bin/sh

# Type of script: unattended
# To be runned on: -
# To be runned by: root
# Arguments: $TARGET
# Local dependencies: - none -
# Remote dependencies: - none -
# Short description: A script to fix file permissions on a TARGET Drupal installations

E_BADARGS=65
E_BADDEPS=66
E_TARGET_DONT_EXISTS=68

EXPECTED_ARGS=1

#echo $0
if [ $# -ne $EXPECTED_ARGS ]
then
  echo " This script expect $EXPECTED_ARGS arguments instead of $#"
  exit $E_BADARGS
fi

FIND=$(which find)
CHMOD=$(which chmod)
CHOWN=$(which chown)
SED=$(which sed)

#TARGET=$1
TARGET=$(echo $1 | $SED -e "s/\/*$//")
echo "*** Fixing file permissions for $TARGET"

if [ ! -d $TARGET ]; then
  echo " ABORTED: Target $TARGET doesn't exists"
  exit $E_TARGET_DONT_EXISTS
fi

: ${OWNER:="root"}
: ${WWW_US:="www-data"}
: ${WWW_GR:="www-data"}


DIR=$TARGET
F_DIR="$DIR/sites/*/files"
P_DIR="$DIR/sites/*/private"
A_SET="$DIR/sites/*/settings.php"

echo "*** Fixing permissions ***"
# General
$FIND -H $DIR -wholename "$F_DIR" -prune -or -wholename "$P_DIR" -prune -or \( ! -user $OWNER -or ! -group $WWW_GR \) -exec $CHOWN $OWNER:$WWW_GR {} \;
$FIND -H $DIR -wholename "$F_DIR" -prune -or -wholename "$P_DIR" -prune -or \( -type d -and ! -perm u=rwx,g=rxs,o= \) -exec $CHMOD u=rwx,g=rxs,o= {} \;
$FIND -H $DIR -wholename "$F_DIR" -prune -or -wholename "$P_DIR" -prune -or \( -type f -and ! -perm u=rw,g=r,o= \) -exec $CHMOD u=rw,g=r,o= {} \;
# files directory
$FIND -H $F_DIR \( ! -user $WWW_US -or ! -group $WWW_GR \) -exec $CHOWN $WWW_US:$WWW_GR {} \;
$CHMOD 2770 $F_DIR
$FIND -H $F_DIR \( -type d -and ! -perm u=rwx,g=rwxs,o= \) -exec $CHMOD u=rwx,g=rwxs,o= {} \;
$FIND -H $F_DIR \( -type f -and ! -perm u=rw,g=rw,o= \) -exec $CHMOD u=rw,g=rw,o= {} \;
# private directory
$FIND -H $P_DIR \( ! -user $WWW_US -or ! -group $WWW_GR \) -exec $CHOWN $WWW_US:$WWW_GR {} \;
$CHMOD 2770 $P_DIR
$FIND -H $P_DIR \( -type d -and ! -perm u=rwx,g=rwxs,o= \) -exec $CHMOD u=rwx,g=rwxs,o= {} \;
$FIND -H $P_DIR \( -type f -and ! -perm u=rw,g=rw,o= \) -exec $CHMOD u=rw,g=rw,o= {} \;

# setings.php
$CHMOD 440 $A_SET

