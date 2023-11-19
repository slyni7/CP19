--그레이트 블루머
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,4,2,s.pfil1,aux.Stringid(id,0),2)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
end
function s.pfil1(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,18453865)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,id)
	local e1=MakeEff(token,"Qo")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	e1:SetCL(1,id)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCost(s.ocost11)
	Duel.RegisterEffect(e1,tp)
end
function s.ocost11(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id-20000)==0
		and Duel.IEMCard(s.otfil11,tp,"D",0,1,nil)
	local b2=Duel.GetFlagEffect(tp,id-10000)==0
		and Duel.IEMCard(s.otfil12,tp,"D",0,1,nil)
	if chk==0 then
		return (Duel.GetTurnCount()~=e:GetLabel() or Duel.IsPlayerAffectedByEffect(tp,18453867))
			and (b1 or b2)
	end
	if Duel.GetTurnCount()==e:GetLabel() then
		local te=Duel.IsPlayerAffectedByEffect(tp,18453867)
		local tc=te:GetHandler()
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
		Duel.RegisterFlagEffect(tp,id-20000,RESET_PHASE+PHASE_END,0,2)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetTarget(s.otar11)
		e:SetOperation(s.oop11)
	elseif op==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		Duel.RegisterFlagEffect(tp,id-10000,RESET_PHASE+PHASE_END,0,2)
		e:SetCategory(0)
		e:SetTarget(s.otar12)
		e:SetOperation(s.oop12)
	else
		e:SetCategory(0)
		e:SetTarget(s.otar13)
		e:SetOperation(s.oop13)
	end
end
function s.otfil11(c)
	return c:IsSetCard("레이트 블루") and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.otar11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.otfil11,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.otfil12(c)
	return c:IsSetCard("레이트 블루") and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.otar12(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.otfil12,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function s.otar13(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.oop13(e,tp,eg,ep,ev,re,r,rp)
end
function s.con2(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end