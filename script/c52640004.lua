local m=52640004
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change main
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.chcon)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--reverse deck
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_REVERSE_DECK)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_REMOVE_REDIRECT)
	e5:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE)
	e5:SetValue(LOCATION_HAND)
	c:RegisterEffect(e5)
	--to grave
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_TO_HAND_REDIRECT)
	e6:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE)
	e6:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e6)
end
function cm.chfilter(c,tp)
	return c:IsFaceup() and c:GetSequence()<5
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.chfilter,1,nil,tp) or eg:IsExists(cm.chfilter,1,nil,1-tp)
end
function cm.filter(c)
	return not c:IsAbleToChangeControler()
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if chk==0 then return g:FilterCount(cm.filter,nil)==0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function cm.swapfilter(c)
	return c:GetSequence()<5
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if chk==0 then return g:FilterCount(cm.filter,nil)==0 end
	local g1=Duel.GetMatchingGroup(cm.swapfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.swapfilter,tp,0,LOCATION_MZONE,nil)
	ct1=g1:GetCount()
	ct2=g2:GetCount()
	if ct1 >= ct2 then
		
		local sg1=Duel.GetMatchingGroup(cm.swapfilter,tp,LOCATION_MZONE,0,nil):RandomSelect(tp,ct2)
		local sg2=Duel.GetMatchingGroup(cm.swapfilter,tp,0,LOCATION_MZONE,nil)
		local sg3=Duel.GetMatchingGroup(cm.swapfilter,tp,LOCATION_MZONE,0,nil)-sg1
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0) >= sg3:GetCount() then
		Duel.SwapControl(sg1,sg2)
		Duel.GetControl(sg3,1-tp)
		end
	end
	if ct2 > ct1 then
		local sg1=Duel.GetMatchingGroup(cm.swapfilter,tp,LOCATION_MZONE,0,nil)
		local sg2=Duel.GetMatchingGroup(cm.swapfilter,tp,0,LOCATION_MZONE,nil):RandomSelect(tp,ct1)
		local sg3=Duel.GetMatchingGroup(cm.swapfilter,tp,0,LOCATION_MZONE,nil)-sg2
		if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0) >= sg3:GetCount() then
		Duel.SwapControl(sg1,sg2)
		Duel.GetControl(sg3,tp)
		end
	end
end