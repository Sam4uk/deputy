#! /bin/bash

# Запуск без параметрів
if [[ "${1}" == "" ]];then
    echo " Run script"
    echo "          ${0} <source_path> <target_path>"
    exit
fi

# перевіряємо перший параметр чи то файл
if [ -e ${1} ]; then
    # Забули один параметр
    if [[ "${2}" == "" ]];then
    echo "Taget not set"
    exit
    fi
else

    echo "Path ${1} no exist"
    exit
fi


# Функція яка просить підтвердження на продовження
# сценарію. Вона ВИМАГАЄ ввести руцями YES або NO
confirm(){
while ((1))
do
echo "type YES or NO"
read answ
if [[ "$answ" == "YES" ]]; then
 echo "OK"
 return 0
elif [[ "$answ" == "NO" ]]; then
 echo "OH"
 return 1
fi
done
}
# Виводимо опис того що ставимо
echo -e "$(cat DESCRIPTION)"
# питаємо чи це ствимо
confirm
if  [ $? == 1 ]; then
# якщо не це то зупиняємось
exit 1
fi

# Тепер оглошуємо ліцензію
echo -e "$(cat LICENSE)"
# питаємо згоди
confirm

if  [ $? == 1 ]; then
# якщо не це то зупиняємось
exit 1
fi

# Перевіряємо існування того що заміщаємо
echo -e "Check existing \e[34m${2}\e[0m ..."
#     # Перевіряю існування шляху
    if [ -e ${2} ]; then
        # якщо шлях існує
        echo -e "Path found"
        echo -e "Path \e[34m${2}\e[0m \e[32mexist\e[0m"
        # перевіряємо чи це не сімволічне посилання
        if [ -L ${2} ]; then
            # це сімлінк
            echo -e "${2} is a symlink"
            # Перевіряю символьне посилання
            echo -e "Read symlink"
            echo -e "\e[34m${2}\e[0m => $(readlink ${2})"
            if [ $(readlink ${2}) = "${1}" ];then
                echo -e "\e[32mSymlink OK\e[0m"
            else
                # не наша тека
                mv ${2} ${2}.$(date +%d-%m-%y)
                ln -s ${1} ${2}
                echo -e "\e[32mSymlink OK\e[0m"
            fi
        else
            # це не посилання
            echo -e "Try open like folder"
            # перевіряємо чи не каталог
            if [ -d ${2} ]; then
                # каталог
                echo -e "${2} is a folder"
                mv ${2} ${2}.$(date +%d-%m-%y)
                ln -s ${1} ${2}
                echo -e "\e[32mSymlink OK\e[0m"
            else
                # Виявляється це файл
                echo -e "\e[34m${2}\e[0m is a file"
                # Перейменовуємо
                mv ${2} ${2}.$(date +%d-%m-%y)
                ln -s ${1} ${2}
                echo -e "\e[32mSymlink OK\e[0m"
            fi
        fi
    else
        # Шлях не зеайдено його треба створити
        echo -e "Path ${2} \e[31mno exists\e[0m"
        # Шлях стврлємо
        ln -s ${1} ${2}
        # Шлях створено
        echo -e "\e[32mCreate\e[0m"
        # Успішно
        echo -e "\e[32mSymlink OK\e[0m"
    fi