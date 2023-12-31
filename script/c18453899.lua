--vingt et un ~avant-garde~
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	aux.GlobalCheck(s,function()
		s.should_check=false
		local geff=MakeEff(c,"F")
		geff:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		geff:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		geff:SetTR(1,1)
		geff:SetTarget(function(e,c)
			if s.should_check then
				return not c:IsSetCard("vingt et un")
			end
			return false
		end)
		Duel.RegisterEffect(geff,0)
	end)
end
function s.tfil2(c)
	return c:IsSetCard("vingt et un") and c:IsFaceup() and c:IsDisabled()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"O",0,1,nil)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(s.tfil2,tp,"O",0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=MakeEff(c,"S")
		e1:SetCode(id)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"F")
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		e2:SetReset(RESET_CHAIN)
		e2:SetLabelObject(tc)
		e2:SetValue(function(e,ct)
			local te,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
			return te:GetHandler()==e:GetLabelObject() and loc&LOCATION_ONFIELD~=0
		end)
		Duel.RegisterEffect(e2,tp)
		Duel.AdjustInstantly(tc)
		tc=g:GetNext()
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		s.should_check=true
		local res=Duel.IsPlayerCanPendulumSummon(tp)
		s.should_check=nil
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"EH")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.PendulumSummon(tp)
	s.oop31(c)
end
function s.oop31(c)
	s.should_check=true
	local eff=MakeEff(c,"FC")
	eff:SetCode(EVENT_CHAIN_END)
	eff:SetOperation(function(e)
		e:Reset()
		s.should_check=false
	end)
	Duel.RegisterEffect(eff,0)
end