--함대 소집: 북방 연합
--카드군 번호: 0xc99, 0xc9a
local m=81258090
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetUniqueOnField(1,0,m)
	
	--발동시
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--특수소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--특수소환
function cm.nfil0(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0xc99) and not c:IsType(TYPE_MODULE)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MODULE)
end
function cm.spfil1(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_MODULE) and c:IsSetCard(0xc99)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.spfil0,tp,0x10,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.spfil1,tp,0x40,0,1,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return ( b1 and ft>0 ) or b2
	end
	local s=0
	if ( b1 and ft>0 ) and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if (not b1 or ft<0 or Duel.IsPlayerAffectedByEffect(tp,47355498) ) and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if b1 and ft>0 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	if s==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)		
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x10,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local mg=Duel.GetMatchingGroup(cm.spfil1,tp,0x40,0,nil)
		if #mg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.SpecialSummonRule(tp,tc,tc:GetSummonType())
		end
	end
end
