--트랜캐스터 더미 토큰
local m=47300100
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end

cm.square_mana={0x0,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE