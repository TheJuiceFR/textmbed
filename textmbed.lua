--[[
textmbed

a program for embedding text into other text, using unicode's invisible characters.

by The Juice

copyright GNU GPL v3 or newer
]]

c0="‌" --character equivalent to a zero, in this case a zero width non joiner
c1="‍" --character equivalent to a one, in this case a zero width joiner

assert(c0~=c1,"your device or interpreter doesn't support my juju")

charValues={"\b","\f","\n","\r","\t","😃","😄","😁","😆","😂","🤣","😊","🤢","🤮","🖕","👎","👍","👉","👈","😅","😡","😈","😎","🤑","👊","🤬","👆","👇","👏","👀","👃"," ","!","\"","#","$","%","&","'","(",")","*","+",",","-",".","/","0","1","2","3","4","5","6","7","8","9",":",";","<","=",">","?","@","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","[","\\","]","^","_","`","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","{","|","}","~","🐍"}
charValues[0]="\a"

for n=#charValues,0,-1 do
    charValues[charValues[n]]=n
end
charValues[""]=0

charCodes={}

for n=0,#charValues,1 do
    local tab=""
    if n%2<1 then tab=c0..tab else tab=c1..tab end
    if n%4<2 then tab=c0..tab else tab=c1..tab end
    if n%8<4 then tab=c0..tab else tab=c1..tab end
    if n%16<8 then tab=c0..tab else tab=c1..tab end
    if n%32<16 then tab=c0..tab else tab=c1..tab end
    if n%64<32 then tab=c0..tab else tab=c1..tab end
    if n%128<64 then tab=c0..tab else tab=c1..tab end
    charCodes[n]=tab
end

function decode(table)
    local res=0
    if table[7] then res=res+1 end
    if table[6] then res=res+2 end
    if table[5] then res=res+4 end
    if table[4] then res=res+8 end
    if table[3] then res=res+16 end
    if table[2] then res=res+32 end
    if table[1] then res=res+64 end
    return res
end

function compliant(text)
    for n=1,text:len() do
        if charValues[text:sub(n,n)]==nil then return false end
    end
    return true
end

inp=""
repeat
    print("(h)ide? (r)eveal?")
    inp=io.read()
until inp=="h" or inp=="r"

enc=inp=="h"

mundane=""
payload=""
result=""

if enc then
    repeat
        print("Carrier text? (The normal text that the message is hidden inside)")
        inp=io.read()
    until type(inp)=="string" and inp:len()>1
    mundane=inp

    repeat
        print("Payload text?")
        inp=io.read()
    until compliant(inp)
    payload=inp

    sectext=""
    for n=1,payload:len() do
        sectext=sectext..charCodes[charValues[payload:sub(n,n)]]
    end

    result=mundane:sub(1,1)..sectext..mundane:sub(2)

    --print("Result is stored in output.txt")
    --fil=io.open("output.txt","w")
    --fil:write(result)
    --fil:close()
    print("Text with embedded message stored in out.txt")
    local file=io.open("out.txt",'w')
    file:write(result)
else
    repeat
        print("Text with embedded message?")
        inp=io.read()
    until type(inp)=="string" and inp:len()>1
    result=inp

    payload=""
    block={}
    for n=1,result:len() do
        if result:sub(n,n+2)==c0 then
            block[#block+1]=false
        elseif result:sub(n,n+2)==c1 then
            block[#block+1]=true
        end
        if #block>=7 then
            payload=payload..charValues[decode(block)]
            block={}
        end
    end

    print(payload)
end
