#!/bin/sh

ROOT_PATH={{ insight_talend_location }}/Palette_Insight_Init_ImportTable
TALEND_LIBDIR={{ insight_talend_location }}/lib
TARGET_PATH=/data/insight-server/uploads/{{ cluster_name }}

JAVA_CP=$ROOT_PATH:$LIB_PATH/systemRoutines.jar:$LIB_PATH/userRoutines.jar::.:$ROOT_PATH/palette_insight_init_importtable_0_8.jar:$ROOT_PATH/pi_check_gpfdist_0_1.jar:$ROOT_PATH/pi_importtable_full_0_1.jar:$ROOT_PATH/pi_importtable_incremental_0_1.jar:$LIB_PATH/checkArchive.jar:$LIB_PATH/commons-compress-1.6.jar:$LIB_PATH/commons-io-2.4.jar:$LIB_PATH/dom4j-1.6.1.jar:$LIB_PATH/external_sort.jar:$LIB_PATH/filecopy.jar:$LIB_PATH/jakarta-oro-2.0.8.jar:$LIB_PATH/jaxen-1.1.1.jar:$LIB_PATH/log4j-1.2.15.jar:$LIB_PATH/mail-1.4.3.jar:$LIB_PATH/postgresql-8.3-603.jdbc3.jar:$LIB_PATH/talendcsv.jar:$LIB_PATH/talendzip.jar:$LIB_PATH/talend_file_enhanced_20070724.jar:$LIB_PATH/thashfile.jar:$LIB_PATH/xpathutil-1.0.0.jar:$LIB_PATH/zip4j_1.3.1.jar

java \
 -Xms256M \
 -Xmx1024M \
 -cp $JAVA_CP \
 palette_insight.palette_insight_init_importtable_0_8.Palette_Insight_Init_ImportTable \
 "$@"

