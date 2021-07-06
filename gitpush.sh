git add .
git status

while true
do
    echo push 할까요?
    read var

    if [[ $var == "Y" || $var == "y" ]]
    then
        git commit -m "..$1.."
        git push origin main
    elif [[ $var == "N" || $var == "n" ]]
    then
        echo 작업취소
    fi
done