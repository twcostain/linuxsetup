#Instructions to remap the return key on a CM Storm TK Stealth keyboard
1. Run `xev` to find the keys that you want to map
2. Run `xmodmap -e "keycode 104 = Return"`
3. Run `xmodmap -pke > ~/.Xmodmap`
4. Add `xmodmap .Xmodmap` to `.xinitrc`
