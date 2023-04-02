--네임스퀘어페이스퀘어
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
end
s.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,0x0,0x0}
s.custom_type=CUSTOMTYPE_SQUARE