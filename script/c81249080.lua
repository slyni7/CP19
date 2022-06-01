--사악종의 결박
--카드군 번호: 0xc83
local m=81249080
local cm=_G["c"..m]
function cm.initial_effect(c)

	--소재 금지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--소재 금지
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc83) and c:IsType(0x1)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x04+0x10,0,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x04+0x10,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local sel=0
	sel=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if sel==0 then
		local rate=Duel.AnnounceRace(tp,1,RACE_ALL)
		e:SetOperation(cm.racop)
		e:SetLabel(rate)
	else
		local rate=Duel.AnnounceAttribute(tp,1,0xffff)
		e:SetOperation(cm.attop)
		e:SetLabel(rate)
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(1-tp)
end
function cm.lmf(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
--속성
function cm.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetTargetRange(0,0x04)
	e1:SetTarget(cm.attfil0)
	e1:SetValue(cm.lmf)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e4,tp)
	local e5=e2:Clone()
	e5:SetCode(CYAN_EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	Duel.RegisterEffect(e5,tp)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
	Duel.RegisterEffect(e6,tp)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
	Duel.RegisterEffect(e7,tp)
end
function cm.attfil0(e,c)		
	return c:IsAttribute(e:GetLabel())
end
--종족
function cm.racop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetTargetRange(0,0x04)
	e1:SetTarget(cm.racfil0)
	e1:SetValue(cm.lmf)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e4,tp)
	local e5=e2:Clone()
	e5:SetCode(CYAN_EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	Duel.RegisterEffect(e5,tp)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
	Duel.RegisterEffect(e6,tp)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
	Duel.RegisterEffect(e7,tp)
end
function cm.racfil0(e,c)
	return c:IsRace(e:GetLabel())
end

--특수 소환
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,0x02+0x0c,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,0x04)
	if ct1>=ct2 then
		return false
	end
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc83) and c:IsFaceup()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x20,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x20)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,0x04)
	if ft<=0 then
		return
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x20,0,ft,ft,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
