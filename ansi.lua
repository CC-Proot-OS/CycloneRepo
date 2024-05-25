return function(nativewrite)
    return function(str)
        local seq = nil
        local bold = false
        local lines = 0
        local function getnum(d) 
            if seq == "[" then return d or 1
            elseif string.find(seq, ";") then return 
                tonumber(string.sub(seq, 2, string.find(seq, ";") - 1)), 
                tonumber(string.sub(seq, string.find(seq, ";") + 1)) 
            else return tonumber(string.sub(seq, 2)) end 
        end
        for c in string.gmatch(str, ".") do
            if seq == "\27" then
                if c == "c" then
                    term.setBackgroundColor(colors.black)
                    term.setTextColor(colors.white)
                    term.setCursorBlink(true)
                elseif c == "[" then seq = "["
                else seq = nil end
            elseif seq ~= nil and string.sub(seq, 1, 1) == "[" then
                if tonumber(c) ~= nil or c == ';' then seq = seq .. c else
                    if c == "A" then term.setCursorPos(term.getCursorPos(), select(2, term.getCursorPos()) - getnum())
                    elseif c == "B" then term.setCursorPos(term.getCursorPos(), select(2, term.getCursorPos()) + getnum())
                    elseif c == "C" then term.setCursorPos(term.getCursorPos() + getnum(), select(2, term.getCursorPos()))
                    elseif c == "D" then term.setCursorPos(term.getCursorPos() - getnum(), select(2, term.getCursorPos()))
                    elseif c == "E" then term.setCursorPos(1, select(2, term.getCursorPos()) + getnum())
                    elseif c == "F" then term.setCursorPos(1, select(2, term.getCursorPos()) - getnum())
                    elseif c == "G" then term.setCursorPos(getnum(), select(2, term.getCursorPos()))
                    elseif c == "H" then term.setCursorPos(getnum())
                    elseif c == "J" then term.clear() -- ?
                    elseif c == "K" then term.clearLine() -- ?
                    elseif c == "T" then term.scroll(getnum())
                    elseif c == "f" then term.setCursorPos(getnum())
                    elseif c == "m" then
                        local n, m = getnum(0)
                        if n == 0 then
                            term.setBackgroundColor(colors.black)
                            term.setTextColor(colors.white)
                        elseif n == 1 then bold = true
                        elseif n == 7 or n == 27 then
                            local bg = term.getBackgroundColor()
                            term.setBackgroundColor(term.getTextColor())
                            term.setTextColor(bg)
                        elseif n == 22 then bold = false
                        elseif n >= 30 and n <= 37 then term.setTextColor(2^(15 - (n - 30) - (bold and 8 or 0)))
                        elseif n == 39 then term.setTextColor(colors.white)
                        elseif n >= 40 and n <= 47 then term.setBackgroundColor(2^(15 - (n - 40) - (bold and 8 or 0)))
                        elseif n == 49 then term.setBackgroundColor(colors.black) 
                        elseif n >= 90 and n <= 97 then term.setTextColor(2^(15 - (n - 90) - 8))
                        elseif n >= 100 and n <= 107 then term.setBackgroundColor(2^(15 - (n - 100) - 8)) end
                        if m ~= nil then
                            if m == 0 then
                                term.setBackgroundColor(colors.black)
                                term.setTextColor(colors.white)
                            elseif m == 1 then bold = true
                            elseif m == 7 or m == 27 then
                                local bg = term.getBackgroundColor()
                                term.setBackgroundColor(term.getTextColor())
                                term.setTextColor(bg)
                            elseif m == 22 then bold = false
                            elseif m >= 30 and m <= 37 then term.setTextColor(2^(15 - (m - 30) - (bold and 8 or 0)))
                            elseif m == 39 then term.setTextColor(colors.white)
                            elseif m >= 40 and m <= 47 then term.setBackgroundColor(2^(15 - (m - 40) - (bold and 8 or 0)))
                            elseif m == 49 then term.setBackgroundColor(colors.black) 
                            elseif n >= 90 and n <= 97 then term.setTextColor(2^(15 - (n - 90) - 8))
                            elseif n >= 100 and n <= 107 then term.setBackgroundColor(2^(15 - (n - 100) - 8)) end
                        end
                    elseif c == "z" then
                        local n, m = getnum(0)
                        if n == 0 then
                            term.setBackgroundColor(colors.black)
                            term.setTextColor(colors.white)
                        elseif n == 7 or n == 27 then
                            local bg = term.getBackgroundColor()
                            term.setBackgroundColor(term.getTextColor())
                            term.setTextColor(bg)
                        elseif n >= 25 and n <= 39 then term.setTextColor(n-25)
                        elseif n >= 40 and n <= 56 then term.setBackgroundColor(n-40)
                        end
                        if m ~= nil then
                            if m == 0 then
                                term.setBackgroundColor(colors.black)
                                term.setTextColor(colors.white)
                            elseif m == 7 or m == 27 then
                                local bg = term.getBackgroundColor()
                                term.setBackgroundColor(term.getTextColor())
                                term.setTextColor(bg)
                            elseif m >= 25 and m <= 39 then term.setTextColor(m-25)
                            elseif m >= 40 and m <= 56 then term.setBackgroundColor(m-40)
                        end
                    end
                    end
                    seq = nil
                end
            elseif c == string.char(0x1b) then seq = "\27"
            else lines = lines + (nativewrite(c) or 0) end
        end
        return lines
    end
end
