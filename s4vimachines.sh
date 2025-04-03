#!/bin/bash

ruta=$(realpath $0 | rev | cut -d'/' -f2- | rev)
cd $ruta
# Colors
source Colors.sh
source ./variables/global_variables.sh

function def_handler(){
  echo -e "\n${bright_red}[!] Saliendo del programa...${end}\n\n"
  [[ -f $results  ]] && rm $results
  [[ -f $TMP_ARCHIVE ]] && rm $TMP_ARCHIVE
  [[ -f $vulnhub_results ]] && rm $vulnhub_results
  [[ -f $htb_results ]] && rm $vulnhub_results
  tput cnorm
  exit 1
}
# Ctrl + C
trap def_handler INT

if ! ping -c 1 8.8.8.8 &>/dev/null; then
  echo -e "\n${bright_black}[!] Al no disponer de internet, este script estara limitado!!"
fi

function banner(){
      echo -e "${bright_green}
                    .
                 %%%%%%%.
             %%%%%%.  %%%%%%.
        %%%%%%           *%%%%%%.
     %%%%%                   .%%%%%%    
     %%%%%%%%               %%%%%%%%
     %%   %%%%%%%      .%%%%%%%  %%%
     %%       #%%%%%%%%%%%#      %%%    ${bright_white}$0 - Terminal Client${bright_green}
     %%           %%%%#          %%%    ${bright_blue}\t\t        by Flick${bright_red} <3${end}${bright_green}
     %%            %%%           %%%
     %%            %%%           %%%
     %%%%%         %%%          %%%%
       %%%%%%%     %%%     %%%%%%.
           #%%%%%%%%%%%%%%%%%
                %%%%%%%%#
                    .${end}\n"

}

function helpPanel(){
#  local info=$(echo; cat $PATH_ARCHIVE | tail -n 6 | grep -Pi "totalMachines.*" -A 3 | sed 's/htb/HackTheBox (htb)/' | sed 's/vuln/VulnHub (vuln)/' | sed 's/swigger/PortSwigger (swigger)/' | tail -n3  | sed 's/^ *//'; echo)
#  local total_machines=$(cat $PATH_ARCHIVE  | grep -i Total -A 4 | grep -oP "\d{1,3}" | xargs | sed 's/ /+/g' | bc)
    if [[ ! $exclude_banner == true ]]; then
        banner
#      echo; echo $info | awk '{for(i=1;i<=NF;i++){printf "%s%s", $i, ($i ~ /^[0-9]+$/ ? "\n" : " ")}}'; echo
#      echo "Máquinas totales: $total_machines"

  for i in $(seq 1 80); do echo -ne "${bright_red}-"; done; echo -ne "${end}"
    fi

    echo -e "\n${bright_white}Modo de uso: [$(realpath $0)] [PARAMETROS] [ARGUMENTOS]${end}"
  echo -e "\t${bright_white}-h(help): Mostrar el manual de ayuda.${end}"

  echo -e "\n${bright_white}Actualizaciones y dependencias${end}"
  echo -e "\t${bright_white}-u(update): Actualizar dependencias${end}"

  echo -e "\n${bright_white}Listar todas las máquinas.${end}"
  echo -e "\t${bright_white}-m(machine): Mostrar las propiedades de una máquina.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -m${bright_white} 'Multimaster'${end}\n"
  echo -e "\t${bright_white}-i(ip_addr): Mostrar máquinas por la dirección IP.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -i${bright_white} '10.10.10.179'${end}\n"
  echo -e "\t${bright_white}-d(difficulty): Mostrar máquinas por una dificultad dada.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -d${bright_white} 'Insane'${end}\n"
  echo -e "\t${bright_white}-o(osSystem): Mostrar máquinas por un sistema operativo dado.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -o${bright_white} 'Windows'${end}\n"
  echo -e "\t${bright_white}-w(writeup): Mostrar el enlace a la resolución de una máquina${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -w${bright_white} 'Multimaster'${end}\n"
  echo -e "\t${bright_white}-s(skill): Listar máquinas por skill${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -s${bright_white} 'SQLI'${end}\n"
  echo -e "\t${bright_white}-p(platform): Listar todas las máquinas de una plataforma${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -p${bright_white} 'HackTheBox'${end}\n"
  echo -e "\t${bright_white}-c(certificate): Listar todas las máquinas que dispongan de uno o mas certificados${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -c${bright_white} 'OSCP OSWE OSEP'${end}\n"

  echo -e "${bright_white}Extras${end}"
  echo -e "\t${bright_white}-v(verbose): Activar el modo verbose${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -u -v${end}\n"
  echo -e "\t${bright_white}-y(yes): Confirmar cada acción que dependa de una confirmación de usuario${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -u -y${end}\n"
  echo -e "\t${bright_white}-r(random): Modo de elección aleatorio. El script elegira una máquina al azar por ti.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -r${end}\n"
  echo -e "\t${bright_white}-t(translate): Traducir el output a un idioma especifico.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -m${bright_white} 'Tentacle'${bright_yellow} -t${bright_white} 'es'${end}\n"
  echo -e "\t${bright_white}-b(browser): Abrir el writeup de una máquina, en un navegador especifico.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -w${bright_white} 'Tentacle'${bright_yellow} -b${bright_white} '' (Navegador por default: ${bright_yellow}firefox${bright_white})\n"
  echo -e "\t${bright_white}-x(exclude banner): No mostrar el banner en el panel de ayida.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -x${end}\n"
  echo -e "\t${bright_white}-a(all): Listar todas las máquinas existentes.${end}"
  echo -e "\t${bright_cyan}[Ejemplo]${bright_white} $0${bright_yellow} -a${end}\n"

}

function searchMachine(){

  function helpMachine(){
  
    echo -e "\n${bright_cyan}[+]${bright_white} Opciones disponibles:\n"
    echo -e "\t${bright_magenta}-m${bright_white} Buscar máquinas/s (Ejemplo: $0 -m 'Multimaster')"
    echo -e "\t${bright_magenta}-t${bright_white} Traducir el output (Ejemplo: $0 -m 'Multimaster' -t 'es')${end}\n"
    exit 
  }

  machineName="$1"
  if [[ "$help" == true ]]; then
    helpMachine
  fi

  if ! cat $PATH_ARCHIVE | grep -i "name: $machineName" &>/dev/null; then
    echo -e "${bright_red}\n[!] Error fatal: Máquina no encontrada ${end}${bg_bright_red}\"$machineName\"\n${end}"
    exit 1
  fi

 
  if [[ $show_output_translate == false ]]; then
  output=$(cat $PATH_ARCHIVE| grep -i "name: $machineName" -A 6 -B 1  | sed 's/^ *//g'; echo)

    echo "$output" | while IFS= read -r line; do
      first_column=$(echo $line | awk '{print $1}')
      rest_columns=$(echo $line | cut -d' ' -f2-)
      if [[ -n "$rest_columns" ]]; then
        echo -e "${bright_yellow}${first_column}${end} ${bright_white}${rest_columns}${end}" >> $results
      fi

    done

    echo -e "\n${bright_cyan}[+]${end} ${bright_white}Maquina encontrada:${end} ${bright_magenta}$machineName${end}${bright_white}, listando sus propiedades:${end}"
    echo; /bin/cat $results | sed 's/--.*//'; rm $results
  else
    output=$(cat $PATH_ARCHIVE| grep -i "name: $machineName" -A 6 -B 1  | sed 's/^ *//g' | trans -b -t $language; echo)

    echo "$output" | while IFS= read -r line; do
      first_column=$(echo $line | awk '{print $1}')
      rest_columns=$(echo $line | cut -d' ' -f2-)
      if [[ -n "$rest_columns" ]]; then
        echo -e "${bright_yellow}${first_column}${end} ${bright_white}${rest_columns}${end}" >> $results
      fi

    done

    echo -e "\n${bright_cyan}[+]${end} ${bright_white}Maquina encontrada:${end} ${bright_magenta}$machineName${end}${bright_white}, listando sus propiedades:${end}"
    echo; /bin/cat $results | sed 's/--.*//'; rm $results
      
  fi
}

function searchForIp(){
  ip_addr="$1"
  if ! cat $PATH_ARCHIVE | grep -oP "ip: $ip_addr" &>/dev/null; then
    echo -e "\n${bright_red}[!] Dirección IP no encontrada en la base de datos.\n${end}"
    exit 1
  fi
  
  output=$(cat $PATH_ARCHIVE | grep "ip: $ip_addr" -A 1 -B 6  | sed 's/^ *//')
  machineName=$(cat $PATH_ARCHIVE | grep "ip: $ip_addr" -A 1 -B 6  | sed 's/^ *//' | grep "name: *" | sed 's/name://' | sed 's/^ *//')
  
  echo -e "\n${bright_green}[+]${end} ${bright_white}La dirección IP: ${bright_yellow}$ip_addr${end} ${bright_white}le pertenece a la máquina${bright_blue} $machineName${end}" 
  [[ $confirm_act == true ]] && searchMachine "$machineName"
  exit 0
}

function showAllDifficulty(){
  echo -e "\n[+] Dificultades existentes: \n"
  echo -e "\t${bright_blue} Dificultad: easy"
  echo -e "\t${bright_yellow} Dificultad: medium"
  echo -e "\t${bright_cyan} Dificultad: hard"
  echo -e "\t${bright_red} Dificultad: insane"
}

function searchDifficulty(){
  difficulty="$1"
  difficulty=$(echo $difficulty | tr '[:upper:]' '[:lower:]')
  
  # Validar que la dificultad exista
  if ! cat $PATH_ARCHIVE | grep -i "state: $difficulty" &>/dev/null; then
    echo -e "\n${bright_red}[!] Dificultad no encontrada.${end}\n"
    showAllDifficulty
    exit 1
  fi
  
  local total_machines=$(cat $PATH_ARCHIVE | grep -i "state: $difficulty" -B 3  | grep -oP "name: .*" | sed 's/name://' | wc -l)

  [[ $help == true ]] && showAllDifficulty && exit 

  [[ $difficulty == "easy" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_blue} $difficulty: \n${end}"
  [[ $difficulty == "medium" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_yellow} $difficulty: \n${end}"
  [[ $difficulty == "hard" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_cyan} $difficulty: \n${end}"
  [[ $difficulty == "insane" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_red} $difficulty: \n${end}"
  echo -e "${bright_yellow}[+]${bright_white} Máquinas totales:${bright_green} $total_machines${end}"

    echo -e "\n${bright_yellow}[+]${bright_white} Plataforma HackTheBox:${end}"
    tput setaf 2; echo; cat $PATH_ARCHIVE | grep -i "state: $difficulty" -B 3 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name: .*" | sed 's/name://' | column
    
    echo -e "\n${bright_yellow}[+]${bright_white} Plataforma VulnHub:${end}"
    tput setaf 3; echo; cat $PATH_ARCHIVE | grep -i "state: $difficulty" -B 3 | grep -i "platform: VulnHub" -A 1 | grep -oP "name: .*" | sed 's/name://' | column

}

searchOsSystem(){
  osSystem="$1"
  osSystem="$(echo "$osSystem" | tr '[:upper:]' '[:lower:]')"
  if ! cat $PATH_ARCHIVE | grep -i "os: $osSystem" &>/dev/null; then
    echo -e "\n${bright_red}[!] Sistema operativo no encontrado.${end}\n"
    echo -e "\t${bright_white}Sistemas operativos disponibles:${end} ${bright_cyan}Linux${end} ${bright_white}-${end} ${bright_blue}Windows${end}"
    exit 1
  fi
  echo -e "\n${bright_green}[+] Listando máquinas de Sistema Operativo: $osSystem\n${end}"
  echo -e "${bright_cyan}[+]${bright_white} Máquinas de la plataforma HackTheBox:${end}"
  tput setaf 2; echo; cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo
  
  echo -e "${bright_cyan}[+]${bright_white} Máquinas de la plataforma VulnHub:${end}"
  tput setaf 3; echo; cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 | grep -i "platform: VulnHub" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo

}

function showLink(){
  if [[ $help == true || "$1" == '-h' ]]; then
    echo -e "\n${bright_white}Argumentos disponibles: \n"
    echo -e "\t-w (writeup) Buscar el enlace a el writeup de una máquina."
    echo -e "\tEjemplo: $0 -w Tentacle \n\tOutput: https://www.youtube.com/watch?v=hFIWuWVIDek\n"
    echo -e "\t-b (browser) Abrir writeup en un navegador, puedes pasarle como parametro una cadena vacia o 'default' para que en ambos casos sea firefox el navegador"
    echo -e "\tEjemplo: $0 -w Tentacle -b ''\n\tOutput: firefox https://www.youtube.com/watch?v=hFIWuWVIDek${end}\n"
    echo -e "\t"
    exit 
  fi
  writeup="$1"
  writeup=$(echo "$writeup" | tr '[:upper:]' '[:lower:]')

  if ! cat $PATH_ARCHIVE | grep -i "name: $writeup" &>/dev/null; then
    echo -e "\n${bright_red}[!] Máquina no encontrada: $writeup${end}\n\n"
    exit 1
  fi
  link=$(cat $PATH_ARCHIVE | grep -i "name: $writeup" -A  6 | grep -i "video: https:" | sed 's/video://' | sed 's/^ *//')

  echo -e "\n${bright_cyan}[+]${end} ${bright_white}Writeup de la máquina${end} ${bright_green}$writeup${bright_white}: ${bright_blue}$link${end}\n" 
  
  if [[ $open_browser == true ]]; then
    if ! command -v $browser &>/dev/null; then
      echo -e "\n${bg_bright_red}[!] Navegador invalido: $browser!${end}\n"
      exit 1
    fi
    echo -e "\n${bright_cyan}[+]${bright_white} Abriendo el enlace:${bright_blue} $link en el navegador${bright_magenta} $browser${bright_white}...${end}\n"
    $browser $link &>/dev/null & disown
  fi

  path_writeup="Writeups/$writeup"
}

function updatefiles(){
  
  if [[ ! -f $PATH_ARCHIVE ]]; then
      if [[ "$confirm_act" == false ]]; then
        echo -en "\n${bright_cyan}[+]${bright_white} El archivo necesario ${bright_black}($PATH_ARCHIVE)${bright_white} no existe ¿Deseas descargarlo? (Y/n)${end} " && read -r yes_no
        if [[ ! $yes_no =~ ^[Yy] && ! $yes_no =~ ^[Ss] ]]; then
          echo -e "\n${bright_red}[!] Operación cancelada...${end}"
          exit 1
        fi
      fi 
      local size_file=$(curl -sI $url | awk '/content-length/ {printf "%.2f MB\n", $2/1024/1024}')
      echo -e "\n${bright_white}Descargando archivo necesario de: ${bright_blue}$url\n${bright_white}Destino: ${bright_cyan}$PATH_ARCHIVE${bright_white}\nPeso estimado: ${bright_yellow}$size_file${end}"
      curl -s -X GET $url | js-beautify > $PATH_ARCHIVE
      /bin/cat $PATH_ARCHIVE | sed 's|\\n| |g' | tr -d "'" | tr -d '"' | tr -d ',' | sponge $PATH_ARCHIVE
      echo -e "\n${bright_green}[+]${end}${bright_white} Archivo descargado correctamente.\n${end}"
      exit 0
  else
    echo -e "\n${bright_cyan}[+]${bright_white} Estamos en busca de actualizaciones...${end}\n"

      if [[ "$confirm_act" == false ]]; then
        echo -en "${bright_green}[+]${bright_white} El archivo indicado ${bright_black}($PATH_ARCHIVE)${bright_white} ya existe ¿Estas seguro que deseas revisar si hay actualizaciones? (Y/y)${end} " && read -r yes_no
        if [[ ! $yes_no =~ ^[Yy] && ! $yes_no =~ ^[Ss] ]]; then
          echo -e "\n${bright_red}[!] Operación cancelada...${end}"
          exit 1
        fi
      fi 
    curl -s -X GET $url | js-beautify > $TMP_ARCHIVE
    /bin/cat $TMP_ARCHIVE | sed 's|\\n| |g' | tr -d "'" | tr -d '"' | tr -d ',' | sponge $TMP_ARCHIVE

    MD5_ORG=$(md5sum $PATH_ARCHIVE | awk '{print $1}') 
    MD5_TEMP=$(md5sum $TMP_ARCHIVE | awk '{print $1}')

    if [[ "$MD5_ORG" == "$MD5_TEMP" ]]; then
      if [[ "$verbose_mode" == true ]]; then
        echo -e "${bright_white}Valor MD5 del archivo original:${bright_blue} $MD5_ORG"
        echo -e "${bright_white}Valor MD5 del archivo temporal a comparar:${bright_blue} $MD5_TEMP"
      fi
        echo -e "\n${bright_white}No hay actualizaciones disponibles de momento.${end}"
        rm $TMP_ARCHIVE
    else
      if [[ "$verbose_mode" == true ]]; then
        echo -e "${bright_white}Valor MD5 del archivo original:${bright_blue} $MD5_ORG"
        echo -e "${bright_white}Valor MD5 del archivo temporal a comparar:${bright_blue} $MD5_TEMP"
      fi

      if [[ "$confirm_act" == false ]]; then
        echo -ne "${bright_white}Se detecto una nueva actualización ¿Deseas continuar? (Y/n)${end} " && read -r yes_no
          if [[ ! "$yes_no" =~ ^[SsYy]$ ]] && [[ ! -z "$yes_no" ]]; then          
          echo -e "\n${bright_red}[!] Operación cancelada.${end}"
          exit 1
        fi
      fi
      echo -e "\n${bright_cyan}[+]${bright_white} Las actualizaciones se encontraron y se finalizaron.${end}"
      rm $PATH_ARCHIVE && mv $TMP_ARCHIVE $PATH_ARCHIVE
    fi

  fi

}


function Get_cert(){
    certificate="$1"
    output=$(echo "./addFuncs/getCertificates.sh" "$certificate" | bash)  # Captura la salida del script

    if [[ -z "$output" ]]; then  # Verifica si la salida no está vacía
      echo -e "\n${bright_red}[!] No se encontraron matches: $certificate${end}"
      return 1
    fi
  
    echo -e "\n${bright_blue}[+]${end} ${bright_white}Listando máquinas que dispongan de los certificados ${bright_cyan}$certificate${bright_white}.${end}\n"
    echo "./addFuncs/getCertificates.sh ""$certificate" | bash
}

function random_machine(){
  tput civis
  local value=0
    while [[ $value -le 100 ]]; do
        machineName=$(cat $PATH_ARCHIVE | grep -i 'name: .*' | sed 's/name: //' | sed 's/^ *//' | shuf -n 1)
        echo -ne "\r\033[K${bright_blue}[+]${bright_white} Tu máquina elegida es: ${bright_cyan}\"$machineName\"${end}"
        ((value++))
    done

  if ! cat $PATH_ARCHIVE | grep -i "name: $machineName" &>/dev/null; then
    echo -e "${bright_red}\n[!] Error fatal: Máquina no encontrada ${end}${bg_bright_red}\"$machineName\"\n${end}"
    exit 1
  fi

  output=$(cat $PATH_ARCHIVE| grep -iP "name: ${machineName}$" -A 6 -B 1  | sed 's/^ *//g'; echo) 
  echo "$output" | while IFS= read -r line; do
    first_column=$(echo $line | awk '{print $1}')
    rest_columns=$(echo $line | cut -d' ' -f2-)
    if [[ -n "$rest_columns" ]]; then
      echo -e "${bright_yellow}${first_column}${end} ${bright_white}${rest_columns}${end}" >> $results
    fi

  done

  echo -e "\n${bright_cyan}[+]${end} ${bright_white}Maquina encontrada:${end} ${bright_magenta}$machineName${end}${bright_white}, listando sus propiedades:${end}"
  echo; /bin/cat $results | sed 's/--.*//'; rm $results
  tput cnorm && exit
}

function searchPlatform(){
  platform="$1"
  
  if ! cat $PATH_ARCHIVE | grep -i "platform: $platform" &>/dev/null; then
    echo -e "\n[!] Error fatal, no se enctontro la plataforma: $platform"
    exit 1
  fi

  if [[ "$confirm_act" == false ]]; then 
    if [[ "$platform" =~ ^[Hh] ]]; then
      tput setaf 2; echo; cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo
    elif [[ "$platform" =~ ^[Pp] ]]; then
      tput setaf 3 && tput bold; echo; cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo
    else
       tput setaf 2; echo; cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo   
    fi
  fi

  if [[ "$confirm_act" == true ]]; then
    cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -o 'name: .*' | sed 's/name: //' | while read machineName; do
          searchMachine "$machineName"
    done
  fi

}

function searchSkill(){
  skill="$1"
  output=$(echo "./addFuncs/getSkills.sh" "$skill" | bash)  # Captura la salida del script

  if [[ -z "$output" ]]; then  # Verifica si la salida no está vacía
    echo -e "\n${bright_red}[!] No se encontraron matches: $skill${end}"
    return 1
  fi

  echo -e "\n${bright_blue}[+]${end} ${bright_white}Listando máquinas que dispongan de skill ${bright_cyan}$skill${bright_white}.${end}\n"
  echo "./addFuncs/getSkills.sh ""$skill" | bash

}

function get_allMachines(){
  
  : '
  Una vez capturado el campo "name:", nos quedamos solo con lo que quede despues, es decir reiniciamos el punto de matching
  Esto se logra colocando un \K
  wc -l nos sirve para contar cuantas lineas hay en un output, o archivo, podemos indicar lineas, palabras, etc. 
  En este caso solo obtuve todas las máquinas, y con wc -l obtuve las lineas totales, si le aplicaba column probablemente petaba
  '
  local total_machines=$(cat $PATH_ARCHIVE | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Listando todas las máquinas disponibles (${bright_blue}$total_machines${bright_white}):${end} "

  # Para la plataforma de HackTheBox
  local total_htb=$(cat $PATH_ARCHIVE | grep -i "platform: HackTheBox" -A 3 | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Plataforma HackTheBox (${bright_green}$total_htb${bright_white}):${end} \n"
  tput setaf 2 && cat $PATH_ARCHIVE | grep -i "platform: HackTheBox" -A 3 | grep -oP "name:\K.*"  | column


  # Para la plataforma de VulnHub
  local total_vulnhub=$(cat $PATH_ARCHIVE | grep -i "platform: VulnHub" -A 3 | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Plataforma VulnHub (${bright_yellow}$total_vulnhub${bright_white}):${end} \n"
  tput setaf 3 && cat $PATH_ARCHIVE | grep -i "platform: VulnHub" -A 3 | grep -oP "name:\K.*"  | column


  # Para la plataforma de PortSwigger
  local total_swigger=$(cat $PATH_ARCHIVE | grep -i "platform: PortSwigger" -A 3 | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Plataforma PortSwigger (${bright_magenta}$total_swigger${bright_white}):${end} \n"
  tput setaf 5 && cat $PATH_ARCHIVE | grep -i "platform: PortSwigger" -A 3 | grep -oP "name:\K.*"  | column

}

function advanced_search(){
 : '
 Aún se esta trabajando en esta función, pero una vez terminada sera una locura.
 '
  objects="$1"
  echo -e "\n[+] Realizando la busqueda avanzada: $objects..."

  echo -e "\n[*] Esta función esta en proceso "
}

function searchOsDiff(){
  osSystem="$1"
  difficulty="$2"
  
  exists_os=$(cat $PATH_ARCHIVE | grep -i "os: $osSystem")
  exists_diff=$(cat $PATH_ARCHIVE | grep -i "state: $difficulty")
  if [[ ! "$exists_os" || ! "$exists_diff"  ]]; then
    echo -e "\n${bright_red}[!] No encontramos resultados para: $osSystem - $difficulty${end}"
    echo -e "\n${bright_white}Sistemas operativos disponibles:${end} ${bright_cyan}Linux${end} ${bright_white}-${end} ${bright_blue}Windows${end}"
    showAllDifficulty
    exit 1
  fi
  
  local total_htb=$(cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name:\K.*" | wc -l)
  if [[ $total_htb -eq 0 ]]; then
    echo -e "\n${bright_black}[*] No se encontraron máquinas para la plataforma de HackTheBox.${end}\n"
  else
    echo -e "\n${bright_cyan}[+]${bright_white} Máquinas de la plataforma: HackTheBox (${bright_green}$total_htb${bright_white}):${end}" 
    echo; tput setaf 2; cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name:\K.*" | column
  fi
  
  local total_vulnhub=$(cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: VulnHub" -A 1 | grep -oP "name:\K.*" | wc -l)
  if [[ $total_vulnhub -eq 0 ]]; then
    echo -e "\n${bright_black}[*] No se encontraron máquinas en la plataforma de VulnHub.${end}\n"
  else
    echo -e "\n${bright_cyan}[+]${bright_white} Máquinas de la plataforma: VulnHub (${bright_yellow}$total_vulnhub${bright_white}):${end}" 
    echo; tput setaf 3; cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: VulnHub" -A 1 | grep -oP "name:\K.*" | column
  fi

}


while getopts 'w:o:b:d:i:m:c:huvyxrp:t:s:aA:' arg; do
  case $arg in
    x) exclude_banner=true;;
    v) verbose_mode=true;;
    y) confirm_act=true;;
    m) machineName=$OPTARG; ((parameter_counter+=1));;
    t) language="$OPTARG"; show_output_translate=true;;
    b) browser="${OPTARG:-firefox}"; open_browser=true;[[ "$browser" == 'default' ]] && browser='firefox';;
    u) let parameter_counter+=2;;
    i) ip_addr=$OPTARG; let parameter_counter+=3;;
    d) difficulty=$OPTARG; let parameter_counter+=4; let target_difficulty+=1;;
    o) osSystem=$OPTARG; let parameter_counter+=5; let target_os+=1;;
    w) writeup=$OPTARG; let parameter_counter+=6;;
    c) certificate="$OPTARG"; let parameter_counter+=7;;
    r) random_machine;;
    p) platform="$OPTARG"; let parameter_counter+=8;;
    s) skill="$OPTARG"; let parameter_counter+=9;;
    a) let parameter_counter+=10;;
    A) objects="$OPTARG"; let parameter_counter+=11;;
    h) help=true;;
  esac
done


if [[ ! -f "$PATH_ARCHIVE" && ! "$parameter_counter" -eq 2 ]]; then
  echo -e "\n${bright_red}[!]${bright_white} Necesitas actualizar las dependencias antes de usar este script!${end}"
  echo -e "\n${bright_white}Solución: $0${bright_yellow} -u${end}"
  exit 1
elif [[ $parameter_counter -eq 2 ]]; then
  updatefiles
  exit 0
fi


if [[ $parameter_counter -eq 1 ]]; then
  searchMachine "$machineName"
elif [[ "$target_difficulty" -eq 1 && $target_os -eq 1 ]]; then
  searchOsDiff "$osSystem" "$difficulty"

elif [[ $parameter_counter -eq 3 ]]; then
  searchForIp "$ip_addr"
elif [[ $parameter_counter -eq 4 ]]; then
  searchDifficulty "$difficulty"
elif [[ $parameter_counter -eq 5 ]]; then
  searchOsSystem "$osSystem"
elif [[ $parameter_counter -eq 6 ]]; then
  showLink "$writeup"
elif [[ "$parameter_counter" -eq 7 ]]; then
  Get_cert "$certificate"
elif [[ "$parameter_counter" -eq 8 ]]; then
  searchPlatform "$platform"
elif [[ "$parameter_counter" -eq 9 ]]; then
  searchSkill "$skill"
elif [[ "$parameter_counter" -eq 10 ]]; then
  get_allMachines
elif [[ "$parameter_counter" -eq 11 ]]; then
  advanced_search "$objects"
else
  helpPanel
fi


