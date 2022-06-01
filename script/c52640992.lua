--혼성신 
local m=52640992
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(cm.spcon)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
--function cm.cfilter(c)
--    return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_RITUAL)+c:IsType(TYPE_FUSION)+c:IsType(TYPE_SYNCHRO)+c:IsType(TYPE_XYZ)+c:IsType(TYPE_LINK)
--		+c:IsType(TYPE_ORDER)+c:IsType(TYPE_MODULE)+c:IsType(TYPE_PENDULUM)+c:IsType(TYPE_UNION)+c:IsType(TYPE_TOON)+c:IsType(TYPE_FLIP)
--		+c:IsType(TYPE_TUNER)+c:IsType(TYPE_SPIRIT)+c:IsType(TYPE_DUAL)+c:IsType(TYPE_SPSUMMON)+c:IsType(TYPE_NORMAL)
--		
--end
function cm.cfilter(c,tt)
    return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsType(tt)
end

function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
	local listTable = {TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_ORDER,TYPE_MODULE,TYPE_PENDULUM,TYPE_UNION,TYPE_TOON,TYPE_FLIP,TYPE_TUNER,TYPE_SPIRIT,TYPE_DUAL,TYPE_SPSUMMON,TYPE_NORMAL}
    for i=1,#listTable do
		if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,listTable[i]) then return false end
	end
	return true 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE,LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler())
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
