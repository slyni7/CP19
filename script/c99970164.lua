--파이어워크 에테르
local m=99970164
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	c:EnableReviveLimit()
	
	--소환 조건
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetCountLimit(1,m)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,199970164)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	
	--데미지
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	
	if not cm.global_check then
	cm.global_check=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge1:SetLabel(m)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ge1:SetOperation(aux.sumreg)
	Duel.RegisterEffect(ge1,0)
	end
	
end

--소환 조건
function cm.tgfilter(c)
	return c:IsCode(46130346,73134081,19523799,46918794,33767325) and c:IsAbleToGrave()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.ShuffleDeck(tp)
end

--특수 소환
function cm.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xd3d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--데미지
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_BATTLE)==0 and re and re:GetHandler():GetCode()~=m
		and (re:GetHandler():IsSetCard(0xd3d) or re:GetHandler():GetType()==TYPE_SPELL)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

--서치 + 데미지
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)~=0 end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.op4fil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op4fil(c,e,tp)
	if not c:IsSetCard(0x3d3) then return end
	if c:IsType(TYPE_MONSTER) then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then 
		return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()
	end
	return false
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsAbleToDeck()
		and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
		local tc=Duel.SelectMatchingCard(tp,cm.op4fil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		end
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			if tc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
				end
			end
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.SSet(tp,tc)
			end
		end
	end
end
