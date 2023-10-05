#!/usr/bin/env bash

# GNU prefix command for mac os support (gsed, gsplit)
GP=
if [[ "$OSTYPE" =~ darwin* ]]; then
  GP=g
fi

find . -type f -exec ${GP}sed -i -r 's/tww\.(od|vl|is)_/tww_\1./g' {} \;
find . -type f -exec ${GP}sed -i -r 's/tww\.vw_/tww_od.vw_/g' {} \;


find . -type f -exec ${GP}sed -i -r 's/tww_is\./tww_sys./g' {} \;

find . -type f -exec ${GP}sed -i -r 's/tww\.txt_/tww_od.txt_/g' {} \;

find . -type f -exec ${GP}sed -i -r 's/tww\.seq_txt_/tww_od.seq_txt_/g' {} \;
find . -type f -exec ${GP}sed -i -r 's/tww\.seq_re_/tww_od.seq_re_/g' {} \;
find . -type f -exec ${GP}sed -i -r 's/tww\.seq_is_/tww_sys.seq_/g' {} \;
find . -type f -exec ${GP}sed -i -r 's/tww\.seq_od_/tww_od.seq_/g' {} \;
find . -type f -exec ${GP}sed -i -r 's/tww\.seq_vl_/tww_vl.seq_/g' {} \;

find . -type f -exec ${GP}sed -i -r 's/tww\.(update_last_modified|update_last_modified_parent|generate_oid|audit_table|if_modified_func|create_symbology_triggers)/tww_sys.\1/g' {} \;
find . -type f -exec ${GP}sed -i -r 's/tww\.(\w+\()/tww_od.\1/g' {} \;

find . -type f -exec ${GP}sed -i -r 's/\s+ON\s+(od|vl)_/ ON /g' {} \;
find . -type f -exec ${GP}sed -i -r 's/\s+=\s+(od|vl)_/ = /g' {} \;
find . -type f -exec ${GP}sed -i -r 's/\sod_/ /g' {} \;

find . -type f -exec ${GP}sed -i -r 's/tww\.plantype/tww_od.plantype/g' {} \;

find view -type f -exec ${GP}sed -i -r 's/tww\./tww_od./g' {} \;

find . -type f -exec ${GP}sed -i -r "s/generate_oid\('(od|vl)_/generate_oid('tww_\1','/g" {} \;
find . -type f -exec ${GP}sed -i -r "s/generate_oid\('(re|txt)_/generate_oid('tww_od','\1_/g" {} \;

find . -type f -exec ${GP}sed -i -r "s/\((od|vl)_/(/g" {} \;

find view -type f -iname "*.py" -exec ${GP}sed -i -r 's/schema: tww/schema: tww_od/' {} \;

${GP}sed -i -r "s/(INSERT INTO tww_sys.dictionary_od_table.*')(od|vl|sys)_/\1/" 09_tww_dictionaries.sql

find . -type f -exec ${GP}sed -i -r "s/\('/('/g" {} \;
