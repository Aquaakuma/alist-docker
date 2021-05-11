<<<<<<< Updated upstream
#!/bin/bash

set -e

CONFIG_FILE='/config/conf.yml'

if [ ! -f $CONFIG_FILE  ];then
  cp ./conf.yml.example /config/conf.yml
else
  echo dir exist
fi

# if [[ -n $REFRESH_TOKEN ]];then
#   TOKEN='  - refresh_token: $REFRESH_TOKEN'
#   sed -i '/refresh_token/s/.*/'$TOKEN'/' ./conf.yml
# fi

# if [[ -n $ROOT_FOLDER ]];then
#   FOLDER=${ROOT_FOLDER:-root}
#   echo $FOLDER
#   sed -i 's/\[root_folder\]/'$ROOT_FOLDER'/g' ./conf.yml
# fi

# if [[ -n $PASSWORD ]];then
#   echo $PASSWORD
#   sed -i 's/\[password\]/'$PASSWORD'/g' ./conf.yml
# fi

./alist -skip-update -conf /config/conf.yml
=======
>>>>>>> Stashed changes
