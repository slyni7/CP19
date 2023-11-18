--레이트 블루레이
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.pfil1,1,1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
end
function s.pfil1(c)
	return not c:IsType(TYPE_LINK) and c:IsSetCard("레이트 블루")
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,id)
	local e1=MakeEff(token,"Qo")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	e1:SetCL(1,id)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCost(s.ocost11)
	e1:SetTarget(s.otar11)
	e1:SetOperation(s.oop11)
	Duel.RegisterEffect(e1,tp)
	local e1=MakeEff(token,"Qo")
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END,3)
	e2:SetCL(1,id)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(s.con12)
	e2:SetCost(s.ocost12)
	e2:SetTarget(s.otar12)
	e2:SetOperation(s.oop12)
	Duel.RegisterEffect(e2,tp)
end
function s.ocost11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.GetTurnCount()~=e:GetLabel() or Duel.IsPlayerAffectedByEffect(tp,18453867))
			and Duel.GetFlagEffect(tp,id-20000)==0
	end
	if Duel.GetTurnCount()==e:GetLabel() then
		local te=Duel.IsPlayerAffectedByeffect(tp,18453867)
		local tc=te:GetHandler()
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function s.otfil11(c,e,tp)
	return c:IsSetCard("레이트 블루") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.otar11(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and s.otfil11(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(s.otfil11,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.otfil11,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function s.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and ep~=tp
end
function s.ocost12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.GetTurnCount()~=e:GetLabel() or Duel.IsPlayerAffectedByEffect(tp,18453867))
			and Duel.GetFlagEffect(tp,id-10000)==0
	end
	if Duel.GetTurnCount()==e:GetLabel() then
		local te=Duel.IsPlayerAffectedByeffect(tp,18453867)
		local tc=te:GetHandler()
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function s.otar12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end