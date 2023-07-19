--브레이브레이버
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,nil,s.pfun1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	--temp
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabel(0)
	WriteEff(e2,2,"O")
	Duel.RegisterEffect(e2,0)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_BURNED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,{id,1})
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
function s.pfun1(g,lc,sumtype,tp)
	return g:GetSum(Card.GetAttack)>=1000
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.tfil1(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsAttackAbove(2000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IEMCard(s.tfil1,tp,"HD",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"HD")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil1,tp,"HD",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	local burned=false
	for p=0,1 do
		local bz=aux.BurningZone[p]
		for i=1,#bz do
			local bc=bz[i]
			if bc==c then
				burned=p
				break
			end
		end
		if burned then
			break
		end
	end
	if burned then
		e:SetLabel(1)
		if label==0 then
			Duel.RaiseSingleEvent(c,EVENT_BURNED,e,0,burned,burned,0)
			Duel.RaiseEvent(Group.FromCards(c),EVENT_BURNED,e,0,burned,burned,0)
		end
	else
		e:SetLabel(0)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PREDRAW)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,1)
	e1:SetCondition(s.ocon31)
	e1:SetOperation(s.oop31)
	Duel.RegisterEffect(e1,tp)
end
function s.ocon31(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTR(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
		local sg=Group.CreateGroup()
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
		local tc=g:GetFirst()
		while tc do
			if tc:GetSequence()<dt then
				sg:AddCard(tc)
			end
			tc=g:GetNext()
		end
		if #sg>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_DRAW+REASON_RULE)
		end
		if #sg<dt then
			Duel.Win(1-tp,0x2)
		end
	end
end