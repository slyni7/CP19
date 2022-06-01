--[ Tinnitus ]
local m=99970476
local cm=_G["c"..m]
function cm.initial_effect(c)

	--토큰
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--파괴 방지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0xe1c,TYPES_TOKEN,0,1500,1,RACE_MACHINE,0,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0xe1c,TYPES_TOKEN,0,1500,1,RACE_MACHINE,0,POS_FACEUP_DEFENSE,1-tp) then return end
	local token=Duel.CreateToken(tp,m+1)
	if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		token:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
		token:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
		token:RegisterEffect(e6,true)
		local e7=e1:Clone()
		--[[
		e7:SetCode(EFFECT_CANNOT_BE_SQUARE_MATERIAL)
		token:RegisterEffect(e7,true)
		local e8=e1:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_BEYOND_MATERIAL)
		token:RegisterEffect(e8,true)
		local e9=e1:Clone()
		e9:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		token:RegisterEffect(e9,true)
		]]
	end
	Duel.SpecialSummonComplete()
	token:AddCounter(0x1e1c,2,REASON_EFFECT)
end

--파괴 방지
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe1c) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.op0fil(c,e)
	return not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(cm.op0fil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	Duel.BreakEffect()
	for tc in aux.Next(g) do
		tc:AddCounter(0x1e1c,1,REASON_EFFECT)
	end
end
