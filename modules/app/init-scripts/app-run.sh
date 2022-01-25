  #!/usr/bin/env bash

 docker pull pruthvilalji/sakilarestapi:2.0
 docker run -p 8080:8080 --mount type=bind,source=$(pwd)/application.properties,target=/application.properties -d pruthvilalji/sakilarestapi:2.0
