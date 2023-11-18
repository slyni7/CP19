--아세리마 스테어케이스
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	local e1=MakeEff(c,"FC","P")
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(s.tar1)
	e1:SetValue(s.val1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetD(id,0)
	e3:SetCondition(s.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_COST)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetOperation(s.op5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"STo")
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_DISABLE)
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"Qo","GE")
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e8,8,"CTO")
	c:RegisterEffect(e8)
end
function s.tfil1(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:IsSetCard("아세리마")
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.CheckLPCost(tp,1000) or Duel.IsPlayerAffectedByEffect(tp,18453862))
			and Duel.GetFlagEffect(tp,id)==0 and eg:IsExists(s.tfil1,1,nil,tp)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else
		return false
	end
end
function s.val1(e,c)
	local tp=e:GetHandlerPlayer()
	return s.tfil1(c,tp)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local te=Duel.IsPlayerAffectedByEffect(tp,18453862)
	if te then
		te:UseCountLimit(tp)
		te:GetOperation()(te,tp,eg,ep,ev,re,r,rp)
	else
		Duel.PayLPCost(tp,1000)
	end
	Duel.RaiseSingleEvent(c,id,e,REASON_EFFECT,tp,tp,0)
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
function s.con3(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocCount(c:GetControler(),"M")>0
end
function s.ocon4(e)
	return e:GetHandler():GetMaterialCount()==0
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(s.ocon4)
	e1:SetValue(7)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(s.ocon4)
	e2:SetValue(1850)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	c:RegisterEffect(e2)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(7)
	e1:SetReset(RESET_EVENT|(RESETS_STANDARD|RESET_DISABLE)&~(RESET_TOFIELD|RESET_LEAVE))
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(1850)
	e2:SetReset(RESET_EVENT|(RESETS_STANDARD|RESET_DISABLE)&~(RESET_TOFIELD|RESET_LEAVE))
	c:RegisterEffect(e2)
end
function s.tfil6(c)
	return c:IsType(TYPE_EFFECT) and c:IsNegatableMonster()
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and s.tfil6(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil6,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.STarget(tp,s.tfil6,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsNegatableMonster() then
		local c=e:GetHandler()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function s.cfil8(c)
	return c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()
end
function s.cost8(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.cfil8,tp,LSTN("HOGER"),0,c)
	if chk==0 then
		return #sg>=7 and Duel.GetMZoneCount(tp,sg)>0
	end
	local g
	if Duel.GetLocCount(tp,"M")==0 then
		g=aux.SelectUnselectGroup(sg,e,tp,7,7,aux.ChkfMMZ(1),1,tp,HINTMSG_TODECK)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=sg:Select(tp,7,7,nil)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.tar8(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.op8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end