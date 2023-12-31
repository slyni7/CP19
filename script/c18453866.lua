--레이트 블루오션
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"Qo","HM")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,id)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.ofil1(c)
	return c:IsCode(18453871)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LSTN("F"),POS_FACEUP,true)
	else
		local token=Duel.CreateToken(tp,id)
		local e1=MakeEff(token,"Qo")
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetReset(RESET_PHASE+PHASE_END,3)
		e1:SetCL(1,{id,1})
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCost(s.ocost11)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.ocost11(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id-20000)==0
		and not (Duel.GetCurrentPhase()>=PHASE_DAMAGE and Duel.GetCurrentPhase()<PHASE_BATTLE)
		and Duel.IETarget(s.otfil11,tp,"G",0,1,nil)
	local cc=Duel.GetCurrentChain()
	if chk==1 then
		cc=cc-1
	end
	local ce=Duel.GetChainInfo(cc,CHAININFO_TRIGGERING_EFFECT)
	local cp=Duel.GetChainInfo(cc,CHAININFO_TRIGGERING_PLAYER)
	local b2=Duel.GetFlagEffect(tp,id-10000)==0
		and Duel.IEMCard(s.onfil12,tp,"M",0,1,nil)
		and ce and ce:IsActiveType(TYPE_MONSTER) and cp~=tp
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
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e:SetCategory(CATEGORY_TOHAND)
		e:SetTarget(s.otar11)
		e:SetOperation(s.oop11)
	elseif op==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		Duel.RegisterFlagEffect(tp,id-10000,RESET_PHASE+PHASE_END,0,2)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e:SetTarget(s.otar12)
		e:SetOperation(s.oop12)
	else
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e:SetCategory(0)
		e:SetTarget(s.otar13)
		e:SetOperation(s.oop13)
	end
end
function s.otfil11(c)
	return c:IsSetCard("레이트 블루")
		and (c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY or c:GetType()==TYPE_TRAP)
		and (c:IsAbleToHand() or c:IsSSetable())
end
function s.otar11(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and s.otfil11(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.otfil11,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,s.otfil11,tp,"G",0,1,1,nil)
	Duel.SPOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		aux.ToHandOrElse(tc,tp,
			Card.IsSSetable,
			function(c)
				Duel.SSet(tp,tc)
			end,
			aux.Stringid(id,2)
		)
	end
end
function s.onfil12(c)
	return c:IsSetCard("레이트 블루") and c:IsFaceup()
end
function s.otar12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local cc=Duel.GetCurrentChain()-1
	local ce=Duel.GetChainInfo(cc,CHAININFO_TRIGGERING_EFFECT)
	local ec=ce:GetHandler()
	if ec:IsRelateToEffect(ce) then
		Duel.SOI(0,CATEGORY_DESTROY,ec,1,0,0)
	end
	Duel.SOI(0,CATEGORY_NEGATE,ec,1,0,0)
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()-1
	local ce=Duel.GetChainInfo(cc,CHAININFO_TRIGGERING_EFFECT)
	local ec=ce:GetHandler()
	if Duel.NegateActivation(cc) and ec:IsRelateToEffect(ce) then
		Duel.Destroy(ec,REASON_EFFECT)
	end
end
function s.otar13(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.oop13(e,tp,eg,ep,ev,re,r,rp)
end