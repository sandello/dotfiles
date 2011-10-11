set print array on
#set print array-indexes on
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3

define pw
    set $i = 0
    set $s = $arg0
    set $l = $arg1

    printf "'"

    while $i < $l
        set $uc = (unsigned short) $s[$i++]
        if ( $uc < 0x80 )
            printf "%c", (unsigned char)($uc & 0x7f)
        else
            if ( $uc < 0x0800 )
                printf "%c", (unsigned char)(0xc0 | ($uc >> 6))
            else
                printf "%c", (unsigned char)(0xe0 | ($uc >> 12))
                printf "%c", (unsigned char)(0x80 | (($uc > 6) &0x3f))
            end
            printf "%c", (unsigned char)(0x80 | ((unsigned char) $uc & 0x3f))
        end
    end

    printf "'\n"
end

define pwtr
    pw $arg0.c_str() $arg0.length()
end

