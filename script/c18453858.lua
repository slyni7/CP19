--아세리마 유스티티아
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
	local e4=MakeEff(c,"S","M")
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCondition(s.con4)
	e4:SetValue(7)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_BASE_ATTACK)
	e5:SetValue(1850)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"Qo","M")
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCategory(CATEGORY_NEGATE)
	e6:SetCL(1,id)
	WriteEff(e6,6,"NCTO")
	c:RegisterEffect(e6)
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
function s.con4(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id-10000)==0
end
function s.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function s.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.CheckLPCost(tp,1000) or Duel.IsPlayerAffectedByEffect(tp,18453862))
	end
	local te=Duel.IsPlayerAffectedByEffect(tp,18453862)
	if te then
		te:UseCountLimit(tp)
		te:GetOperation()(te,tp,eg,ep,ev,re,r,rp)
	else
		Duel.PayLPCost(tp,1000)
	end
	c:RegisterFlagEffect(id-10000,RESET_EVENT+RESETS_STANDARD,0,0)
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
