--아세리마 캐리어크래프트
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c,false)
	Xyz.AddProcedure(c,nil,9,2,s.pfil1,aux.Stringid(id,0),2,s.pop1)
	local e1=MakeEff(c,"FC","P")
	e1:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_CHANGE_RANK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(s.con3)
	e3:SetValue(7)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(2850)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"I","M")
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCL(1,{id,1})
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"STo")
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCL(1,{id,2})
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_TO_DECK)
	e7:SetCondition(function(e)
		local c=e:GetHandler()
		return c:IsFaceup()
	end)
	c:RegisterEffect(e7)
end
s.pendulum_level=7
function s.pfil2(c)
	return c:IsSetCard("아세리마") and c:IsType(TYPE_PENDULUM)
end
function s.pfil1(c,tp,lc)
	return c:IsFaceup() and c:IsRank(7) and c:IsRace(RACE_MACHINE)
end
function s.pop1(e,tp,chk,mc)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.pfil2,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.GetMatchingGroup(s.pfil2,tp,LOCATION_HAND,0,nil):SelectUnselect(Group.CreateGroup(),tp,false,Xyz.ProcCancellable)
	if tc then
		Duel.SendtoExtraP(tc,nil,REASON_COST)
		return true
	else
		return false
	end
end
function s.nfil1(c,tp)
	return c:IsFaceup() and c:IsSetCard("아세리마") and c:IsControler(tp) and c:IsOnField()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or Duel.GetFlagEffect(tp,id)~=0 then
		return false
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.nfil1,1,nil,tp) and Duel.IsChainDisablable(ev)
		and (Duel.CheckLPCost(tp,1000) or Duel.IsPlayerAffectedByEffect(tp,18453862))
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		return
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) then
		Duel.BreakEffect()
		local te=Duel.IsPlayerAffectedByEffect(tp,18453862)
		if te then
			te:UseCountLimit(tp)
			te:GetOperation()(te,tp,eg,ep,ev,re,r,rp)
		else
			Duel.PayLPCost(tp,1000)
		end
		Duel.RaiseSingleEvent(c,id,e,REASON_EFFECT,tp,tp,0)
	end
end
function s.tfil2(c,e,tp)
	return c:IsSetCard("아세리마") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"DE",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DE")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SMCard(tp,s.tfil2,tp,"DE",0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.con3(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id-10000)==0
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(s.tfil2,tp,"P",0,nil,e,tp)
	local og=c:GetOverlayGroup()
	g:Merge(og:Filter(s.tfil2,nil,e,tp))
	if chk==0 then
		return #g>0 and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"PO")
	c:RegisterFlagEffect(id-10000,RESET_EVENT+RESETS_STANDARD,0,0)
end
function s.ofil5(c)
	return c:IsSetCard("아세리마") and c:IsType(TYPE_PENDULUM)
end
function s.ofun5(g)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	return fc and nc and fc:GetLeftScale()~=nc:GetLeftScale()
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(s.tfil2,tp,"P",0,nil,e,tp)
	if c:IsRelateToEffect(e) then
		local og=c:GetOverlayGroup()
		g:Merge(og:Filter(s.tfil2,nil,e,tp))
	end
	local ft=Duel.GetLocCount(tp,"M")
	if ft<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ft,nil)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		if Duel.CheckLocation(tp,LSTN("P"),0) and Duel.CheckLocation(tp,LSTN("P"),1) then
			local pg=Duel.GMGroup(s.ofil5,tp,"D",0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tg=pg:SelectSubGroup(tp,s.ofun5,true,2,2)
			if tg then
				local fc=tg:GetFirst()
				Duel.MoveToField(fc,tp,tp,LSTN("P"),POS_FACEUP,true)
				local nc=tg:GetNext()
				Duel.MoveToField(nc,tp,tp,LSTN("P"),POS_FACEUP,true)
			end
		end
	end
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckPendulumZones(tp)
	end
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end