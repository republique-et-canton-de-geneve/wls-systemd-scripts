#!/bin/bash

#SCRIPTNAME=$0
#SCRIPTPATH=`dirname "${SCRIPTNAME}"`
# Delegate to the common delegation script ...
#"${SCRIPTPATH}/fmwconfig_common.sh" wlst_internal.sh "$@"

. ${MW_HOME}/oracle_common/common/bin/setWlstEnv_internal.sh
if [ -d "${JAVA_HOME}" ]; then
 eval '"${JAVA_HOME}/bin/java"' ${JVM_ARGS} -DskipWLSModuleScanning -Djava.security.egd=file:/dev/./urandom weblogic.WLST '"$@"'
else
 exit 1
fi

