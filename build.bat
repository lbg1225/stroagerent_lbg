cd %1
mvn package -B -D maven.test.skip=true
docker build -t lbg1225/%1:%2 .
docker push lbg1225/%1:%2
cd ..    
