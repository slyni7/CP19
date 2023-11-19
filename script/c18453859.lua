--아세리마 오로라
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c,false)
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
	c:EnableReviveLimit()
	local e3=MakeEff(c,"S","E")
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(aux.penlimit)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","E")
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(s.con4)
	e4:SetTarget(s.tar4)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"S","M")
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCondition(s.con5)
	e5:SetValue(7)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetValue(1850)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"STo")
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetCL(1,{id,1})
	WriteEff(e7,7,"NTO")
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"STo")
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCL(1,{id,2})
	WriteEff(e8,8,"TO")
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_TO_DECK)
	e9:SetCondition(function(e)
		local c=e:GetHandler()
		return c:IsFaceup()
	end)
	c:RegisterEffect(e9)
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
function s.tfil2(c)
	return c:IsRace(RACE_MACHINE) and c:IsXyzSummonable()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"E",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil2,tp,"E",0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		local eid=e:GetFieldID()
		local tc=tg:GetFirst()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0,eid)
		Duel.XyzSummon(tp,tc)
		local mt=getmetatable(tc)
		if mt.eff_ct and mt.eff_ct[tc] then
			local ct=0
			while true do
				local te=mt.eff_ct[tc][ct]
				if te==nil then
					break
				end
				if te:IsHasType(EFFECT_TYPE_IGNITION) then
					local e1=te:Clone()
					e1:SetType(EFFECT_TYPE_QUICK_O)
					e1:SetCode(EVENT_FREE_CHAIN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
					tc:RegisterEffect(e1)
					local con=te:GetCondition()
					te:SetCondition(function(e,...)
						return tc:GetFlagEffectLabel(id)~=eid and (not con or con(e,...))
					end)
				end
				ct=ct+1
			end
		end
	end
end
function s.nfil4(c,tp,sc)
	return c:IsSetCard("아세리마") and not c:IsCode(id)
		and c:IsType(TYPE_PENDULUM) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.con4(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(s.nfil4,tp,"P",0,1,nil,tp,c)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SMCard(tp,s.nfil4,tp,"P",0,1,1,nil,tp,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function s.op4(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoExtraP(g,nil,REASON_COST+REASON_MATERIAL)
	c:SetMaterial(g)
	g:DeleteGroup()
end
function s.con5(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id-10000)==0
end
function s.con7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("P")) or (c:IsPreviousLocation(LSTN("E")) and c:IsPreviousPosition(POS_FACEUP))
end
function s.tfil7(c)
	return c:IsMonster() and c:IsSetCard("아세리마") and c:IsAbleToHand()
end
function s.tar7(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil7,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	c:RegisterFlagEffect(id-10000,RESET_EVENT+RESETS_STANDARD,0,0)
end
function s.op7(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil7,tp,"D",0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tar8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckPendulumZones(tp)
	end
end
function s.op8(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end