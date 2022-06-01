--커럽티드 데이터 유닛
local m=99000353
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,nil,cm.spcheck)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(cm.tgcon)
	e3:SetValue(cm.tgtg)
	c:RegisterEffect(e3)
end
function cm.spcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==1
		and g:GetClassCount(Card.GetLinkAttribute)==1
end
function cm.cfilter(c,e,tp,lg)
	if not (c:IsFaceup() and c:GetLevel()>0 and lg:IsContains(c)) then
		return false
	end
	local ok=false
	for p=0,1 do
		local zone=e:GetHandler():GetLinkedZone(p)&0xff
		ok=ok or (Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,99000354,0,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute()))
	end
	return ok
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	local lg=c:GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc,e,tp,lg) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lg)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,99000354,0,0x4011,tc:GetAttack(),tc:GetDefense(),tc:GetLevel(),tc:GetRace(),tc:GetAttribute()) then return end
	local zone={}
	local flag={}
	for p=0,1 do
		zone[p]=c:GetLinkedZone(p)&0xff
		local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
		flag[p]=(~flag_tmp)&0x7f
	end
	local token=Duel.CreateToken(tp,99000354)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(tc:GetLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetAttribute())
	token:RegisterEffect(e5)
	if token then
		local ava_zone=0
		for p=0,1 do
			if token:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone[p]) then
				ava_zone=ava_zone|(flag[p]<<(p==tp and 0 or 16))
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~ava_zone))
		local sump=0
		if sel_zone&0xff>0 then
			sump=tp
		else
			sump=1-tp
			sel_zone=sel_zone>>16
		end
		if Duel.SpecialSummonStep(token,0,tp,sump,false,false,POS_FACEUP,sel_zone) then
			local e11=Effect.CreateEffect(e:GetHandler())
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_UNRELEASABLE_SUM)
			e11:SetValue(1)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e11,true)
			local e12=e11:Clone()
			e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e12,true)
			local e13=e11:Clone()
			e13:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e13,true)
			local e14=e11:Clone()
			e14:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			token:RegisterEffect(e14,true)
			local e15=e11:Clone()
			e15:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e15,true)
			local e16=e11:Clone()
			e16:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e16:SetValue(cm.fuslimit)
			token:RegisterEffect(e16,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function cm.tgcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,99000316)
end
function cm.tgtg(e,c)
	return c~=e:GetHandler()
end