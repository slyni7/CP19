--아세리마 안단테
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,7,2)
	c:EnableReviveLimit()
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
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(s.con3)
	e3:SetValue(1850)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","M")
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetCL(1,{id,1})
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCL(1,{id,2})
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_TO_DECK)
	e6:SetCondition(function(e)
		local c=e:GetHandler()
		return c:IsFaceup()
	end)
	c:RegisterEffect(e6)
end
s.pendulum_level=7
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
	return c:IsSetCard("아세리마") and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.con3(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id-10000)==0
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(id-10000,RESET_EVENT+RESETS_STANDARD,0,0)
end
function s.tfil4(c,e,tp)
	return c:IsMonster() and c:IsSetCard("아세리마") and c:IsLevel(9)
		and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocCount(tp,"M")>0))
		and (not c:IsLoc("E") or c:IsFaceup())
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil4,tp,"DGPE",0,1,nil,e,tp)
	end
	Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"DGPE")
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DGPE")
	c:RegisterFlagEffect(id-10000,RESET_EVENT+RESETS_STANDARD,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil4,tp,"DGPE",0,1,1,nil,e,tp):GetFirst()
	if not tc then
		return
	end
	aux.ToHandOrElse(tc,tp,
		function(sc)
			return sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
		end,
		function(sc)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end,
		aux.Stringid(id,2)
	)
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckPendulumZones(tp)
	end
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end